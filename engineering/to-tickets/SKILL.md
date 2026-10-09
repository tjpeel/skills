---
name: engineering-to-tickets
description: Break an approved saved engineering specification into dependency-ordered local Markdown tickets. Use for multi-session implementation work; do not use to settle design decisions or implement the tickets.
---

# Engineering to tickets

Turn an approved saved specification into a small set of agent-ready local
tickets. Each ticket is a narrow, complete vertical slice that a fresh
implementation session can finish and verify independently. If the input is a
plan, conversation, draft, unapproved specification, or a specification without
a local path, return it to `$engineering-specification` rather than creating
tickets.

Local tickets are uncommitted process inputs for the selected work. They record
intended changes and verification; do not maintain them as ongoing system
documentation. Code documents implemented functionality. Do not add
documentation tasks by default. Include one only when the approved specification
requires it and it fills a material knowledge gap, provides a useful signpost
or satisfies an explicit user or repository requirement. Do not ask an
implementer to create a parallel explanation of feature behaviour.

Treat the approved specification as a source of requirements, not content to
reproduce. Include only what this slice's implementer needs to build and
verify it. Leave conversation history, access troubleshooting and task
logistics out; carry a blocker or evidence limit only when it affects this
ticket's readiness or verification.

Keep the eventual PR small and easy to review. For a small fix, default to one
ticket and one coherent change. Decompose only for real session-size,
compatibility or delivery boundaries; separate files, layers and checks do not
by themselves require tickets or implementation phases.

Reuse an explicitly selected supplementary checkout when suitable. If an
authorised investigation needs a new clone, keep it in a locally ignored
directory beneath the active workspace, record its path and checked revision,
and preserve it for later inspection. Do not default repository clones to a
system temporary directory or reset, overwrite or remove existing checkouts
as routine investigation cleanup.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Local ticket contract

Work only in the Git repository from which this skill was invoked. Resolve its
root before creating files; if there is no Git root, stop and ask the user for
a repository. Do not create, update, or publish tickets in an external tracker.

Use the work reference explicitly selected for this task, or the reference in
the supplied `.sdlc/work/<reference>/specification.md` path. If neither supplies
it, ask before writing. A conflicting reference must be resolved with the user.
The reference is an opaque folder key, not a tracker identifier: any non-empty
single folder name is valid except `.` or `..`, path separators, or control
characters. Preserve it exactly, with no required format or case conversion.
Do not derive it from a branch, title, or another work item. Confirm the resolved
output stays beneath `.sdlc/work/`, including when paths are symlinks.
Treat the key as literal data in filesystem and shell operations.

Use this layout:

```text
<repository-root>/.sdlc/work/<reference>/tickets/
  01-<short-kebab-case-title>.md
  02-<short-kebab-case-title>.md
```

Number tickets in dependency order, with at least two digits. A ticket may name
only a lower-numbered ticket as a blocker. This skill owns the new ticket files
only. An existing specification or decision record in the work folder is
expected; check the `tickets/` subdirectory for collisions. Create the set if
that subdirectory is absent or empty. If it contains anything, report the
collision and ask for a new work reference or explicit direction; do not merge,
replace, overwrite, or partially reuse the existing set. Leave it untouched
while the collision is unresolved.

Before writing, ensure `/.sdlc/work/` is locally ignored. If it is not already
ignored, append that rule to the Git exclude file resolved by
`git rev-parse --git-path info/exclude`, preserving existing entries. Never
alter `.gitignore`, stage, or commit process files. If exclusion cannot be
established or any output target is already tracked, report the condition
rather than writing or silently untracking it.

Explicitly supplied legacy specifications in `.specifications/` and tickets in
`.tickets/` remain valid inputs during transition. Do not discover, migrate, or
write new files in those directories; new ticket sets use `.sdlc/work/`.

## Delegation profiles

For a small, clear specification, work directly. Delegate when independent
mapping or an audit would materially improve a non-trivial decomposition.

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

- Use `read_low` to map unfamiliar current behaviour, domain vocabulary,
  decisions, and test seams needed to make the tickets credible.
- Use `read_medium` to audit a non-trivial draft for vertical slicing,
  dependency cycles, session-sized scope, overly broad implementation
  checkpoints, omissions, and criteria that could actually fail at the baseline.
- Use `read_high` only for credible migration, data-loss, security,
  concurrency, compatibility, or cross-service risk, including whether risk
  sequencing creates a necessary blocker.
- Use `write_medium` as the sole local writer when delegation is warranted.
  Its scope is the new files beneath `.sdlc/work/<reference>/tickets/`; it must
  not rewrite the agreed decomposition or overwrite existing files.

The coordinator owns reference validation, user questions, the decomposition,
and collision decisions. Read-only handoffs return evidence and audit findings
only.

## Build the ticket set

Read the explicitly supplied approved specification in full. Confirm that its
status is `approved`, it has no blocking questions, and its path belongs to the
invoking repository. If no path was supplied, ask for it; do not search for a
specification. Read only that input and directly linked relevant sources. Do
not scan `.sdlc/work/`, `.specifications/`, `.tickets/`, or other files in the
work folder for context. Apply the same boundary to delegates.

