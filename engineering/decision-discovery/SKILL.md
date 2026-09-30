---
name: engineering-decision-discovery
description: Lead an evidence-informed design conversation that resolves prospective engineering decisions and preserves a concise handoff for later specification. Use when a team needs to make and record consequential design choices; do not use to reconstruct past decisions or decompose approved work into tickets.
---

# Engineering decision discovery

Turn an ambiguous prospective change into a shared set of explicit decisions.
The user owns product and preference decisions. Establish facts from the
repository, available tools, and supplied material before asking about them.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and research access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Delegation profiles

For a small decision with a clear local boundary, work directly. When the
evidence spans enough code, history, or independent concerns for delegation to
help, use the least sufficient delegated capability available in the current
platform. In Codex, use the installed custom profiles `read_low`,
`read_medium`, `read_high`, or `write_medium`; do not substitute a Codex
built-in role. In Claude Code, use an equivalently bounded subagent only when
subagents are available. A profile or subagent is an effort and access
boundary, not a task role: give every handoff its precise task, inputs,
constraints, and required output. If the equivalent is unavailable, perform
that bounded responsibility in the coordinating agent.

- Use `read_low` to map the affected code, existing terminology, accepted
  records, and observable constraints before design questions are posed.
- Use `read_medium` to examine a bounded set of alternatives or evidence and
  return the trade-offs, assumptions, and unanswered facts; it must not turn a
  user preference into a recommendation or decision.
- Use `read_high` only when a credible option carries material migration,
  data-loss, security, concurrency, or cross-service risk.
- Use `write_medium` as the sole local writer only after the user authorises
  saving settled terminology, a decision record, or a prospective ADR. It must
  preserve the agreed wording, write only to the agreed repository locations,
  and not settle pending decisions.

The coordinator owns the design conversation, user questions, recommendations,
and external actions. Read-only handoffs do not contact the user or create
records.

Treat a user's response as both an answer and, when it clearly calls for an
observable investigation, a possible bounded research request. For example,
"explore service X" authorises the coordinator to delegate a focused map of
that service and return the findings to the conversation; it need not repeat a
separate delegation request. Select the profile from the investigation's
scope and risk, not from the wording alone: use `read_low` for a bounded code
or terminology map, `read_medium` for alternatives and trade-offs, and
`read_high` only for the material risks listed above. Do not infer a handoff
from a preference or a vague answer. The coordinator still defines the
handoff's target, questions, constraints, and expected evidence.

## Establish the design boundary

Read applicable repository guidance, existing `CONTEXT.md` or
`CONTEXT-MAP.md`, decision records, and plans. Explore the affected code enough
to distinguish facts, constraints, and existing decisions from assumptions.

State the decision to make, its affected users or systems, known constraints,
and what is explicitly outside the discussion. Keep a design tree of decisions
and their prerequisites. A settled decision may expose later decisions.

Use the project's existing glossary and ADR conventions. When the discovery
needs to create or update domain context, read
[the repository-context guidance](references/repository-context.md). When it
needs a prospective ADR, read [the prospective-ADR guidance](references/prospective-adrs.md).
If no convention exists, propose the default location before creating it. Keep
the working record in the conversation until repository writes are authorised.

## Run decision rounds

Ask only decisions that are ready to answer. In each round, ask every
independent decision at the current frontier. For each question, give concise
context, viable choices, and a recommendation with its evidence or assumption.
Do not ask the user to find information that can be observed or researched.

Wait for answers before asking questions whose answers depend on them. If
research remains in flight, continue with unrelated ready decisions and mark
the dependent branch as pending. Challenge vague or overloaded domain language
and test important relationships with concrete edge cases.

Record each agreed decision as: the decision, its rationale, alternatives when
material, evidence, consequences, and remaining uncertainty. Do not turn a
preference into a fact or imply agreement where the user has not made one.

For a background worker, migration, or multi-stage rollout, test the design
with a small state-and-outcome table before calling it settled. Cover the
relevant success, invalid configuration, transient failure, exhausted retry,
ownership loss, timeout, cancellation, and restart paths. For each, identify
the next state, durable effects, retry owner and budget, readiness signal, and
operator recovery. Distinguish a process that is alive from one able to do its
work. Ask about unresolved choices; do not invent policy to complete the table.

Check the operational meaning of agreed limits. Concurrency, batch size,
long-poll wait, error backoff, and successful-work pacing are different
controls; use a simple backlog or processing-budget calculation when their
interaction could contradict the intended outcome. Verify external contract
limits and parsing assumptions from authoritative documentation rather than
leaving them to implementation.

When another repository supplies an example, establish what should align:
contract, deployment convention, or implementation mechanism. Identify which
behaviour and policy are deliberately excluded, especially retries, startup
gates, defaults, and ownership. An example is evidence for a choice, not
agreement to adopt its entire lifecycle.

## Preserve terminology and decisions

Maintain a concise working glossary of domain terms settled during discovery.
Prefer one canonical term and note confusing alternatives when they would cause
real ambiguity. Keep implementation detail, specifications, and unmade
decisions out of glossary entries. After the user authorises repository writes,
record a settled term incrementally in the applicable `CONTEXT.md`; do not
write disputed or provisional language. Use the provided
[CONTEXT.md template](assets/CONTEXT.md) only when the repository has no
existing context format.

An ADR is a durable repository record of an architecture-significant decision,
the context that made it necessary, why the chosen option won, and consequences
that code alone would not safely explain. Create or amend one only when the
decision is hard to reverse, would surprise a future engineer without context,
and involved a meaningful trade-off. Use the project's ADR format and status
convention. Confirm a decision before recording it as accepted; otherwise mark
it proposed. Do not use this skill to recover historical ADRs; use
`$architecture-adrs` for that work.

## Finish with a handoff

Finish when every branch is settled, intentionally deferred, or blocked by a
named external fact or decision. Return a concise decision record containing:

- the problem and agreed scope;
- settled decisions and their rationale;
- canonical terminology and relevant existing decision records;
- repository-relative links to applicable `CONTEXT.md`, `CONTEXT-MAP.md`, and
  ADRs, when they exist;
- deferred questions, assumptions, and evidence gaps;
- test seams or behavioural boundaries worth preserving for the later spec;
- settled failure and recovery transitions, operational budgets, and any
  boundaries on reuse from reference implementations.

This handoff is an input to `$engineering-specification`. Do not write a full
specification, publish to an issue tracker, or create implementation tickets
unless the user explicitly asks for that follow-on work.
