---
name: engineering-specification
description: Turn an approved decision record or current conversation into a reviewable, evidence-informed implementation specification. Use after design discovery or when the decisions are already settled; do not use to interview for decisions or create implementation tickets.
---

# Engineering specification

Turn settled design intent into a specification that an engineer can implement
and later decompose into tickets. Use this for work that spans more than one
fresh implementation session. Synthesize the available conversation, decision
record, and repository evidence. Do not restart design discovery or interview
the user for information already established.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Delegation profiles

For a small specification whose inputs and code boundary are already clear,
work directly. When independent mapping or an audit would materially improve a
non-trivial specification, use the least sufficient delegated capability
available in the current platform. In Codex, use the installed custom profiles
`read_low`, `read_medium`, `read_high`, or `write_medium`; do not substitute a
Codex built-in role. In Claude Code, use an equivalently bounded subagent only
when subagents are available. A profile or subagent is an effort and access
boundary, not a task role: give every handoff its precise task, inputs,
constraints, and required output. If the equivalent is unavailable, perform
that bounded responsibility in the coordinating agent.

- Use `read_low` to map existing behaviour, interfaces, data boundaries,
  relevant tests, and the highest observable test seams.
- Use `read_medium` to compare a bounded set of decision records and repository
  evidence, report conflicts, or audit the draft's acceptance criteria and test
  strategy for unsupported claims and missing observable behaviour.
- Use `read_high` only for credible material migration, data-loss, security,
  concurrency, compatibility, or cross-service risk.
- Use `write_medium` as the sole local writer only when the user authorises
  saving an approved specification. It must not expand the agreed scope, turn
  unresolved questions into decisions, or overwrite an existing artifact.

The coordinator owns scope decisions, targeted user questions, and external
actions. Read-only handoffs return evidence and audit findings only.

## Establish the source of truth

Read the supplied decision record, specification draft, issue, or conversation
in full. Read applicable repository guidance, `CONTEXT.md` or
`CONTEXT-MAP.md`, and accepted ADRs. Use canonical domain terminology without
copying the glossary into the specification. Treat accepted ADRs as constraints;
a proposed ADR is non-binding unless its underlying decision was separately
confirmed. Explore the relevant code to establish present behaviour,
constraints, and durable module or contract boundaries.

The specification is an implementation snapshot. `CONTEXT.md` owns evolving
domain vocabulary, while ADRs own durable architectural rationale. Link to
applicable repository context and ADR documents, but do not copy them or add
implementation file paths to the specification.

Call out conflicting sources or an unmade decision. Ask only the targeted
question needed to resolve that gap. Do not use questions to substitute for
repository research. If the design needs broader decision work, hand it back to
`$engineering-decision-discovery` rather than guessing.

## Local specification contract

Return a reviewed draft in the conversation by default. For multi-session work,
save the approved draft before ticket decomposition. Obtain authorisation to
save it, work only in the Git repository from which the skill was invoked, and
resolve its root before writing. If the repository has no specification
convention, use this layout:

```text
<repository-root>/.specifications/<lowercase-kebab-case-title>.md
```

Use the repository's existing convention in preference to this default. Never
create an external tracker issue or alter `.gitignore`. If the target exists,
show the collision and ask for a new title or path; do not merge, replace, or
overwrite it. A saved approved specification can be supplied to
`$engineering-to-tickets` in a later session.

## Design for observable behaviour

Define the highest existing seam at which the proposed behaviour can be
observed and tested. Prefer existing seams. If one is missing, describe the
smallest new seam needed and why it belongs at that boundary. Do not create
production code or tests as part of writing the specification. Choose the
fewest high-level seams that cover the independently observable boundaries,
record the relevant existing test style, and ask for confirmation when a seam
choice materially constrains implementation or verification.

Write the specification in the repository's established format. If none
exists, use this structure:

```md
# <Outcome-oriented title>

**Status:** draft

## Problem

## Source artifacts

## Current behaviour and evidence

## Scope

## Required behaviour

## User and system outcomes

## Decisions and constraints

## Observable acceptance criteria

## Test strategy and seams

## Interfaces and data

## Change and rollout constraints

## Out of scope

## Blocking questions

## Assumptions and evidence gaps
```

Keep current behaviour factual and distinct from agreed future intent. State
required behaviour and stable contracts, rather than implementation file paths,
code snippets, or an implementation sequence. Name user and system outcomes in
terms of the project's domain language. Each acceptance criterion must be an
observable delta that is unmet at the baseline. Reject criteria such as "tests
pass", implementation task lists, or claims already true before the change.

List repository-relative links to the decision-discovery handoff, applicable
`CONTEXT.md` or `CONTEXT-MAP.md`, and ADRs in source artifacts. Say `None` only
when no such artifact applies.

Use change and rollout constraints for applicable migration and reversibility,
compatibility, rollout or rollback, operational observability, security or
privacy, and data ownership or retention. Say `None identified after review`
when none apply. Blocking questions keep the draft unapproved and return the
affected decision to `$engineering-decision-discovery`. Assumptions and
evidence gaps may remain only when they do not alter required behaviour, scope,
contracts, or acceptance criteria; state their effect if false.

Keep accepted decisions distinct from proposals and assumptions. Preserve a
decision-rich type, schema, state-machine, or reducer fragment only when a
prototype is the clearest record of a settled constraint. Label its source and
trim it to that constraint.

## Produce a handoff-ready draft

Present the draft with its test seams, out-of-scope items, assumptions, evidence
gaps, and blocking questions clearly identified. Ask the user to approve it.
Do not mark it handoff-ready while a question affecting scope, required
behaviour, a contract, or acceptance remains unresolved.

After explicit approval, return the approved draft or save it under the local
specification contract when authorised, changing its status to `approved` only
after that approval. Before ticket decomposition, save the approved version
under the local specification contract. Hand its local path to
`$engineering-to-tickets` only when the user explicitly requests ticket
decomposition. Do not publish it to an issue tracker or create tickets as part
of this skill.