Check applicable repository guidance, affected code, and tests only to fill
material evidence gaps or verify source claims; do not repeat settled research
or treat old prose as proof of current behaviour. Surface stale or conflicting
intent instead of adopting it. Return an unsettled product or design choice to
`$engineering-decision-discovery` or `$engineering-specification` instead of
inventing it.

Before writing, audit coverage: every required behaviour, acceptance criterion
and applicable rollout constraint must be owned by a ticket. Each proposed
change must support an approved outcome, a concrete risk or an applicable
repository rule. Do not widen the specification's scope during decomposition.
If evidence shows that it prescribes unnecessary work, return a proposed
reduction to `$engineering-specification` rather than copying it uncritically
or silently discarding an approved requirement.

Also audit the state of the system after each ticket lands. The ticket that
introduces behaviour owns the relevant guard rails, boundary and failure
outcomes, and their verification. Do not defer its safety to a later feature
ticket. The specification must already settle how affected actors or inputs
are handled while a capability is incomplete. Return a gap upstream rather
than treating "out of scope" as a runtime policy.

Carry the specification's reason for its chosen verification seam into the
owning ticket. Do not turn endpoint or workflow acceptance wording into a new
validation ticket, journey fixture or companion repository change. New broader
scope needs the concrete uncovered behaviour and evidence that the selected
coverage is insufficient; mandatory-suite execution alone does not imply those
additions. Apply an existing explicit approved scope correction and carry its
rationale into the handoff. Return only an unresolved scope conflict upstream
instead of making unjustified expansion a dependency.

Apply `$engineering-testing` when specifying that verification. Name the
required behaviour, relevant existing coverage, any distinct gap and the
independent expected outcome. Do not add a test task for every ticket,
criterion, function or layer by default. Preserve the specification's required
checks; reuse existing coverage or justified alternative verification when
sufficient. A ticket's test cases must follow its contracts and credible
failures, not speculative permutations or an invented coverage target.

First check whether any prefactoring is necessary. Prefer the existing
component and test seams; do not plan cleanup or new abstractions for a local
fix unless the required behaviour cannot be delivered clearly without them.
Fold essential preparation into the slice. Use a separate prerequisite only
when it is independently verifiable and resolves a named implementation risk.
Prefer tracer-bullet vertical slices: each ticket delivers
a narrow, end-to-end behaviour across every layer that matters, is demoable or
otherwise verifiable on its own, and fits in one fresh implementation session.
Do not divide work into separate schema, API, UI, or test tickets. For a wide
mechanical change that cannot land green as vertical slices, use clearly
sequenced expand, migrate, and contract batches by blast radius. Keep each batch
independently green where possible. Create a final integrate-and-verify ticket
only when isolated green batches are genuinely impossible, and state that
exception in the ticket.

Keep ticket size achievable as well as useful. A vertical slice is a bounded
capability or scenario, not necessarily the whole feature. If it cannot fit
one fresh implementation session, narrow the scenario or choose a smaller
agreed milestone with meaningful verification and acceptable deferred
behaviour. Do not inflate a ticket just to cover every layer or edge of a
feature, or make separate tickets for incidental implementation steps.
Return an unsettled intermediate policy to specification before marking the
narrower ticket ready.

Build an acyclic blocker graph. Give every ticket explicit blockers, or `None
(can start immediately)`. A blocker represents an actual prerequisite, not a
preferred order. Each acceptance criterion must be observable, unambiguous,
and capable of failing at the starting revision. Reject criteria such as
"tests pass", implementation task lists, or claims already true at the
baseline.

A blocker does not by itself select a Git base. When the user requests a
stacked series, identify which selected dependencies require the predecessor's
delivered code. The coordinator later binds those dependencies to verified
branches and revisions in the launch context; decomposition must not invent
SHAs or treat a planned prerequisite as delivered. Independent roots can start
from updated `main`. Even when the user requests coordination of a selected
series, give each unit its own implementation invocation.

Keep stale detail out of tickets: do not include file paths or code snippets.
The only exception is a short, labelled prototype fragment when it is the
clearest record of a settled state machine, reducer, schema, or type decision.

Describe implementation increments only when distinct migration,
compatibility or delivery boundaries need staged verification. Omit this
section for a small fix; coupled code, regression tests and required setup can
be one coherent change. Do not invent phases to populate the template.

For each necessary increment, name its observable purpose, verification seam,
acceptable intermediate behaviour and commit boundary. Keep required guards
and tests with the behaviour they protect. Do not split by file, function,
layer or test case, or combine unrelated outcomes. Verify proposed boundaries
against the actual checkout before implementation.

State the current behaviour at deferred boundaries and name the later ticket
that changes it. Request a short code comment only where the reason for a
deliberate limitation would otherwise be unclear. Explain that constraint
without repeating control flow or implying that the later capability exists.
Its meaning must remain understandable without the local ticket file.

