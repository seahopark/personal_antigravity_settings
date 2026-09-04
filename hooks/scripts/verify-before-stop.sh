#!/usr/bin/env bash
# Stop hook for Antigravity — enforces the "verify-real-behavior" skill
# instead of just hoping the agent reads and follows it.
#
# Reads the Stop event payload from stdin (see:
# https://antigravity.google/docs/hooks), and if the session edited files
# but the transcript shows no evidence of a build/lint/test command having
# been run, forces the agent to keep going once instead of letting it stop.
#
# This is a heuristic, not a guarantee: it greps transcript.jsonl for tool
# names and command strings rather than parsing a documented schema. The
# patterns below were checked on 2026-09-04 against real IDE transcripts
# under ~/.gemini/antigravity-ide/brain/*/.system_generated/logs/, where
# tool calls appear as {"name":"run_command","args":{"CommandLine":...}}.
# Re-check them if Antigravity changes the transcript format.
#
# Requires: jq. On Windows, run this under WSL or Git Bash and confirm
# Antigravity actually invokes hooks through a shell that can find bash.

set -euo pipefail

INPUT="$(cat)"

# Cap forced continuations per conversation so a wrong heuristic can't loop
# forever — nag once, then get out of the way regardless.
MAX_FORCED_CONTINUES=1
STATE_DIR="${TMPDIR:-/tmp}/antigravity-verify-hook"
mkdir -p "$STATE_DIR"

CONVERSATION_ID="$(echo "$INPUT" | jq -r '.conversationId // empty')"
FULLY_IDLE="$(echo "$INPUT" | jq -r '.fullyIdle // false')"
TRANSCRIPT_PATH="$(echo "$INPUT" | jq -r '.transcriptPath // empty')"

allow() { echo '{"decision":"allow"}'; exit 0; }

# Only intervene when the agent is actually finishing, not mid-background-task.
[ "$FULLY_IDLE" = "true" ] || allow
[ -n "$CONVERSATION_ID" ] || allow
[ -n "$TRANSCRIPT_PATH" ] && [ -r "$TRANSCRIPT_PATH" ] || allow

COUNT_FILE="$STATE_DIR/$CONVERSATION_ID.count"
PRIOR_COUNT=0
[ -f "$COUNT_FILE" ] && PRIOR_COUNT="$(cat "$COUNT_FILE")"
[ "$PRIOR_COUNT" -lt "$MAX_FORCED_CONTINUES" ] || allow

# Both patterns are matched against *scoped* extractions, never the raw
# transcript. Grepping the whole file gives false positives that silently
# defeat the hook: reading a package.json or listing a directory containing
# eslint.config.js would otherwise count as "a linter ran".
EDIT_TOOL_PATTERN='"name":"(write_to_file|replace_file_content|multi_replace_file_content)"'
VERIFY_CMD_PATTERN='npm run (build|lint|test|check)|(^|[^a-zA-Z])tsc([^a-zA-Z]|$)|eslint|pytest|go test|cargo test|jest|vitest'

# Tool calls appear as {"name":"<tool>","args":{...}}; command invocations
# carry their shell string in the CommandLine arg, JSON-escaped one level
# deep (e.g. "CommandLine":"\"npm run build\""), hence the (\\.|[^"\\])*
# body to step over the embedded \" pairs.
if ! grep -Eq "$EDIT_TOOL_PATTERN" "$TRANSCRIPT_PATH"; then
  # No file edits this session — nothing to verify.
  allow
fi

RUN_COMMANDS="$(grep -oE '"CommandLine":"(\\.|[^"\\])*"' "$TRANSCRIPT_PATH" || true)"

if printf '%s' "$RUN_COMMANDS" | grep -Eiq "$VERIFY_CMD_PATTERN"; then
  # Found evidence a verification command actually ran.
  allow
fi

echo "$((PRIOR_COUNT + 1))" > "$COUNT_FILE"
jq -n '{decision: "continue", reason: "Files were edited but no build/lint/test command shows up in this session. Run the project'\''s verification command and confirm it passes before finishing."}'
