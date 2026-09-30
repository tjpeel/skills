# Prospective ADRs

Use this reference when an agreed future-facing decision may need a durable
record. A prospective ADR records the context, decision, rationale, and any
consequences that a future engineer would not safely infer from code.
Do not generate ADRs by default. Save one only when requested or required and
the decision qualifies below; an ADR is not a completion step for discovery.

## Qualification

Offer an ADR only when all three conditions hold:

1. The decision is costly to reverse.
2. The decision would be surprising without context.
3. The decision resulted from a genuine trade-off.

Do not create an ADR for a reversible choice, an obvious default, or a decision
that remains unsettled. A decision record is not a diary of the discovery
session.

## Placement and status

Use the repository's existing ADR directory, filename convention, template,
and status vocabulary. If it has no ADR convention, propose `docs/adr/` at the
repository root and use `NNNN-<lowercase-kebab-case-slug>.md`. Find the highest
existing number and increment it; do not replace an existing file.

For a context with an established ADR directory, use that location. If one does
not exist, propose `<context-root>/docs/adr/` only when the ADR belongs solely
to that context. Keep system-wide decisions in the repository-level directory.

Use `proposed` until the user confirms the decision. Mark it `accepted` only
after confirmation. Preserve other status values when the repository already
uses them.

## Content

Keep the ADR concise. It must state:

- the context that created the decision;
- the decision; and
- why that option was selected.

Add considered options and consequences only when they preserve a non-obvious
trade-off or downstream constraint. Link to the code or tests that implement
the decision; for an unimplemented proposal, label that gap. Describe the
rationale and constraints, not the algorithm, control flow or functionality
already expressed by code. Do not require retrospective evidence such
as commit, pull-request, or confidence fields: those belong to the historical
recovery workflow.
