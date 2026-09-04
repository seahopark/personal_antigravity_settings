---
trigger: model_decision
description: Use when doing a broad rewrite or replacement of an existing screen, component, or module.
---

A broad rewrite must not silently drop what already worked. Follow these rules:
- Before starting a rewrite, list the existing safety-critical logic (consent gates, auth checks, rate limits) and the core user-facing interactions that must survive. Check each one against the new code once the rewrite lands — new-feature tests alone won't catch a lost interaction.
- "It compiles and the new feature works" is not the same as "nothing that used to work got lost."
