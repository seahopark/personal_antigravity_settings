# personal_antigravity_settings

Portable [Antigravity IDE](https://antigravity.google) protocol rules, kept
outside any single project so they survive moving to a new dev machine.

## Why this repo exists

Antigravity supports a real global rules file (`~/.gemini/GEMINI.md`,
applied across every workspace on that machine) alongside per-project rules
(`.agents/rules/*.md` in the repo root). Either way, rules live on a single
machine's filesystem or in a single project's git history — neither
survives a dev-PC switch on its own. This repo is the portable source: pull
it on any new machine and copy from here into wherever Antigravity expects
rules on that machine.

## How to use it

Either paste the combined content of `rules/*.md` directly into
`~/.gemini/GEMINI.md` (applies to every project on that machine), or copy
individual files into a specific project's `.agents/rules/` directory:

```bash
cp rules/*.md /path/to/project/.agents/rules/
```

Each file's frontmatter (`trigger`, `description`) controls when Antigravity
loads it into context — see each file for details, and Antigravity's own
docs for the full `trigger` semantics (`always_on` / `manual` / `glob` /
`model_decision`). All rules here currently use `model_decision`.

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
- `rules/no-silent-failure.md` — don't catch-and-ignore errors, especially
  around side-effect calls like analytics or submission.
- `rules/verify-real-behavior.md` — a passing build/lint/type-check is not
  confirmation a feature actually works; go run it.
- `rules/preserve-behavior-through-rewrites.md` — a broad rewrite must not
  silently drop safety-critical logic or existing interactions.

## Provenance

Distilled from a 2026-09-04 refactor + code-review session on the
[jammae](https://github.com/seahopark/jammae) codebase, generalized to
apply beyond that one project.
