---
name: interaction-content-separation
description: Reviews component APIs for mixed interaction/content responsibility — a modal, reveal, or carousel that knows too much about the specific content it displays. Use when designing or reviewing a component with a variant prop or content-specific optional props.
---

Don't mix the component that owns an interaction with the component that owns its content. Follow these rules:
- A component that handles "how it responds" — a modal, a reveal animation, a carousel — should not know the specific type or variant of "what it shows." Pass content in as `children` or a render prop instead of branching on it internally.
- If a single optional prop's presence or absence causes a component's internal behavior to diverge significantly, that's a sign the component is doing two jobs at once. Consider splitting it.
