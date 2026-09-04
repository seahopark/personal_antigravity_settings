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

The deny list is a sibling `deny` array in the same object — confirmed by
adding an entry through the UI and reading the file back.

**These files are owned by the running app.** Editing them directly while
Antigravity is open risks the app overwriting your edit with whatever it
still has in memory. Quit both the IDE and Antigravity 2.0 before touching
the JSON.

## Two UI limitations that matter

The Permission Grants panel lives in **Antigravity 2.0** (Settings sidebar),
not the IDE — the IDE reference documents no permissions UI at all. Both
apps read the same `~/.gemini/config/`, so setting it in either place
applies everywhere. Beyond that, the panel has two traps:

1. **It wraps your input in `command(...)` automatically.** Typing
   `command(rm -rf)` stores `command(command(rm -rf))`, which matches a
   command literally starting with the text `command(rm -rf)` — i.e. never.
   Type the bare value (`rm -rf`) instead. This fails silently: the entry
   shows up in the list looking correct while blocking nothing.
2. **It can only produce `command(...)` grants.** There is no type selector,
   so `write_file(...)`, `read_file(...)`, `read_url(...)`, and `mcp(...)`
   entries cannot be created through the UI at all. Typing
   `write_file(.env)` stores `command(write_file(.env))`, which gates a
   nonexistent command rather than file writes.

## How to apply this safely

1. Add the `command(...)` entries through the UI, typing bare values with no
   `command(` wrapper.
2. For anything that is not a command — the `write_file` entries below —
   quit Antigravity entirely and add them to the `deny` array in
   `~/.gemini/config/config.json` by hand. There is no UI path.
3. Reopen the app and confirm the panel lists them without re-wrapping.

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

`command(sudo)` is worth a second thought rather than a reflex. Denying it
blocks it outright; leaving it off the list drops it to Ask, where you see
and approve each invocation individually. If you want to stay in the loop on
privileged commands rather than never running them, Ask is the better fit —
Deny is for things you never want to happen at all.

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
