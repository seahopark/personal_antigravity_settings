# Recommended permission grants

Antigravity's permission engine evaluates every sensitive action
(`read_file`, `write_file`, `command`, `mcp`, `read_url`, `execute_url`)
against three lists: **Deny** (blocked immediately), **Ask** (pauses for
approval), **Allow** (auto-approved). See
[antigravity.google/docs/permissions](https://antigravity.google/docs/permissions).

This is guidance to paste into the Customizations → Permissions panel, not a
file Antigravity reads automatically — the docs don't specify a plain
config file for this the way they do for rules/skills/hooks, so treat this
as a starting list to review and adjust per project rather than something
to apply blindly.

## Deny — block regardless of context

```
command(rm -rf)
command(sudo)
command(git push --force)
command(git reset --hard)
write_file(.git/)
write_file(.ssh/)
write_file(.env)
```

`.env` is included because Antigravity operating with write access to it
could silently rewrite credentials; extend this list with any other
secrets files specific to a project.

## Allow — skip the prompt for routine, low-risk work

```
command(git status)
command(git diff)
command(git log)
command(git add)
command(npm run (build|lint|test|check))
command(tsc)
```

Deliberately excludes `git commit`, `git push`, and any deploy command —
those stay on Ask so a human confirms before anything leaves the local
machine, matching the "actions visible to others" caution already used
elsewhere in this workflow.

## Ask — leave as default unless you have a specific reason not to

Everything not explicitly listed above defaults to Ask already. Don't
broaden `command(*)` or `mcp(*)` to Allow — grant specific prefixes as they
come up instead of pre-approving whole categories.
