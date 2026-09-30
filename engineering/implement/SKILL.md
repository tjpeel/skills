---
name: engineering-implement
description: Implement one ready local engineering ticket or a clearly scoped approved specification, preserving its decisions, observable acceptance criteria, and test seams. Use after ticket decomposition; do not use to make design decisions or write tickets.
---

# Engineering implementation

Implement one ready unit of approved work without widening its scope. The
normal input is a local ticket created by `$engineering-to-tickets`; a small,
clearly bounded approved specification is also sufficient when no ticket set
is needed. This is the build step after decision discovery, specification, and
ticket decomposition.

## Documentation boundary

Code is the documentation of implemented functionality. Do not generate
additional docs by default during implementation. Specifications and local
tickets remain the planning inputs; they do not imply a need for new ADRs,
context files, feature guides or implementation summaries.

Prefer clear names, structure and tests. Use a focused comment for non-obvious
rationale or a constraint close to the code it affects. Create or update a
supporting document only for an explicit request, an applicable repository
requirement or a material knowledge gap that code, tests and configuration
cannot convey. Identify that need before writing. Keep the document to decision
rationale, external constraints or domain context, with links to the relevant
implementation and tests. Do not maintain a second explanation of algorithms,
control flow or feature behaviour that can drift from the code.

Check relevant existing docs when a change affects their claims. Remove stale
or duplicated explanations, or replace them with signposts, rather than adding
another account. Documentation must not conceal unclear code or contradict
executable behaviour.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Establish the implementation boundary

Read the input in full and resolve its repository root before changing files.
If the working tree contains unrelated changes, identify them and ask the user
to isolate the ticket or supply a different fixed point before editing. Do not
claim a review covers only this ticket when its diff includes other work.

For a ticket, confirm that it is in `.tickets/`, has status `ready-for-agent`,
and that every listed blocker is complete. Read its source specification,
applicable repository guidance, relevant existing context, and accepted
ADRs. Treat the specification's required behaviour, accepted decisions,
acceptance criteria, change constraints, and agreed test seams as approved
intent. Establish actual behaviour from code, tests and configuration. Surface
a contradiction with supporting prose rather than silently trusting it.

Use the ticket to select the behaviour due in this invocation. The full
specification constrains its contracts and shared invariants; it does not
authorise implementing every future feature. Read a sibling ticket only to
resolve a named dependency or deferred boundary. Confirm what incomplete paths
do today and what later work changes before coding them.

Check the handoff before editing: can the available sources establish the
relevant domain rules, valid inputs and preconditions, intended outcomes and
effects, boundary cases, and credible verification? Investigate missing facts
in the repository. Ask a targeted question when the remaining gap changes
observable behaviour or a guard rail. Routine implementation choices that
preserve those contracts remain the implementer's responsibility.

Do not start when an input has blocking questions, conflicts with an accepted
decision, has an unresolved blocker, or needs an unrecorded product or design
choice. Return that choice to `$engineering-decision-discovery` or
`$engineering-specification`; do not fill the gap with an implementation
assumption. If the ticket or specification is insufficient to identify a
bounded change, ask the user for the missing source rather than exploring into
neighbouring tickets.

## Prepare the ticket branch

Establish the implementation branch before changing files. When resuming an
already authorised ticket branch, verify its ticket, original fixed point and
existing increments, then continue there. Do not reset it or create another
branch for each handoff. If its boundary cannot be established, resolve that
gap before editing.

For new work in a clean working tree, fetch the remote that tracks `main`,
switch to local `main`, and update it with a fast-forward-only pull from that
remote. Do not start from a stale local `main`, and do not merge or rebase
around a failed fast-forward. If
`main`, its remote tracking branch, or the fast-forward update is unavailable,
stop and report the condition to the user.

Never commit directly to `main`. If the current branch is `main`, create or
switch to the intended ticket branch before changing or committing files. All
implementation commits belong on that ticket branch.

For a new ticket, take the exact value of its `**Parent reference:**` detail and
append a concise kebab-case description of the ticket outcome. Create the new
branch from the updated `main` commit using this form:

```text
<parent-reference>-<short-ticket-description>
```

For example, a ticket with parent reference `MO-123` and outcome “Add read
path” uses `MO-123-add-read-path`. Derive the description from the ticket's
outcome title rather than its sequence number or source-specification name.
Keep it short, lowercase, and limited to letters, numbers, and hyphens. If the
resulting branch already exists, do not repurpose it or silently choose a
different name; ask the user whether to continue that branch or choose a new
description.

