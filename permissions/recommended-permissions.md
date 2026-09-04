# Recommended permission grants

Antigravity's permission engine evaluates every sensitive action
(`read_file`, `write_file`, `command`, `mcp`, `read_url`, `execute_url`)
against three lists: **Deny** (blocked immediately), **Ask** (pauses for
approval), **Allow** (auto-approved). See
[antigravity.google/docs/permissions](https://antigravity.google/docs/permissions).

## Where this actually lives (confirmed 2026-09-04)

Permission grants are real files, not just a UI-only setting:

- **Global**: `~/.gemini/config/config.json`, under
  `userSettings.globalPermissionGrants.allow` (a flat array of permission
  strings, e.g. `"command(git add)"`).
- **Per-project**: `~/.gemini/config/projects/<project-uuid>.json`, under
  `permissionGrants.permissionGrants.allow` — note the doubled key, this is
  the real on-disk shape, not a typo. Project-level grants take precedence
  over global ones.

The exact key name for a **deny** list hasn't been confirmed — the file
only had `allow` populated when checked, with no `deny` key present at all.

**These files are owned by the running app.** Editing them directly while
Antigravity is open risks the app overwriting your edit with whatever it
still has in memory. Use the UI (**Settings → Global Settings → Permission
Grants**, or **Project-Level Settings → Permission Grants** for a specific
project) instead of hand-editing the JSON, even though the JSON is real.

## How to apply this safely

1. In Settings → Permission Grants, add one Deny entry (e.g.
   `command(sudo)`) through the UI.
2. Close Antigravity, then open `~/.gemini/config/config.json` and confirm
   the actual key name it used for the deny list. Update this doc once
   known.
3. Add the rest of the list below through the same UI panel — for ~10
   entries this is faster and safer than trying to script it.

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

Note the parenthesized alternation on `npm run` — grant the specific
subcommands you actually want auto-approved, not a bare `command(npm run)`.
Matching is prefix-based, so an ungated `command(npm run)` also silently
auto-approves things like `npm run deploy` or `npm run publish` that you
probably want a human to see first.

Deliberately excludes `git commit`, `git push`, and any deploy command —
those stay on Ask so a human confirms before anything leaves the local
machine, matching the "actions visible to others" caution already used
elsewhere in this workflow. Whether to allow `git commit` unattended is a
judgment call — if you do, know that it diverges from that reasoning.

## Ask — leave as default unless you have a specific reason not to

Everything not explicitly listed above defaults to Ask already. Don't
broaden `command(*)` or `mcp(*)` to Allow — grant specific prefixes as they
come up instead of pre-approving whole categories.
