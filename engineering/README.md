# Engineering skills

| Skill | Overview |
| --- | --- |
| [`decision-discovery`](decision-discovery/SKILL.md) | Leads an evidence-informed conversation that resolves prospective engineering decisions for later specification. |
| [`specification`](specification/SKILL.md) | Turns settled decisions into a reviewable implementation specification for later ticket decomposition. |
| [`to-tickets`](to-tickets/SKILL.md) | Turns an approved specification into dependency-ordered local Markdown tickets. |
| [`implement`](implement/SKILL.md) | Implements one ready ticket in bounded, tested increments, scrutinises adapted reference code, and runs full checks before review. |
| [`code-review`](code-review/SKILL.md) | Reviews actual runtime behaviour and the complete local diff, then checks the current delivery slice against approved intent. |

Each handoff preserves failure and recovery behaviour as well as the intended
success path. The specification defines safe intermediate states; tickets own
the checks and deferred-boundary explanations needed when each slice lands.
Implementation completes and verifies one increment before beginning the next.
Review assesses the code independently of the planning assumptions, then checks
requirements. Local tickets and specifications support the agent workflow;
the code, comments and service documentation must remain understandable to a
reviewer who does not have those files.
