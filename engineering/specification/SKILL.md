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

The local specification is an uncommitted process input. It records intended
changes and acceptance criteria for this work, not ongoing documentation of
the implemented system; code documents implemented functionality. Do
not generate additional context files, ADRs or functionality guides by default.
Link to existing supporting records for rationale or constraints that code
cannot convey, rather than copying their content into another explanation.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Delegation profiles

For a small specification whose inputs and code boundary are already clear,
work directly. Delegate when independent mapping or an audit would materially
improve the specification.

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

- Use `read_low` to map existing behaviour, interfaces, data boundaries,
  relevant tests, and existing seams that faithfully observe the behaviour.
- Use `read_medium` to compare a bounded set of decision records and repository
  evidence, report conflicts, or audit the draft's acceptance criteria and test
  strategy for unsupported claims and missing observable behaviour.
- Use `read_high` only for credible material migration, data-loss, security,
  concurrency, compatibility, or cross-service risk.
- Use `write_medium` as the sole local writer only when the user authorises
  creating or updating the specification file. It must not expand the agreed
  scope, turn unresolved questions into decisions, or replace an unselected
  artifact. An update is limited to the explicitly selected specification.

The coordinator owns scope decisions, targeted user questions, and external
actions. Read-only handoffs return evidence and audit findings only.

## Establish the source of truth

Read the current request and the explicitly supplied decision record,
specification draft, issue, or conversation in full. A supplied `.handoffs/`
document may provide transient context; capture its confirmed intent in this
specification without maintaining the handoff. Read only process files selected
for the current task or directly linked as relevant sources from those inputs.
Do not scan `.sdlc/work/`, `.specifications/`, `.tickets/`, or `.handoffs/` for
context, including other files in the selected work folder. Do not infer an
input from a branch name, title, recency, or a matching reference. Apply this
boundary to delegates too.

Read applicable repository guidance and any relevant context or accepted ADRs
identified by that guidance or the selected sources. Use canonical domain
terminology without copying the glossary. Treat applicable accepted ADRs as
constraints; a proposed ADR is non-binding unless its decision was separately
confirmed. Explore the relevant code to establish present behaviour,
constraints, and durable module or contract boundaries. Surface stale or
conflicting source claims; their presence or status does not establish current
intent.

The specification is a snapshot of implementation intent. Existing context
files may preserve domain meaning unavailable from code, while ADRs preserve
durable architectural rationale. Link to applicable repository context and
ADR documents, but do not copy them or add implementation file paths to the
specification.

Call out conflicting sources or an unmade decision. Ask only the targeted
question needed to resolve that gap. Do not use questions to substitute for
repository research. If the design needs broader decision work, hand it back to
`$engineering-decision-discovery` rather than guessing.

## Local specification contract

Always write the specification locally; do not return the draft's contents in
chat. Work only in the Git repository from which the skill was invoked and
resolve its root before writing. For a new specification, use the reference
explicitly selected for this task or supplied by a selected
`.sdlc/work/<reference>/` input path. Ask for it when missing, and resolve any
conflict between the selected reference and input path before writing.
It is an opaque folder key, not a tracker identifier: preserve
any non-empty single folder name except `.` or `..`, path separators, or control
characters. Do not impose a naming pattern or derive it from a branch or title.
Confirm the resolved path stays beneath `.sdlc/work/`, including symlinks.
Treat the key as literal data in filesystem and shell operations.

New specifications use this layout:

```text
<repository-root>/.sdlc/work/<reference>/specification.md
```

This skill owns only `specification.md`. Other process files may already exist
in the work folder; they are not a collision or an instruction to load them.
If the target file exists, ask for another reference or explicit selection of
that file for revision; do not merge or replace it. Create the file as `draft`
while decisions or approval remain outstanding, then update that same file to
`approved` after explicit approval. Updating this invocation's draft is part of
the workflow; refreshing old specifications as ongoing documentation is not.

Explicitly supplied legacy files in `.specifications/` remain valid inputs
during transition and may be revised when expressly requested. Do not discover,
migrate, or create new legacy files. For a selected legacy revision, use its
existing path rather than creating a duplicate in `.sdlc/work/`.

