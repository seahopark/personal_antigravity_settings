---
name: single-source-of-truth
description: Checks for and prevents duplicated classification logic or boundary values (score bands, tier rules, status categories) across files. Use when writing or reviewing code that computes a category, tier, or threshold-based decision.
---

Don't reimplement the same classification logic in more than one file. Follow these rules:
- Judgment logic that needs to produce the same answer across multiple screens — score bands, tier classification, status categorization — gets extracted into a shared function or util the moment it's noticed. Don't reimplement it per-screen.
- If the same boundary value (a numeric threshold, etc.) appears in two or more places, consolidate it into one source. Left unconsolidated, one copy eventually gets updated without the other, and the values silently drift apart.
