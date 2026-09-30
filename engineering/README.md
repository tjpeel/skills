# Engineering skills

| Skill | Overview |
| --- | --- |
| [`decision-discovery`](decision-discovery/SKILL.md) | Leads an evidence-informed conversation that resolves prospective engineering decisions for later specification. |
| [`specification`](specification/SKILL.md) | Turns settled decisions into a reviewable implementation specification for later ticket decomposition. |
| [`to-tickets`](to-tickets/SKILL.md) | Turns an approved specification into dependency-ordered local Markdown tickets. |
| [`implement`](implement/SKILL.md) | Implements one ready ticket in bounded, tested increments, scrutinises adapted reference code, and runs full checks before review. |
| [`code-review`](code-review/SKILL.md) | Reviews actual runtime behaviour and the complete local diff, then checks the current delivery slice against approved intent. |

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
the code, comments and service documentation must remain understandable to a
reviewer who does not have those files.
