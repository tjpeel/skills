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
tickets are uncommitted process inputs, not ongoing documentation. Do not
refresh them to describe implemented behaviour or include them in commits.
They do not imply a need for new ADRs, context files, feature guides or
implementation summaries.

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

## Prepare selected process inputs

When implementation will run in a different checkout, the launcher or
coordinating agent owns input setup before invoking the worker. Use the
explicit source checkout, destination checkout, agreed starting commit, and
selected ticket or specification slice. Build an explicit repository-relative
file list from that input and only its linked process sources, named
dependencies, or deferred-boundary tickets needed for the slice. Do not scan or
copy whole work folders. Tracked code and repository guidance come from the
destination checkout at the agreed commit.

Preflight the complete file list before copying any input. Treat paths
literally: use literal pathspecs for commands such as `git ls-files`, while
`git check-ignore` takes pathnames without pathspec magic. Confirm every source
exists inside the source checkout and every resolved destination stays inside
the destination checkout, including symlinks. Preserve file bytes, work
references, and repository-relative paths, including selected legacy paths;
do not rewrite links or update input content. Reuse an existing destination
only when its bytes match the selected source. Stop before copying on a missing
source, differing destination, or tracked output target; do not overwrite,
untrack, or merge files. Leave unrelated destination files untouched.

Verify Git exclusion in the destination for every input to be copied. An
existing `.gitignore` rule or local exclude may satisfy this; a committed
ignore rule is not required. If needed, append `/.sdlc/work/` to the local
exclude file resolved there by `git rev-parse --git-path info/exclude`; for
legacy inputs, use literal rules for their selected paths, escaping Git ignore
metacharacters. Preserve existing entries and never change `.gitignore` or
copy Git metadata from the source checkout. Recheck the resulting exclusion
with `git check-ignore` before copying. If any input remains unignored, do not
copy or launch; report the condition.

After copying, resolve the ticket's specification and required process-source
and dependency links inside the destination. Confirm the input set is complete,
remains untracked and ignored, and the destination still has the agreed
starting commit. Pass the worker the destination root, starting commit, exact
ticket or specification slice, and input paths; it must not search for missing
or alternative inputs. A failed handoff does not authorise implementation.
If copying or final validation fails, report which selected paths were copied
and what remains unresolved; do not launch with an incomplete set.
For work in the same checkout, no copying is needed; use the selected inputs
and verify their links without requiring a new handoff document.

## Establish the implementation boundary

Require the current task's explicitly supplied ticket path or approved
specification slice. A work reference selects an opaque folder key in
`.sdlc/work/<reference>/`, not every file beneath it. If only a reference was
supplied, ask for the input file or bounded slice rather than loading the
folder. Do not infer inputs from branch names, titles, recency, or matching
references. For a prepared launch, verify the supplied destination root,
starting commit, and selected inputs before reading them; do not fall back to
the planning checkout. Read the selected input in full and resolve its
repository root before changing implementation files.
If the working tree contains unrelated changes, identify them and ask the user
to isolate the ticket or supply a different fixed point before editing. Do not
claim a review covers only this ticket when its diff includes other work.

For a ticket, confirm that its path is beneath the invoking repository's
`.sdlc/work/<reference>/tickets/`, has status `ready-for-agent`, and that every
listed blocker is complete. Explicitly supplied legacy tickets in `.tickets/`
and specifications in `.specifications/` remain valid during transition; do
not discover or migrate them. Resolve the ticket's source-specification link
from its own directory, verify it stays inside this repository, and read that
approved specification. Check that any stated work reference agrees with the
selected folder; it has no required tracker or naming format.

Read only selected process inputs and directly linked sources relevant to
this slice or its named blockers and deferred boundaries. Do not scan work or
legacy directories, open unrelated files in the same folder, or follow links
to unrelated work. A missing source is a gap to report, not a reason to pick
another specification. Give delegates the same explicit inputs and boundary.

Read applicable repository guidance and relevant context or accepted ADRs
identified by that guidance or the selected sources. Treat the specification's
required behaviour, accepted decisions, acceptance criteria, change constraints,
and agreed test seams as approved intent. Establish actual behaviour from code,
tests and configuration. Surface
a contradiction with supporting prose rather than silently trusting it.

Use the ticket to select the behaviour due in this invocation. The full
specification constrains its contracts and shared invariants; it does not
authorise implementing every future feature. Read a sibling ticket only to
resolve a named dependency or deferred boundary. Confirm what incomplete paths
do today and what later work changes before coding them.

