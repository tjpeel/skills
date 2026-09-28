# Evidence dossier

Use one dossier per candidate decision before Astra is invoked. A dossier is an investigation record, not a draft ADR.

## Required fields

| Field | Content |
| --- | --- |
| Candidate decision | A neutral one-sentence statement of the apparent durable choice. |
| Current relevance | The current code, schema, configuration, or operational path that still depends on it. |
| Introduction evidence | PR/commit identifiers, dates, changed paths, and concise factual descriptions. |
| Evolution and counter-evidence | Later PRs or code that modify, replace, limit, or contradict the choice. |
| Rationale evidence | Exact source of an explicit rationale, if one exists. Keep code-derived rationale separate. |
| Consequences | Observable effects in code, contracts, data, operation, or tests. |
| Confidence and gaps | `high`, `medium`, or `low`, plus what would increase confidence. |
| Recommendation | `draft ADR`, `merge with <candidate>`, `record as historical note`, or `exclude`. |

## Evidence rules

- Cite evidence precisely enough that another engineer can reopen it: pull request or commit ID plus relevant paths; include a line or symbol when practical.
- Treat PR descriptions, design documents, issue decisions, and review discussion as explicit rationale. Treat commit messages and code as supporting evidence unless they directly state a reason.
- A current implementation proves that a pattern exists, not why it was selected. Do not manufacture rationale from apparent benefits.
- Search for later changes before declaring a decision current. A reverted or superseded implementation normally belongs in the excluded history, not an ADR.
- If an undocumented choice is clearly durable and important, a retrospective ADR may record it as inferred, with the confidence and missing rationale plainly labelled.

## Candidate selection

Prioritise decisions with long-lived impact on service boundaries, data ownership and persistence, schema evolution, compatibility, migrations, concurrency, security, integration contracts, reliability, observability, and operational controls. Exclude mechanical churn and isolated implementation tactics unless they establish one of those constraints.
