---
name: engineering-decision-discovery
description: Lead an evidence-informed design conversation that resolves prospective engineering decisions and preserves a concise handoff for later specification. Use when a team needs to make and record consequential design choices; do not use to reconstruct past decisions or decompose approved work into tickets.
---

# Engineering decision discovery

Turn an ambiguous prospective change into a shared set of explicit decisions.
The user owns product and preference decisions. Establish facts from the
repository, available tools, and supplied material before asking about them.

## Establish the design boundary

Read applicable repository guidance and existing terminology, decision records,
and plans. Explore the affected code enough to distinguish facts, constraints,
and existing decisions from assumptions.

State the decision to make, its affected users or systems, known constraints,
and what is explicitly outside the discussion. Keep a design tree of decisions
and their prerequisites. A settled decision may expose later decisions.

Use the project's existing glossary and ADR conventions. If it has none, do not
introduce new project documentation paths without the user's agreement. Keep
the working record in the conversation until a location is agreed.

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

## Preserve terminology and decisions

Maintain a concise working glossary of domain terms settled during discovery.
Prefer one canonical term and note confusing alternatives when they would cause
real ambiguity. Keep implementation detail out of glossary entries.

Create or amend a prospective ADR only when the decision is hard to reverse,
would surprise a future engineer without context, and involved a meaningful
trade-off. Use the project's ADR format and status convention. Confirm a
decision before recording it as accepted; otherwise mark it proposed. Do not
use this skill to recover historical ADRs; use `$architecture-adrs` for that
work.

## Finish with a handoff

Finish when every branch is settled, intentionally deferred, or blocked by a
named external fact or decision. Return a concise decision record containing:

- the problem and agreed scope;
- settled decisions and their rationale;
- canonical terminology and relevant existing decision records;
- deferred questions, assumptions, and evidence gaps; and
- test seams or behavioural boundaries worth preserving for the later spec.

This handoff is an input to a later specification skill. Do not write a full
specification, publish to an issue tracker, or create implementation tickets
unless the user explicitly asks for that follow-on work.