Check the handoff before editing: can the available sources establish the
relevant domain rules, valid inputs and preconditions, intended outcomes and
effects, boundary cases, and credible verification? Investigate missing facts
in the affected repositories and the actual runner. Before escalating a test
or execution choice, inspect existing commands, environment selection,
fixtures and scenario conventions, and evaluate a supported adaptation.
Routine choices preserving approved contracts remain the implementer's
responsibility. Ask a targeted question when the remaining choice changes
required behaviour, a guard rail, the verification guarantee or delivery scope.
Do not treat a newly proposed test structure as a ticket requirement.

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

For a prepared worker launch, verify that `HEAD` matches its agreed starting
commit. For a new ticket, create or verify its intended branch there and record
that commit as the review fixed point; a resumed ticket keeps its original
fixed point and increments. Do not refresh `main` or silently select a newer
starting revision. A mismatch stops the launch until the coordinator resolves
it. An already prepared branch can be used before it has implementation commits.

For an explicitly requested stack, the coordinator prepares each selected
ticket as a separate launch. Record its predecessor branch and verified SHA,
destination branch, review fixed point, and intended PR base alongside the
selected inputs. A dependent ticket starts from that predecessor's verified
content; an independent root follows the updated-`main` path below. Do not
fall back to `main` for a missing predecessor or commit a child's work onto
the parent's branch. If delivery depends on a published predecessor, verify
its remote head as well as the local commit before launching the child.

An upstream repair makes affected descendants stale until the coordinator
carries that repair through the selected stack and reverifies the resulting
content. Retain each ticket's original fixed point; after an authorised
restack, record how it maps to the new base and head so review still covers
the whole ticket rather than only its latest repair. Reuse
unaffected evidence only when its content and assumptions remain valid. A
local repair does not establish that a published child contains it.
Use only authorised restack operations; permission to repair or publish does
not by itself authorise force pushing or rewriting another owner's work.
Keep branch state in the existing launch context, without maintaining process inputs or
creating another tracker. One invocation still owns one selected ticket.

For new work without a prepared launch, in a clean working tree, fetch the
remote that tracks `main`,
switch to local `main`, and update it with a fast-forward-only pull from that
remote. Do not start from a stale local `main`, and do not merge or rebase
around a failed fast-forward. If
`main`, its remote tracking branch, or the fast-forward update is unavailable,
stop and report the condition to the user.

Never commit directly to `main`. If the current branch is `main`, create or
switch to the intended ticket branch before changing or committing files. All
implementation commits belong on that ticket branch.

The work reference is a folder key and may contain characters invalid in a Git
branch. Preserve it in process paths and ticket metadata. For a new ticket,
read `**Work reference:**` (or legacy `**Parent reference:**`) and use it
unchanged as a branch prefix only when the resulting branch is valid. Otherwise
choose a short branch-safe rendering separately, without renaming the work
folder or changing its reference. Validate it with
`git check-ref-format --branch`. Create it from the agreed starting commit
(normally the updated `main` commit) using this form:

```text
<branch-safe-reference>-<short-ticket-description>
```

Treat references and branch names as literal data in filesystem and shell
operations, not executable text.

For example, work reference `read-cache` and outcome “Add read
path” uses `read-cache-add-read-path`. Derive the description from the ticket's
outcome title rather than its sequence number or source-specification name.
Keep it short, lowercase, and limited to letters, numbers, and hyphens. If the
resulting branch already exists, do not repurpose it or silently choose a
different name; ask the user whether to continue that branch or choose a new
description.

For new work, record the agreed starting commit as the fixed point for the
later independent review; resumed work retains its original fixed point. The
coordinator owns branch creation and selection; a delegated writer works only
after that boundary exists.

One invocation owns one ticket or one independently deliverable specification
slice. Do not implement blocked or sibling tickets, add speculative
generalisations, or fold unrelated cleanup into the change. Make a separate,
small follow-up recommendation when you find work outside that boundary.

## Delegation profiles

For a small, familiar change, work directly. Use independent evidence when it
would materially reduce risk.

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

- Use `read_low` to map the affected behaviour, module boundary, conventions,
  existing tests, and the commands that exercise the agreed test seam.
- Use `read_medium` to audit a proposed change plan against the ticket or
  specification, check that each increment is a coherent, committable step
  within the ticket, identify unsupported scope, and check that each acceptance
  criterion has a credible observable verification path. Audit the plan as one
  bounded handoff; recheck only affected increments when its boundaries change.
- Use `read_high` only for credible migration, data-loss, security,
  concurrency, compatibility, or cross-service risk. It reports hazards,
  mitigations, and verification evidence; it does not make the change.
