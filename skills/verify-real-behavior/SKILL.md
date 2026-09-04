---
name: verify-real-behavior
description: Confirms a feature actually works by running it, not just by passing type-check/lint/build. Use before reporting any coding task as done, especially changes to tracking, instrumentation, or anything without a compiler-visible failure mode.
---

A type-check, lint, or build passing is not confirmation that the feature works. Follow these rules:
- Before calling a task done, actually run the feature and observe the real output — a live page, real data, an actual click-through — not just a green build.
- Instrumentation/tracking changes (analytics events, pixels) especially need this: a broken event fires no error, compiles cleanly, and silently produces zero data. Confirm the event actually appears (network tab, dashboard) before moving on.