Before writing, ensure the output is locally ignored. For new work, append
`/.sdlc/work/` to the Git exclude file resolved by
`git rev-parse --git-path info/exclude` if it is not already ignored; for a
legacy revision, exclude its exact path, escaping Git ignore metacharacters.
Preserve existing entries. Never alter `.gitignore`, stage, or commit process
files. If exclusion cannot be established or the target is already tracked,
report the condition rather than writing or silently untracking it. Never
create an external tracker issue. Report only the local path, status, and any
decisions or blockers in chat. A saved approved specification can be supplied to
`$engineering-to-tickets` in a later session.

## Design for observable behaviour

Apply `$engineering-testing` to the proposed verification strategy. Record
the existing coverage, concrete gaps and independent expected outcomes rather
than requiring a new test for every criterion. Existing checks or direct
verification can suffice for mechanical changes; a testable criterion does
not automatically require a new automated test.

Define the lowest-cost existing public seam that faithfully exercises the
proposed behaviour. Prefer existing seams. If one is missing, describe the
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
**Work reference:** <reference>

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

List links to the task's selected decision records and applicable context or
ADRs in source artifacts. Resolve each link relative to the specification's
directory and confirm its target exists in the invoking repository. Do not
inventory other process files or copy their content as assumed current intent.
Do not link to or list a `.handoffs/` document there: if one informed the work,
its settled content is
now captured by this specification and the specification supersedes it for
future work. Say `None` only when no such artifact applies.

Use change and rollout constraints for applicable migration and reversibility,
compatibility, rollout or rollback, operational observability, security or
privacy, and data ownership or retention. Say `None identified after review`
when none apply. Blocking questions keep the draft unapproved and return the
affected decision to `$engineering-decision-discovery`. Assumptions and
evidence gaps may remain only when they do not alter required behaviour, scope,
contracts, or acceptance criteria; state their effect if false.

When lifecycle or cross-system effects matter, carry the settled states into
a compact contract in that section. Record the relevant versions or
configuration, actor and prerequisites, observable readiness, permitted and
forbidden effects, and recovery responsibility. Include only states that
change behaviour; do not require a full combination of every setting. Make
activation order and the meaning of the boundary explicit, including which
timestamp or event determines it. State how retries and replays behave on
either side. Name any point after which reverting code or configuration is
insufficient, and the agreed recovery then. An unresolved state that can
change an effect blocks approval of the affected scope.

Keep accepted decisions distinct from proposals and assumptions. Preserve a
decision-rich type, schema, state-machine, or reducer fragment only when a
prototype is the clearest record of a settled constraint. Label its source and
trim it to that constraint.

Translate the domain model and settled guard rails into contracts an
implementer can apply: who may act, which inputs and preconditions are valid,
the observable result, effects and invariants, and what happens outside the
successful case. Include relevant boundary examples with their expected
outcomes. For stateful behaviour, use a compact trigger-and-outcome table where
it clarifies transitions, incomplete work and recovery responsibility.
State the condition, observable result and any effects that must not occur;
an adjective such as "safe" or "valid" alone does not define a contract.

Derive technical constraints from those contracts and the affected repository
and integrations. Record where they are enforced and what invalid conditions
cause before effects occur. Make interacting limits explicit when they could
defeat an outcome; distinguish verified constraints from estimates. Do not
import a reference implementation's policy without a settled reason to adopt it.

When work will land in stages, specify the acceptable intermediate behaviour
as well as the final outcome. Explain how each affected actor or input is
handled while a capability is deferred, any resulting effects and recovery,
and what makes the stage safe to use. An unresolved intermediate policy blocks
approval even when the final design is settled.

## Produce the local specification

Write the draft locally with its test seams, out-of-scope items, assumptions,
evidence gaps, and blocking questions clearly identified. Tell the user where
it was saved and ask for approval without reproducing the document in chat. Do
not mark it approved while a question affecting scope, required behaviour, a
contract, or acceptance remains unresolved.

Before seeking approval, trace each required outcome and material boundary or
failure case to an observable acceptance criterion and credible verification
through an existing or proposed test seam or justified alternative check.
Check that a fresh session can understand the actors, domain rules, contracts,
intermediate states and verification from the specification and its linked
sources. A required behaviour must not depend on an answer retained only in the
conversation. Use the bounded independent audit described above when it would
materially improve confidence. Resolve omissions through repository evidence
or a targeted question; do not silently turn a gap into a default.

After explicit approval, change the saved file's status to `approved`. Hand its
local path to
`$engineering-to-tickets` only when the user explicitly requests ticket
decomposition. Do not publish it to an issue tracker or create tickets as part
of this skill.
