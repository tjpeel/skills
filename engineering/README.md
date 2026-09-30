# Engineering skills

| Skill | Overview |
| --- | --- |
| [`decision-discovery`](decision-discovery/SKILL.md) | Leads an evidence-informed conversation that resolves prospective engineering decisions for later specification. |
| [`specification`](specification/SKILL.md) | Turns settled decisions into a reviewable implementation specification for later ticket decomposition. |
| [`to-tickets`](to-tickets/SKILL.md) | Turns an approved specification into dependency-ordered local Markdown tickets. |
| [`implement`](implement/SKILL.md) | Implements one ready ticket in bounded, tested increments, scrutinises adapted reference code, and runs full checks before review. |
| [`code-review`](code-review/SKILL.md) | Reviews actual runtime behaviour and the complete local diff, then checks the current delivery slice against approved intent. |

Code is the documentation of implemented functionality. Do not generate
additional docs by default during implementation. Read the code, tests and
configuration to establish what the system does. Supporting documents should
signpost those sources and preserve knowledge they cannot convey: decision
rationale, external constraints
or domain meaning that would otherwise be lost. Do not maintain a second
description of functionality that can drift from the implementation. Use clear
names, structure and focused comments to make the code understandable.

Specifications and local tickets are deliberate workflow outputs: they state
intended changes and acceptance criteria. Keep those planning contracts. An
additional document needs an explicit request, an applicable repository
requirement or a material knowledge gap that code cannot convey. Missing ADRs,
context files or guides alone are not a reason to create them.

Discovery establishes the domain rules and derives the guard rails from them.
Each handoff preserves those rules, observable outcomes and relevant boundary
and failure cases without relying on the previous conversation. The
specification defines acceptable intermediate states; tickets connect the
slice's contracts, prerequisites and verification for a fresh implementation
agent. Independent ready tickets can be assigned to separate agents, with one
owner per ticket and isolated checkouts. Implementation completes and verifies
one increment before beginning the next.
Review assesses the code independently of the planning assumptions, then checks
requirements. Local tickets and specifications support the agent workflow;
the code and focused comments must remain understandable to a reviewer who
does not have those files. Verify any relevant supporting document against the
code before relying on it; surface contradictions rather than treating prose
as proof of behaviour.
