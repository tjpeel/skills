---
name: engineering-specification
description: Turn an approved decision record or current conversation into a reviewable, evidence-informed implementation specification. Use after design discovery or when the decisions are already settled; do not use to interview for decisions or create implementation tickets.
---

# Engineering specification

Turn settled design intent into a specification that an engineer can implement
and later decompose into tickets. Synthesize the available conversation,
decision record, and repository evidence. Do not restart design discovery or
interview the user for information already established.

## Delegation profiles

For a small specification whose inputs and code boundary are already clear,
work directly. When independent mapping or an audit would materially improve a
non-trivial specification, use the least sufficient custom profile from
`~/.codex/agents/`: `read_low`, `read_medium`, `read_high`,
`read_exceptional`, or `write_medium`. A profile is an effort and access
boundary, not a task role: give every handoff its precise task, inputs,
constraints, and required output. Do not use Codex built-in `default`,
`worker`, or `explorer` agents. If a profile is unavailable, perform that
bounded responsibility in the coordinating agent.

- Use `read_low` to map existing behaviour, interfaces, data boundaries,
  relevant tests, and the highest observable test seams.
- Use `read_medium` to reconcile a bounded set of decision records and
  repository evidence, or to audit the draft's acceptance criteria and test
  strategy for unsupported claims and missing observable behaviour.
- Use `read_high` only for credible material migration, data-loss, security,
  concurrency, compatibility, or cross-service risk.
- Use `write_medium` as the sole local writer only when the user authorises
  saving the completed specification. It must not expand the agreed scope or
  turn unresolved questions into decisions.

The coordinator owns scope decisions, targeted user questions, and external
actions. Read-only handoffs return evidence and audit findings only.

## Establish the source of truth

Read the supplied decision record, specification draft, issue, or conversation
in full. Read applicable repository guidance, domain terminology, and accepted
decision records. Explore the relevant code to establish present behaviour,
constraints, and durable module or contract boundaries.

Call out conflicting sources or an unmade decision. Ask only the targeted
question needed to resolve that gap. Do not use questions to substitute for
repository research. If the design needs broader decision work, hand it back to
`$engineering-decision-discovery` rather than guessing.

## Design for observable behaviour

Define the highest existing seam at which the proposed behaviour can be
observed and tested. Prefer existing seams. If one is missing, describe the
smallest new seam needed and why it belongs at that boundary. Do not create
production code or tests as part of writing the specification.

Write the specification in the repository's established format. If none
exists, use this structure:

```md
# <Outcome-oriented title>

## Problem

## Scope

## Proposed behaviour

## User and system outcomes

## Decisions and constraints

## Observable acceptance criteria

## Test strategy and seams

## Interfaces and data

## Out of scope

## Open questions and assumptions
```

State behaviour and stable contracts, rather than file paths, code snippets,
or an implementation sequence. Name user and system outcomes in terms of the
project's domain language. Each acceptance criterion must be independently
observable. Include data, API, compatibility, migration, security, and rollout
considerations when evidence makes them relevant; explicitly say when none are
identified.

Keep accepted decisions distinct from proposals and assumptions. Preserve a
decision-rich type, schema, state-machine, or reducer fragment only when a
prototype is the clearest record of a settled constraint. Label its source and
trim it to that constraint.

## Produce a handoff-ready draft

The draft is ready for ticket decomposition when its scope, behavioural
criteria, material decisions, test seams, and exclusions are clear. Include
remaining questions and evidence gaps instead of silently deciding them.

Return the reviewable draft or save it only where the user has authorised and
the repository's conventions permit. Do not publish it to an issue tracker or
break it into tickets unless the user explicitly requests the next activity.

## References

This independently written follow-on skill was developed from the design
workflow in the public
[grill-with-docs skill](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)
from [mattpocock/skills](https://github.com/mattpocock/skills).