- Use `write_medium` as the sole implementation writer when delegated. Give it
  the ticket or approved slice as context, but authorise only the next planned
  increment, with its starting commit SHA, verifiable purpose, excluded work,
  test commands and local code and test ownership. It must stop after
  verification and return its diff and check results. The full ticket is
  context, not authorisation to implement later increments. It must not begin
  the next increment, broaden the ticket, change the source artifact, make
  external writes, or commit. A later increment needs a new handoff after the
  coordinator verifies that the preceding increment was committed.

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

## Plan commit boundaries before coding

The ticket is the useful vertical slice delivered by this invocation. A
commit increment is a smaller coherent step towards that outcome, not a
separate ticket or necessarily a complete vertical slice. It can introduce a
bounded behaviour, preserve behaviour through necessary preparation, or
establish an agreed partial capability. Each increment must land green with
credible checks and acceptable intermediate behaviour. Use the
specification's settled policy at incomplete boundaries; do not invent it to
make a commit possible.

Before editing, state a short ordered commit plan in the conversation. Each
planned increment has one verifiable purpose and a commit boundary: name the
ticket outcome or prerequisite it advances, its regression check and
relevant failure or recovery cases, and the work excluded until later
increments. Keep the plan in the conversation; do not create a planning
document. Use the ticket's checkpoints as input, but refine their commit
boundaries from code before authorising the writer.

Audit each proposed increment for both cohesion and achievability. Split a
bundle when it contains separable steps that can each be committed and
checked with acceptable intermediate behaviour. Keep coupled changes
together when splitting would break wiring, violate a contract or remove the
credible test seam; state that reason. Include the regression coverage and
guard rails needed for the step. Do not require a complete user feature per
commit, separate every test case or function, or leave changed behaviour
untested until a later commit. An atomic mechanical batch follows the same
test: keep it bounded and explain why it cannot safely be split.

For non-trivial work, have `read_medium` independently audit the proposed
boundaries before coding. It returns `accept` or `revise` for each
increment, checking both excessive scope and fragmentation that prevents a
coherent commit. When recommending a split, name a credible smaller
committable step and its verification; a shorter title or fewer files is not
enough. Resolve those findings before authorising the writer. If equivalent
delegation is unavailable, perform the same audit directly and disclose that
it was not independent. A small, clearly indivisible change can be checked
directly.

Keep only one increment active. If it grows beyond its authorised outcome,
stop extending the diff and revise the boundary before adding behaviour.
Reaudit affected boundaries when the plan changes materially. A large final
commit followed by cleanup commits does not satisfy this contract.

After the increment's focused verification and required pre-commit cycle,
stop editing. The coordinator inspects the actual diff against the
authorised outcome. Resolve scope violations and verify the final increment
revision before committing. Commit only that coherent increment, then verify
in Git that the commit exists on the ticket branch and includes the completed
increment, with none of its changes left pending. Report the completed outcome
and verification results in the conversation. Passing
checks or a writer's completion message alone do not permit the next
increment. If checks or the commit are blocked, keep the increment active
and report the blocker; do not continue into later behaviour. Follow any
explicit user instruction that changes the commit workflow.

The coordinator can authorise the next increment autonomously within
approved scope once this gate is satisfied. Apply the same stop, inspect,
commit and verify sequence when the coordinator also writes the code. Git
provides the commit history; include a SHA in a writer handoff or resumption
context when it is needed to pin the starting state.

## Build and verify one increment at a time

Apply `$engineering-testing` before adding or changing tests. Identify the
observable behaviour or credible failure, the gap in existing checks, and an
independent expected result. Existing tests count even when unchanged. Reuse
them when sufficient; add a case only for a distinct gap. Mechanical edits
and behaviour-preserving refactors can need verification without new tests.
State that decision and its evidence briefly in the handoff. A file, function
or ticket changing does not itself require a new test.

Use the test seams recorded by the specification or ticket. If the input does
not name one, identify the lowest-cost existing public boundary that faithfully
observes the required changed behaviour, using the repository's existing test
conventions. Add or update tests only for uncovered behaviour introduced or
changed by the ticket; do not backfill coverage for unrelated, pre-existing
functionality. Do not test private details, mock internal collaborators, or
assert values computed by the
same logic under test. Mock only genuine system boundaries when the
repository's existing test style supports it.

An established pattern may require deterministic assertions locally or in CI
while retaining applicable shared assertions in deployed runs. Reuse it when
it preserves the approved verification contract. Missing required prerequisites
in an applicable environment must fail or be reported as blocked. State what
other environments do not verify. A new project, filter or whole-scenario
exclusion needs a concrete reason when an existing assertion pattern suffices.

