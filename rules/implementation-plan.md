---
trigger: always_on
description: What an implementation plan must contain before coding starts.
---

Follow these rules when writing an implementation plan.

## Format

- Write the explanatory prose in Korean.
- Keep code identifiers — function names, variable names, file names, type names — in their original (English) form. Don't translate them; a translated identifier can't be mapped back to the actual code.

## Survey existing structure first

- Before designing something new, look for similar existing screens, components, or hooks. In the plan, explicitly separate what will be reused from what will be newly built.
- List the files this work touches, split into new / modified / deleted, near the top of the plan.

## Enumerate variants up front

- If the feature has multiple modes or edge cases, list all of them before starting, and decide for each one whether it's handled the same way or differently. Don't discover a missed case mid-implementation.
- When adding a new variant to an existing feature, explicitly decide whether the existing variant's interactions and policies should carry over to the new one before starting.

## Define the shared data contract first

- Before writing UI, define the shared data type and the field that discriminates its states. Don't design around the implicit presence/absence of individual optional props.

## Decide what gets deprecated

- State up front what gets deleted and what gets reused. A plan that only adds new code and leaves the old implementation in place doesn't get approved (see `deprecation-and-reuse.md` for following through at implementation time).
