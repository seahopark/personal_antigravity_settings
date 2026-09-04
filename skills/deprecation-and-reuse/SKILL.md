---
name: deprecation-and-reuse
description: Ensures replaced code is actually cleaned up instead of left orphaned, and that duplicate old/new implementations of the same role get merged. Use when replacing, rewriting, or deprecating an existing component, screen, or logic module.
---

When work replaces an existing implementation, follow through on the deprecation at implementation time (see the `implementation-plan` skill for deciding what to deprecate at planning time). Follow these rules:
- Actually delete or merge the old implementation once the plan calls for it. Don't leave it in a "clean up later" state.
- If old and new logic performing the same role (e.g. submission, persistence, validation) are found alive at the same time, merge them immediately. Left alone, their behavior drifts apart from each other.