Establish early test feedback. Prefer a unit test for isolated domain or
application behaviour. Add an integration test when the changed behaviour
depends on real wiring, persistence, contracts, or interaction between
components; use the repository's local Docker Compose stack when it provides
the appropriate integration environment. Do not replace an interaction that
needs the local stack with mocks merely for convenience.

Work within the authorised increment. Where a test can express its next
observable case, make it fail first, implement only enough to make it pass,
then proceed to the next case within that outcome. Use a pre-existing test
when it is the clearest failing evidence. Where test-first work would not
give a clear boundary, complete one small implementation increment and verify
its outcome before beginning the next increment. Add or update regression
coverage only when a credible gap exists. If no test seam can reproduce the
actual failure, use the original reproducer and report the remaining coverage
gap instead of forcing a shallow test. State why test-first was impractical
in the implementation summary.

Run the narrowest relevant verification after each meaningful change: the
affected test or test file, type check or lint command where applicable, and
the project command that gives fast feedback. Resolve failures before moving
to the next slice. Run the relevant local Compose-based integration check
before returning an increment for commit when the change requires it. Its
relevant checks must pass, and its commit must be verified before the next
increment. Do not weaken, delete, or skip an existing test merely to
make the suite pass unless the approved change explicitly supersedes its
behaviour.

Derive regression cases from the ticket's acceptance criteria and relevant
domain rules, contracts and guard rails. Use conditions and expected results
that can distinguish a correct outcome from a plausible wrong implementation.
Cover material, uncovered boundary and failure cases, including the effects
that must not occur and how incomplete work is resolved where relevant. Verify
the observable outcome and next action, not just an exception or a helper's
return value.

At a deliberately incomplete boundary, add the short comment requested by the
ticket when the reason for the limitation would otherwise be unclear. Explain
the constraint without repeating control flow or implying that the final
capability exists. Keep it understandable without local planning files. Do not
add speculative scaffolding for later work.

## Commit logical, verified increments

Make each commit a coherent, committable step that moves the approved ticket
forward, with its relevant verification. For changed behaviour, keep the
regression test and the production change that satisfies it together; do not
combine independent behaviours, speculative cleanup, or a later ticket's
work. Keep related code, tests, and documentation justified by the
documentation boundary together when splitting them would leave the
repository in a misleading or incomplete state. This does not require
documentation in every increment.

Periodically inspect the pending diff as a reviewer would. If it exceeds the
authorised purpose, bundles separable committable steps, or cannot be
credibly verified as one increment, stop extending it. Resolve the boundary,
verify the coherent step, and complete the commit gate before continuing.
Use judgement rather than a file, line, or commit-count threshold.

Before every commit, apply the repository's coding standards and complete its
documented test cycle for that increment. This includes unit tests, integration
tests, and every other required check, not only the narrow checks used while
developing. Resolve failures before committing. If a documented check cannot
run, do not commit it as fully verified: report the command, reason, and
remaining risk to the user and wait for direction when the repository policy
requires a clean cycle.

Stage only the implementation files for that increment. Never stage process
inputs from `.sdlc/work/`, `.specifications/`, or `.tickets/`, including with a
force-add or broad staging command. Inspect the staged paths before committing.
After the coordinator's input setup, the implementation writer must not
untrack existing files, edit ignore rules, or maintain planning inputs. An
unrelated local process folder is not permission to load its contents.

Verify that the completed increment was committed before beginning or authorising
a later step, using the completion gate above. Do not defer all
commits until the ticket is fully implemented.

## Verify, review, and hand off

Apply `$engineering-verification` to each increment's completion evidence and
the final handoff. Identify the actual revision or working-tree content
checked, expected and observed outcomes, and any failed, blocked or omitted
required checks. For shared code or contracts, check the concrete safety
assumptions within the ticket's impact. Reuse the checks and evidence already
gathered; this does not require another test suite, report file or delegate.

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
- tests and other verification run, checked revision or artifact, expected
  and observed outcomes, and any evidence paths;
- acceptance criteria that remain unverified and why;
- follow-up work or risks outside the ticket boundary; and
- code-review findings, fixes, and any review limitations.

For stacked work, also report the predecessor revision used, current review
boundary and intended PR base, and any selected descendants made stale by
repairs. Distinguish verified local content from published content. When the
user also requested publishing and monitoring, continue through `$pr-manage`
and `$pr-monitor` within that authority; local verification alone does not
complete the requested delivery loop.

Return this handoff in the conversation; do not create a summary file by
default.

Commit the logical, fully verified increments created during implementation. Do
not push, create a pull request, or update an external tracker unless the user
explicitly asks.