For new work, record the updated `main` commit as the fixed point for the later
independent review; resumed work retains its original fixed point. The
coordinator owns branch creation and selection; a delegated writer works only
after that boundary exists.

One invocation owns one ticket or one independently deliverable specification
slice. Do not implement blocked or sibling tickets, add speculative
generalisations, or fold unrelated cleanup into the change. Make a separate,
small follow-up recommendation when you find work outside that boundary.

## Delegation profiles

For a small, familiar change, work directly. When independent evidence would
materially reduce risk, use the least sufficient delegated capability available
in the current platform. In Codex, use the installed custom profiles
`read_low`, `read_medium`, `read_high`, or `write_medium`; do not substitute a
Codex built-in role. In Claude Code, use an equivalently bounded subagent only
when subagents are available. A profile or subagent is an effort and access
boundary, not a task role: give every handoff its precise task, input paths,
constraints, and required output. If the equivalent is unavailable, perform
that bounded responsibility in the coordinating agent.

- Use `read_low` to map the affected behaviour, module boundary, conventions,
  existing tests, and the commands that exercise the agreed test seam.
- Use `read_medium` to audit a proposed change plan against the ticket or
  specification, identify unsupported scope, and check that each acceptance
  criterion has a credible observable verification path.
- Use `read_high` only for credible migration, data-loss, security,
  concurrency, compatibility, or cross-service risk. It reports hazards,
  mitigations, and verification evidence; it does not make the change.
- Use `write_medium` as the sole implementation writer when delegated. Give it
  the ticket or approved slice as context, but authorise only the next planned
  increment, with its observable outcome, boundaries, test commands and local
  code and test ownership. It must stop and return its diff and verification
  after that increment. It must not begin the next increment, broaden the
  ticket, change the source artifact, make external writes, or commit.

The coordinator owns the implementation boundary, user questions, branch and
commit decisions, and any external action. Read-only handoffs return evidence
only. Do not run parallel writers in one working tree.

## Scrutinise reference implementations

Before copying or adapting code from another repository, identify the requested
alignment and inspect the source in context, including callers, configuration
and tests. State what will be reused, what will be adapted, and what behaviour
is excluded. Compare the source's assumptions, responsibilities, contracts and
effects with the destination's agreed guard rails. Trace each imported policy
to the destination ticket, accepted decision or repository requirement. A
request to match a convention does not implicitly adopt unrelated behaviour.

Adapt the mechanism to the destination's actual contracts and environment;
do not rely on renamed code or copied defaults as evidence of alignment. An
unsettled behavioural difference goes upstream; a routine adaptation that
preserves approved behaviour does not need fresh permission.

Verify the resulting destination behaviour at its own test seam, especially
failure and recovery paths. Passing source tests or visual similarity is not
evidence that the adaptation fits this service.

## Plan bounded iterations

Before editing, state a short ordered plan in the conversation. Each increment
names one observable outcome, the acceptance criteria it advances, its credible
regression check, and any relevant failure or recovery case. Use the ticket's
checkpoints where supplied and refine them from repository evidence. Do not
divide a vertical outcome into production-code-first and tests-later batches.

Keep only one increment active. At its end, inspect the diff for scope and
deferred behaviour, run focused verification and the repository's required
pre-commit cycle, then commit the coherent result before starting the next
separable behaviour. Report the completed outcome and next increment. If the
slice grows beyond its stated outcome, reduce or revise the remaining plan
before extending the diff. A large final commit followed by cleanup commits
does not satisfy this iteration contract.

## Build one observable behaviour at a time

Use the test seams recorded by the specification or ticket. If the input does
not name one, identify the smallest existing public boundary that observes the
required changed behaviour, using the repository's existing test conventions.
Add or update tests only for behaviour introduced or changed by the ticket; do
not backfill coverage for unrelated, pre-existing functionality. Do not test
private details, mock internal collaborators, or assert values computed by the
same logic under test. Mock only genuine system boundaries when the
repository's existing test style supports it.

Establish early test feedback. Prefer a unit test for isolated domain or
application behaviour. Add an integration test when the changed behaviour
depends on real wiring, persistence, contracts, or interaction between
components; use the repository's local Docker Compose stack when it provides
the appropriate integration environment. Do not replace an interaction that
needs the local stack with mocks merely for convenience.

