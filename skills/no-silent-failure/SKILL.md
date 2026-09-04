---
name: no-silent-failure
description: Reviews error handling for silently swallowed failures, especially around side-effect calls like analytics, persistence, or submission. Use when writing or reviewing a try/catch, an API call, or anything that records success/failure state.
---

Don't let error handling hide failures. Follow these rules:
- When an operation can fail (a network request, a write, a submission), don't catch and ignore the error while still marking the operation as succeeded. If persisted state says something happened, it actually has to have happened.
- Side-effect calls (analytics events, logging, background pings) still need visible failure handling — silently swallowing them just means no one ever finds out they stopped working.
