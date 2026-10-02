---
name: engineering-decision-discovery
description: Lead an evidence-informed design conversation that resolves prospective engineering decisions and preserves a concise handoff for later specification. Use when a team needs to make and record consequential design choices; do not use to reconstruct past decisions or decompose approved work into tickets.
---

# Engineering decision discovery

Turn an ambiguous prospective change into a shared set of explicit decisions.
The user owns product and preference decisions. Establish facts from the
repository, available tools, and supplied material before asking about them.

Code is the documentation of implemented functionality. Do not generate
supporting documents by default. Keep discovery in the conversation unless the
user requests a saved record or an applicable repository rule requires one.
An ADR or context file must preserve knowledge that code, tests and
configuration cannot convey, and signpost the relevant sources. Do not create
one merely because a decision or term was discussed, a file is missing, or
repository writes have been authorised.

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

Start with the current request and the sources explicitly supplied for it.
Read applicable repository guidance and explore the affected code enough to
distinguish facts, constraints, and existing decisions from assumptions. Read
relevant context or decision records only when the selected sources or
repository guidance identify them. Verify their claims against current code;
surface stale or conflicting intent rather than silently adopting it.

State the decision to make, its affected users or systems, known constraints,
and what is explicitly outside the discussion. Keep a design tree of decisions
and their prerequisites. A settled decision may expose later decisions.

Build a small domain model from the evidence: the actors, concepts and
relationships involved; who owns each decision or effect; the rules that must
remain true; and the observable outcomes. Walk through a representative current
case and the proposed change using the same terms. Ask targeted questions where
the evidence leaves meaning, responsibility or acceptable outcomes unclear.
The model should expose decisions, not prescribe an implementation structure.

Use the project's existing glossary and ADR conventions where relevant. First
identify the knowledge gap that cannot be resolved by reading code. When an
authorised record needs to capture that domain context, read
[the repository-context guidance](references/repository-context.md). When it
needs a prospective ADR, read [the prospective-ADR guidance](references/prospective-adrs.md).
If a justified record has no convention, propose the default location before
creating it. Keep the working record in the conversation until repository
writes are authorised.

## Local process records

When the user requests a saved discovery handoff, write it to
`<repository-root>/.sdlc/work/<reference>/decisions.md`. Resolve the invoking
Git repository's root first. Reuse the reference explicitly selected for this
task; ask for one if neither the request nor a selected work path supplies it.
The reference is an opaque folder key, not a tracker identifier. Preserve it
exactly: any non-empty single folder name is valid except `.` or `..`, path
separators, or control characters. Do not require a pattern or derive it from
a branch, title, or another work item. Confirm the resolved path stays beneath
the repository's `.sdlc/work/`, including when existing paths are symlinks.
Treat the key as literal data in filesystem and shell operations.

Read only process files explicitly supplied for this task or directly linked
as relevant sources from those inputs. Do not scan `.sdlc/work/`,
`.specifications/`, `.tickets/`, or `.handoffs/` for background context. Other
work folders and unselected files in the same folder must not steer discovery.
The same input boundary applies to delegated work.

The saved handoff is an uncommitted process input, not ongoing repository
documentation. This skill owns only `decisions.md`; existing specifications,
tickets, and other files may coexist in the folder. Check that file for a
collision, not whether the whole work folder is empty. Create it only when
absent; update an existing file only when the user explicitly selects it for
revision. Do not merge, refresh, move, or delete other process files.

Before writing, ensure `/.sdlc/work/` is locally ignored. If it is not already
ignored, append that rule to the Git exclude file resolved by
`git rev-parse --git-path info/exclude`, preserving existing entries. Never
alter `.gitignore`, stage, or commit process files. If exclusion cannot be
established or the target is already tracked, report the condition rather than
writing or silently untracking it. Durable ADRs and context records require
their own explicit request or repository requirement and retain their existing
conventions; this process folder does not authorise their creation.

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

Derive the guard rails from that domain model. Ask what inputs or actions are
allowed, what makes an outcome valid, what must never happen, and who resolves
an incomplete or failed outcome. Walk through relevant boundary and failure
cases rather than following a fixed technology checklist. When state or
external effects matter, record the trigger, outcome, effects and recovery in
a small table. Ask about unresolved policy; do not invent it to fill the table.

Investigate constraints that can be measured or documented. Use a small
calculation or concrete counterexample when interacting limits could defeat
the agreed outcome, and verify external contracts from authoritative sources.
Ask the user to choose only where evidence cannot settle an intentional policy
or trade-off. Match the depth of modelling to the change's uncertainty and risk.

When another repository supplies an example, establish what should align:
contract, convention, or implementation mechanism. Identify the assumptions
behind the example and which behaviour or policy should carry over. An example
is evidence for a choice, not agreement to adopt its entire lifecycle.

## Preserve terminology and decisions

Keep a concise working glossary in the conversation when terminology needs
clarification. Prefer canonical names in code; record only domain meaning or
confusing alternatives that code cannot explain. Keep implementation detail,
specifications, and unmade decisions out of glossary entries. When a saved
context record is requested or required, add only settled terms that fill that
gap, with links to relevant code. Do not write disputed or provisional language.
Use the provided [CONTEXT.md template](assets/CONTEXT.md) only when the
repository has no existing context format.

An ADR is a durable repository record of an architecture-significant decision,
the context that made it necessary, why the chosen option won, and consequences
that code alone would not safely explain. Create or amend one only when the
decision is hard to reverse, would surprise a future engineer without context,
and involved a meaningful trade-off. Link to the relevant implementation;
explain why the decision exists without retelling how that code works. Use the
project's ADR format and status convention. Confirm a decision before recording
it as accepted; otherwise mark it proposed. Do not use this skill to recover historical ADRs; use
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
- the relevant domain relationships, invariants, boundary and failure outcomes,
  verified constraints, and any boundaries on reuse from reference implementations.

Check that another session can reconstruct the reasoning and next decisions
from this record and its available sources, without relying on unstated answers
from the conversation. Name missing evidence and the question it blocks.

Return this handoff in the conversation by default; save it under the local
process contract only when requested. It can be an input to
`$engineering-specification` when
the user requests that planning step. Do not write a full specification,
publish to an issue tracker, or create implementation tickets unless the user
explicitly asks for that follow-on work.