Work in small vertical slices. Where a test can express the next observable
behaviour, make it fail first, implement only enough to make it pass, then
proceed to the next behaviour. Use a pre-existing test when it is the clearest
failing evidence. Where test-first work would not give a clear boundary,
complete one small implementation increment and add or update its smallest
credible regression coverage before beginning the next increment. State why
test-first was impractical in the implementation summary.

Run the narrowest relevant verification after each meaningful change: the
affected test or test file, type check or lint command where applicable, and
the project command that gives fast feedback. Resolve failures before moving to
the next slice. Run the relevant local Compose-based integration check before
calling an iteration complete when the change requires it. An iteration is
complete only when its relevant checks pass. Do not weaken, delete, or skip an
existing test merely to make the suite pass unless the approved change
explicitly supersedes its behaviour.

Derive regression cases from the ticket's acceptance criteria and relevant
domain rules, contracts and guard rails. Use conditions and expected results
that can distinguish a correct outcome from a plausible wrong implementation.
Cover material boundary and failure cases, including the effects that must not
occur and how incomplete work is resolved where relevant. Verify the observable
outcome and next action, not just an exception or a helper's return value.

At a deliberately incomplete boundary, add the short comment requested by the
ticket when the reason for the limitation would otherwise be unclear. Explain
the constraint without repeating control flow or implying that the final
capability exists. Keep it understandable without local planning files. Do not
add speculative scaffolding for later work.

## Commit logical, tested increments

Make each commit the smallest logical increment that moves the approved
solution forward. A commit should contain one coherent vertical slice, such as
the regression test and the minimum production change that satisfies it; do
not combine independent behaviours, speculative cleanup, or a later ticket's
work. Keep related code, tests, and documentation justified by the documentation
boundary together when splitting them would leave the repository in a
misleading or incomplete state. This does not require documentation in every
increment.

Periodically inspect the pending diff as a reviewer would. If it contains more
than one independently understandable behaviour, mixes separable concerns, or
cannot be clearly validated as one increment, stop extending it. Finish and
verify the smallest coherent slice, commit it, then continue with the next
slice. Use judgement rather than a file, line, or commit-count threshold.

Before every commit, apply the repository's coding standards and complete its
documented test cycle for that increment. This includes unit tests, integration
tests, and every other required check, not only the narrow checks used while
developing. Resolve failures before committing. If a documented check cannot
run, do not commit it as fully verified: report the command, reason, and
remaining risk to the user and wait for direction when the repository policy
requires a clean cycle.

Commit a completed, fully tested iteration before beginning a later separable
behaviour; do not defer all commits until the ticket is fully implemented.

## Verify, review, and hand off

Before declaring the work complete, inspect the final diff against the input.
Check every acceptance criterion and applicable change constraint against an
observable result. Run the full relevant test suite or the repository's
documented equivalent once after the narrow checks are green. If the full
suite cannot run, report the exact command, reason, and the narrower checks
that did run; do not claim complete verification.

After the focused and full checks are green, invoke
`$engineering-code-review` against the recorded fixed point. Supply the
ticket or specification, applicable standards sources, changed-file list, and
verification evidence. Fix actionable review findings that remain within the
approved scope, rerun affected verification, and repeat the review against the
same fixed point. Return a finding that needs a new decision to the relevant
upstream workflow rather than expanding the ticket.

The review covers all ticket commits and pending changes against that fixed
point, including imported code, comments and configuration. It must include a
technical assessment of the code's actual behaviour as well as requirements
tracing. After repairs, complete the repository-required full check cycle for
the final revision before declaring completion; results from an earlier
revision do not verify the repaired result. If an independent reviewer is
unavailable, perform the review directly and disclose that limitation.

Return a concise handoff with:

- the ticket or specification slice implemented;
- changed behaviour and any deliberately untouched scope;
- tests and other verification run, including outcomes;
- acceptance criteria that remain unverified and why;
- follow-up work or risks outside the ticket boundary; and
- code-review findings, fixes, and any review limitations.

Return this handoff in the conversation; do not create a summary file by
default.

Commit the logical, fully tested increments created during implementation. Do
not push, create a pull request, or update an external tracker unless the user
explicitly asks.
