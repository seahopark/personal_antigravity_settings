# personal_antigravity_settings

Portable [Antigravity IDE](https://antigravity.google) protocol rules, kept
outside any single project so they survive moving to a new dev machine.

## Why this repo exists

Antigravity only auto-loads rules from `.agent/rules/*.md` (or
`.agents/rules/`, `_agent/rules/`, `_agents/rules/`) **inside the repo
currently open in the IDE**. There is no global rules location — only
`global_workflows` exist at that scope, not rules. So this repo is not
picked up automatically; it's a maintained source you copy from.

## How to use it

Copy (or symlink) the files under `rules/` into the target project's
`.agent/rules/` directory:

```bash
cp rules/*.md /path/to/project/.agent/rules/
```

Each file's frontmatter (`trigger`, `description`) controls when Antigravity
loads it into context — see each file for details, and Antigravity's own
docs for the full `trigger` semantics (`always_on` / `manual` / `glob` /
`model_decision`).

## Contents

- `rules/markdown-syntax.md` — formatting conventions for any markdown
  Antigravity writes.
- `rules/implementation-plan.md` — what an implementation plan must contain
  before coding starts (scope survey, variant enumeration, shared data
  contract, deprecation decision).
- `rules/single-source-of-truth.md` — don't reimplement the same
  classification logic or boundary values in more than one place.
- `rules/interaction-content-separation.md` — keep interaction mechanics
  (how something responds) separate from content (what it shows).
- `rules/deprecation-and-reuse.md` — when replacing existing code, the
  replaced code must actually get cleaned up, not left orphaned.

## Provenance

The first five rules were distilled from a 2026-09-04 refactor session on
the [jammae](https://github.com/seahopark/jammae) codebase, generalized to
apply beyond that one project.
