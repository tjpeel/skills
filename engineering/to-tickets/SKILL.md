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

For a small, clear specification, work directly. When independent mapping or
an audit would materially improve a non-trivial decomposition, use the least
sufficient delegated capability available in the current platform. In Codex,
use the installed custom profiles `read_low`, `read_medium`, `read_high`, or
`write_medium`; do not substitute a Codex built-in role. In Claude Code, use an
equivalently bounded subagent only when subagents are available. A profile or
subagent is an effort and access boundary, not a task role: give every handoff
its precise task, inputs, constraints, and required output. If the equivalent
is unavailable, perform that bounded responsibility in the coordinating agent.

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

Before writing, audit coverage: every required behaviour, observable
acceptance criterion, and applicable change or rollout constraint in the
specification must be owned by at least one ticket. Reject ticket scope that is
not supported by the approved specification.

Also audit the state of the system after each ticket lands. The ticket that
introduces behaviour owns the relevant guard rails, boundary and failure
outcomes, and their verification. Do not defer its safety to a later feature
ticket. The specification must already settle how affected actors or inputs
are handled while a capability is incomplete. Return a gap upstream rather
than treating "out of scope" as a runtime policy.

Apply `$engineering-testing` when specifying that verification. Name the
required behaviour, relevant existing coverage, any distinct gap and the
independent expected outcome. Do not add a test task for every ticket,
criterion, function or layer by default. Preserve the specification's required
checks; reuse existing coverage or justified alternative verification when
sufficient. A ticket's test cases must follow its contracts and credible
failures, not speculative permutations or an invented coverage target.

Identify necessary prefactoring first. Fold it into the first vertical slice by
default. Create a separate prerequisite only when it can land green, is
independently verifiable, and creates a necessary seam or materially reduces
implementation risk. Prefer tracer-bullet vertical slices: each ticket delivers
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

For a non-trivial ticket, provide a short sequence of observable
implementation increments. The ticket delivers the vertical slice; an
increment is a smaller committable step towards it and need not deliver a
standalone user capability. It may be necessary preparation, a bounded
behaviour change or an agreed partial capability. Give each checkpoint one
verifiable purpose, its regression check and seam, and a commit boundary
excluding later work. Keep relevant tests and guard rails with each step; it
must land green with acceptable intermediate behaviour.

Reject a checkpoint that bundles separable committable steps. Also reject a
split that leaves broken wiring, violates a contract or loses a credible
test seam; explain the coupling instead. Do not turn every function, test
case or layer into a checkpoint. Resolve overly broad checkpoints before
marking the ticket ready, and explain why an atomic batch cannot safely be
split when that exception applies. The implementer must audit the proposed
boundaries against actual repository evidence before coding; they are not
permission to make an oversized commit.

State the current behaviour at deferred boundaries and name the later ticket
that changes it. Request a short code comment only where the reason for a
deliberate limitation would otherwise be unclear. Explain that constraint
without repeating control flow or implying that the later capability exists.
Its meaning must remain understandable without the local ticket file.

Carry the specification's relevant lifecycle rows into the slice's contracts
and verification: what permits work to start, which effects are allowed while
another stage is incomplete, how retry or replay behaves, and who recovers a
partial effect. Name the prerequisite that makes a transition available. Do
not mark a ticket ready while its observable intermediate behaviour depends
on an unsettled rollout or recovery policy.

Audit each ticket as an implementation handoff to a fresh agent. Using the
ticket, linked specification and applicable repository sources, it must be able
to identify the starting behaviour, intended delta, relevant domain rules and
contracts, boundary and failure outcomes, exclusions, prerequisites and
credible verification. Include the slice-specific detail needed to connect
those sources; do not copy the whole specification. Resolve a missing fact
from evidence or ask a targeted question and return an unsettled choice
upstream before marking the ticket ready.

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

Write one file for each ticket using this form:

```md
# 01: <Outcome-oriented title>

**Work reference:** <reference>
**Source specification:** [<title>](<relative-path-to-approved-specification>)
**Status:** ready-for-agent
**Blocked by:** None (can start immediately)

## What to build

<The end-to-end behaviour delivered, in the project's domain language.>

## Acceptance criteria

- [ ] <Observable behaviour that is unmet at the baseline.>
- [ ] <Independent observable behaviour.>

## Decisions and constraints

<Only settled detail that a fresh implementation session needs. Omit this
section when it is empty.>

## Contracts and verification

<The slice's relevant inputs, preconditions, outcomes and effects; boundary or
failure examples and expected results; and the seams that can verify them.
Link to shared definitions rather than duplicating them.>

## Implementation increments

<For non-trivial work, ordered committable steps within this ticket: each step's
verifiable purpose, regression check and seam, acceptable intermediate behaviour
and boundary excluding later work. Each step need not be a complete vertical
slice.>

## Deferred behaviour

<When applicable, current behaviour and consequences at incomplete boundaries,
the later ticket that changes each, and any comment needed to explain it.>
```

For a blocked ticket, list every blocker as a relative Markdown link, such as
`[01 — Add read path](01-add-read-path.md)`, under `**Blocked by:**`. The
`ready-for-agent` status means the ticket content is prepared; the blocker graph
still decides whether it can start. Report the created paths and the ready
frontier: tickets with no open blockers. Do not implement tickets, create
branches, or make external changes.

Before handing off, resolve every specification and blocker link from the
directory of the file containing it. Confirm the specification target exists
inside the invoking repository and blocker links resolve to the intended
lower-numbered tickets. A written file with a broken source link is not ready
for an isolated implementation session.

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
