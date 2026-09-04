# personal_antigravity_settings

Portable [Antigravity IDE](https://antigravity.google) harness configuration
— kept outside any single project so it survives moving to a new dev
machine. Covers four of Antigravity's customization layers: rules, skills,
hooks, and permission grants.

## Why this repo exists

Antigravity's configuration lives either on a single machine's filesystem
(`~/.gemini/...`) or inside a single project's git history
(`.agents/...`). Neither survives a dev-PC switch on its own. This repo is
the portable source: pull it on any new machine and copy from here into
wherever Antigravity expects each kind of file on that machine.

## Layers, in order of how much they actually get followed

1. **Rules** (`rules/`) — plain instructions. The model reads them and
   decides whether to comply. Real-world reports (see e.g. the
   [Google AI Developers Forum bug thread](https://discuss.ai.google.dev/t/bug-feedback-antigravity-2-2-1-models-not-following-global-nor-agents-rules-fake-using-skills-tools/172904))
   describe rules — even `always_on` ones — being ignored or "faked"
   (the agent claims compliance without doing the thing). Treat rules as
   guidance, not enforcement.
2. **Skills** (`skills/`) — same idea as rules, but with a documented
   loading mechanism: only `name` + `description` sit in context by
   default, full instructions load on demand when relevant. Cheaper than
   `always_on` rules, and the *loading* behavior is actually specified
   (unlike a rule's `model_decision` trigger, whose internals aren't
   documented anywhere). Still relies on the model choosing to comply once
   loaded — same reliability ceiling as rules.
3. **Hooks** (`hooks/`) — real shell commands that run at fixed points in
   the execution loop and can force a decision (`allow` / `deny` /
   `continue`) — this is the one layer that isn't just asking the model
   nicely. See `hooks/hooks.json`.
4. **Permissions** (`permissions/`) — a separate Allow/Deny/Ask engine
   gating file/command/MCP/URL access, independent of what any rule or
   skill says.

`.agent/workflows/` is not included here — Antigravity deprecated it in
favor of Skills in May 2026 (sunset November 1, 2026); see
[the migration guide](https://antigravity.google/docs/migration/workflows-to-skills/).

## How to use it

**Skills** (recommended home for anything substantial):

```bash
cp -r skills/* /path/to/project/.agents/skills/
# or globally, for every project on this machine:
cp -r skills/* ~/.gemini/config/skills/
```

**Rules** — only `markdown-syntax.md` lives here; it's short and broadly
applicable enough that the `always_on` vs `model_decision` cost tradeoff
barely matters:

```bash
cp rules/*.md /path/to/project/.agents/rules/
```

**Hooks** — copy both the config and the script together, preserving the
relative path (`hooks.json` expects `./scripts/...`):

```bash
mkdir -p /path/to/project/.agents
cp hooks/hooks.json /path/to/project/.agents/
cp -r hooks/scripts /path/to/project/.agents/
```

The included `verify-before-stop.sh` is a heuristic (greps the session
transcript for evidence a build/lint/test command ran before letting the
agent finish) — it was unit-tested against synthetic input, not against a
real transcript.jsonl, since its exact schema isn't publicly documented.
Read the comments at the top of the script before trusting it, and check a
real transcript once you have one to confirm the grep patterns actually
match.

**Permissions** — `permissions/recommended-permissions.md` is guidance to
paste into the Customizations → Permissions panel in the IDE, not a file
Antigravity reads automatically.

## Contents

- `rules/markdown-syntax.md` — formatting conventions for any markdown
  Antigravity writes.
- `skills/implementation-plan/` — what an implementation plan must contain
  before coding starts (scope survey, variant enumeration, shared data
  contract, deprecation decision).
- `skills/single-source-of-truth/` — don't reimplement the same
  classification logic or boundary values in more than one place.
- `skills/interaction-content-separation/` — keep interaction mechanics
  (how something responds) separate from content (what it shows).
- `skills/deprecation-and-reuse/` — when replacing existing code, the
  replaced code must actually get cleaned up, not left orphaned.
- `skills/no-silent-failure/` — don't catch-and-ignore errors, especially
  around side-effect calls like analytics or submission.
- `skills/verify-real-behavior/` — a passing build/lint/type-check is not
  confirmation a feature actually works; go run it.
- `skills/preserve-behavior-through-rewrites/` — a broad rewrite must not
  silently drop safety-critical logic or existing interactions.
- `hooks/hooks.json` + `hooks/scripts/verify-before-stop.sh` — enforces
  `verify-real-behavior` at the loop level instead of hoping it's read.
- `permissions/recommended-permissions.md` — starting Allow/Deny list for
  the Permissions panel.

## Provenance

Distilled from a 2026-09-04 refactor + code-review session on the
[jammae](https://github.com/seahopark/jammae) codebase, generalized to
apply beyond that one project.
