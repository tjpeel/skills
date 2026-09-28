---
name: engineering-implement
description: Implement one ready local engineering ticket or a clearly scoped approved specification, preserving its decisions, observable acceptance criteria, and test seams. Use after ticket decomposition; do not use to make design decisions, write tickets, or independently review a completed change.
---

# Engineering implementation

Implement one ready unit of approved work without widening its scope. The
normal input is a local ticket created by `$engineering-to-tickets`; a small,
clearly bounded approved specification is also sufficient when no ticket set
is needed. This is the build step after decision discovery, specification, and
ticket decomposition.

## Establish the implementation boundary

Read the input in full and resolve its repository root before changing files.
For a ticket, confirm that it is in `.tickets/`, has status `ready-for-agent`,
and that every listed blocker is complete. Read its source specification,
applicable repository guidance, `CONTEXT.md` or `CONTEXT-MAP.md`, and accepted
ADRs. Treat the specification's required behaviour, accepted decisions,
acceptance criteria, change constraints, and agreed test seams as the source
of truth.

Do not start when an input has blocking questions, conflicts with an accepted
decision, has an unresolved blocker, or needs an unrecorded product or design
choice. Return that choice to `$engineering-decision-discovery` or
`$engineering-specification`; do not fill the gap with an implementation
assumption. If the ticket or specification is insufficient to identify a
bounded change, ask the user for the missing source rather than exploring into
neighbouring tickets.

One invocation owns one ticket or one independently deliverable specification
slice. Do not implement blocked or sibling tickets, add speculative
generalisations, or fold unrelated cleanup into the change. Make a separate,
small follow-up recommendation when you find work outside that boundary.

## Delegation profiles

For a small, familiar change, work directly. When independent evidence would
materially reduce risk, use the least sufficient custom profile from
`~/.codex/agents/`: `read_low`, `read_medium`, `read_high`, or `write_medium`.
A profile is an effort and access boundary, not a task role: give every
handoff its precise task, input paths, constraints, and required output. Do
not use Codex built-in `default`, `worker`, or `explorer` agents. If a profile
is unavailable, perform that bounded responsibility in the coordinating agent.

- Use `read_low` to map the affected behaviour, module boundary, conventions,
  existing tests, and the commands that exercise the agreed test seam.
- Use `read_medium` to audit a proposed change plan against the ticket or
  specification, identify unsupported scope, and check that each acceptance
  criterion has a credible observable verification path.
- Use `read_high` only for credible migration, data-loss, security,
  concurrency, compatibility, or cross-service risk. It reports hazards,
  mitigations, and verification evidence; it does not make the change.
- Use `write_medium` as the sole implementation writer when delegated. Give it
  exactly one ready ticket or approved specification slice, the relevant
  sources and test commands, and ownership of the resulting local code and
  tests. It must not broaden the ticket, change the source artifact, make
  external writes, or commit.

The coordinator owns the implementation boundary, user questions, branch and
commit decisions, and any external action. Read-only handoffs return evidence
only. Do not run parallel writers in one working tree.

## Build one observable behaviour at a time

Use the test seams recorded by the specification or ticket. If the input does
not name one, identify the smallest existing public boundary that observes the
required behaviour and ask the user to confirm it before adding a test. Do not
test private details, mock internal collaborators, or assert values computed
by the same logic under test. Mock only genuine system boundaries when the
repository's existing test style supports it.

Where a test can express the next observable behaviour, work in small vertical
slices: make one test fail for the agreed behaviour, implement only enough to
make it pass, then proceed to the next behaviour. Use a pre-existing test when
it is the clearest failing evidence. When test-first work is impractical,
state why in the implementation summary and still add or update the smallest
credible regression coverage at the agreed seam.

Run the narrowest relevant verification after each meaningful change: the
affected test or test file, type check or lint command where applicable, and
the project command that gives fast feedback. Resolve failures before moving to
the next slice. Do not weaken, delete, or skip an existing test merely to make
the suite pass unless the approved change explicitly supersedes its behaviour.

## Verify and hand off

Before declaring the work complete, inspect the final diff against the input.
Check every acceptance criterion and applicable change constraint against an
observable result. Run the full relevant test suite or the repository's
documented equivalent once after the narrow checks are green. If the full
suite cannot run, report the exact command, reason, and the narrower checks
that did run; do not claim complete verification.

Return a concise handoff with:

- the ticket or specification slice implemented;
- changed behaviour and any deliberately untouched scope;
- tests and other verification run, including outcomes;
- acceptance criteria that remain unverified and why; and
- follow-up work or risks outside the ticket boundary.

Do not perform an independent review of the finished change in this skill. A
dedicated code-review skill remains a separate workflow step so it can be used
for implementation work and other change types. Do not commit, push, create a
pull request, or update an external tracker unless the user explicitly asks.
