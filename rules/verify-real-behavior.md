---
trigger: model_decision
description: Use before considering a task done — a passing type-check, lint, or build is not confirmation that the feature actually works.
---

A type-check, lint, or build passing is not confirmation that the feature works. Follow these rules:
- Before calling a task done, actually run the feature and observe the real output — a live page, real data, an actual click-through — not just a green build.
- Instrumentation/tracking changes (analytics events, pixels) especially need this: a broken event fires no error, compiles cleanly, and silently produces zero data. Confirm the event actually appears (network tab, dashboard) before moving on.
