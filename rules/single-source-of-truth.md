---
trigger: model_decision
description: Use when writing or reviewing code that involves classification logic, boundary values, or business rules — check whether they already exist elsewhere before reimplementing them.
---

Don't reimplement the same classification logic in more than one file. Follow these rules:
- Judgment logic that needs to produce the same answer across multiple screens — score bands, tier classification, status categorization — gets extracted into a shared function or util the moment it's noticed. Don't reimplement it per-screen.
- If the same boundary value (a numeric threshold, etc.) appears in two or more places, consolidate it into one source. Left unconsolidated, one copy eventually gets updated without the other, and the values silently drift apart.