Link to shared lifecycle and rollout contracts. Restate only slice-specific
preconditions, permitted effects, retry/recovery responsibility or verification
that an implementer needs here. Do not duplicate the specification or
repository check commands. An unresolved intermediate policy still blocks the
ticket's readiness.

For required verification outside the implementation repository, confirm its
applicable environments, material prerequisites, repository owner and delivery
route through the actual runner or coordinating workflow. Carry slice-specific constraints into the
ticket or link their settled definition. An unmade selection policy or missing
delivery route blocks readiness. A defined but unexecuted check may remain an
evidence gap when its effect and completion requirement are explicit.

The blocker graph also identifies which tickets can be assigned independently.
For that frontier, make shared contracts and any integration dependencies
explicit. A ticket must not depend on another agent's unpublished decisions or
unfinished changes. Assign one implementation owner per ticket; multiple
ready tickets may use separate agents and isolated checkouts when their
dependencies and integration boundaries permit it.

## Create tickets

Validate the selected work reference and inspect only its `tickets/` target for
collisions. If absent or empty, write the ticket set immediately after the
local-exclusion check. A missing `.sdlc/work/` or work folder may be created as
part of this write. Do not show a preview as a substitute for writing, and do
not load other files merely because the work folder already exists.

Write one file per ticket with the required metadata and a compact body:

```md
# 01: <Outcome-oriented title>

**Work reference:** <reference>
**Source specification:** [<title>](<relative-path-to-approved-specification>)
**Status:** ready-for-agent
**Blocked by:** None (can start immediately)

## What to build

<The bounded behaviour delivered and its starting point.>

## Acceptance criteria

- [ ] <Observable behaviour unmet at the baseline.>

## Contracts and verification

<Relevant existing coverage, concrete gaps, expected results and required
checks. Link to shared rules; include only slice-specific constraints.>
```

Add decisions, implementation increments or deferred-behaviour sections only
when the slice needs them. Keep acceptance criteria explicit, but link to
shared definitions instead of repeating the specification's explanation.

For a blocked ticket, list every blocker as a relative Markdown link, such as
`[01 — Add read path](01-add-read-path.md)`, under `**Blocked by:**`. The
`ready-for-agent` status means the ticket content is prepared; the blocker graph
still decides whether it can start. Report the created paths and the ready
frontier: tickets with no open blockers. Do not implement tickets, create
branches, or make external changes.

## Review the saved tickets

After writing, read every saved ticket with the approved specification and
its selected relevant sources as an implementation handoff to a fresh agent.
Review the set for both missing information and simplification:

- Check that each slice has a clear starting behaviour, intended delta,
  required contracts, boundaries, prerequisites and credible verification.
  Surface facts a fresh implementer would otherwise have to guess. Confirm
  that every required outcome is owned and blockers are real prerequisites.
- Remove unnecessary decomposition, prefactoring, repeated specification
  content, unrelated context and checks without a distinct guarantee. Keep
  the smallest coherent change and the constraints needed to implement it.
- Resolve factual gaps from selected sources and repository evidence. Return
  gaps requiring a new decision or approved scope change to specification;
  do not invent a requirement or broaden a ticket to conceal uncertainty.

Revise only this invocation's newly created ticket files and repeat the
review after substantive changes. Do not hand off the set as ready until no
unnecessary scope or material information gap remains. Keep the review in
the conversation; do not create another report or checklist file.

Resolve every specification and blocker link from the containing file's
directory. Confirm the specification exists inside the invoking repository
and blockers resolve to the intended lower-numbered tickets. Broken links
prevent readiness.

## Handoff to a worker checkout

Ignored process files do not arrive in a fresh Git worktree or clone. For each
ready ticket, report its explicit repository-relative input file list alongside
the ticket path and ready frontier. Include the selected ticket, its approved
source specification, and only the linked process sources, named dependencies,
or deferred-boundary tickets needed for that slice. Do not collect an entire
work folder or follow unrelated links. Tracked code and repository guidance
come from the worker's checkout, not from this input list.

The launcher or coordinating agent transfers these selected inputs before
starting implementation in another checkout. Preserve their relative paths,
including explicitly selected legacy paths; copying a selected input is not
migration or permission to maintain it. Setup must verify exclusion in the
destination, reuse only byte-identical existing files, stop on collisions, and
resolve required links there before launching the worker. Exclusion may exist
only in Git's local exclude file; never require or change a committed
`.gitignore` rule, or assume that source-checkout exclusion travelled with a
clone.

The launch message supplies the destination checkout, agreed starting commit,
selected ticket or specification slice, and exact process input paths. Keep
this handoff in the launch message or conversation; do not create another
maintained document. Ticket decomposition ends with the input list and ready
frontier; checkout setup and implementation need their own authorised step.
For a selected stack, also identify the code dependency whose verified branch
and revision the coordinator must supply. Do not rewrite the ticket or
specification to track changing branch heads.
