---
name: engineering-code-review
description: Review a local engineering change against its approved ticket or specification and repository standards, reporting only actionable correctness, regression, security, compatibility, concurrency, or test risks. Use after implementation or to review another local change; do not use to make the change or review external pull requests.
---

# Engineering code review

Review a local diff independently of its implementation. Check two distinct
questions without allowing one to hide the other:

- **Requirements:** does the change deliver the approved ticket or
  specification without unsupported scope?
- **Standards and risk:** does the change respect documented repository
  conventions and avoid actionable correctness, regression, security,
  compatibility, concurrency, or test risks?

Use this after `$engineering-implement` has completed focused verification, or
whenever the user needs an evidence-based review of a local change. It is a
review-only skill: it does not edit code, commit, push, publish comments, or
approve a pull request. Use `$pr-review` for a colleague's pull request.

Code documents implemented functionality. Do not request additional docs by
default. Specifications and local tickets are uncommitted process inputs, not
ongoing documentation; do not require them to be committed, refreshed, or
maintained after delivery. Missing ADRs, context files or functionality guides
alone are not defects. Request a new
document only for an explicit requirement or material knowledge gap that code
cannot convey. Report misleading claims or broken signposts in relevant docs
when they could cause a concrete error in a future change or operation. Prefer
removing duplicated explanations or linking to code over extending them.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Pin the review boundary

Require a fixed point: a commit, branch, tag, merge-base, or the `HEAD` commit
recorded before implementation began. Confirm that it resolves before judging
the change. Capture `git diff <fixed-point>...HEAD` and
`git log <fixed-point>..HEAD --oneline` once, then also capture any staged or
unstaged working-tree changes. Record the changed-file list and give the same
commands and evidence to every delegated reviewer.

Before assigning reviewer work, confirm that the fixed point and selected
input paths resolve, match verification evidence to the reviewed commit or
working-tree content, and check model and tool boundaries. Validate supplied
input hashes or handoff contracts when present. Supply read-only reviewers
with the diff and command results they cannot collect within their tool
boundary. Stale or missing evidence remains a verification gap.

If the fixed point is unknown, ask for it. Do not infer that the current branch
base represents one ticket when it also contains unrelated work. Stop when the
combined diff is empty. If unrelated changes share the working tree, identify
them and ask the user to narrow the review boundary rather than attributing
them to the ticket.

## Find requirements and standards sources

When the independent coordinating root owns the review, defer reading planning
artifacts and the implementer's explanation until its initial technical
assessment. Validate supplied paths beforehand, then read the selected intent
to reconcile that assessment. A delegated review owner receives the same
staged evidence.

Use only the ticket path or approved specification slice explicitly supplied
for this review. New process inputs belong in
`.sdlc/work/<reference>/specification.md` and
`.sdlc/work/<reference>/tickets/`; the reference is an opaque folder key with
no required tracker or naming format. Explicitly supplied legacy files in
`.specifications/` and `.tickets/` remain valid during transition. Do not infer
inputs from branch names, titles, recency, or matching references, or scan those
directories for intent. A folder reference alone does not select an input;
report the missing source and continue the technical review.

For a selected ticket, read its acceptance criteria, decisions, constraints,
and source-specification link. Resolve links from the ticket's own directory;
verify the source is inside the invoking repository and read the approved
specification in full. Read other process files only when directly linked and
relevant to the current slice, a named dependency, or a deferred boundary.
Do not load unselected files in the same folder or follow unrelated work.
Give every delegate the same explicit source paths and input boundary.

The ticket selects the current delivery slice; the specification constrains
its contracts and shared invariants. Do not report an explicitly deferred
feature as missing from this ticket, or excuse a defect in its current partial
behaviour because another ticket will extend it. Check source claims against
current code and surface stale or conflicting intent instead of adopting it.

Read applicable repository guidance, relevant context and accepted ADRs
identified by that guidance or the selected sources, and the relevant existing
code and tests. Treat a Markdown
`CODING_STANDARDS.md` at the repository root as the canonical coding-standards
file. If it is absent, look for the same name under `docs/`, then for
`CONTRIBUTING.md`, `STYLEGUIDE.md`, or `STYLE_GUIDE.md` at the root or under
`docs/`. Read only files that actually state applicable coding standards.

If no approved specification was supplied or linked, still run the technical
review and report which requirements could not be assessed. A selected ticket
can establish its stated intent, but does not prove approval of a missing source.
If the selected ticket's source-specification link is missing, is outside the
repository, or does not resolve, report that limitation rather than searching
for a substitute. This review never changes process files or ignore rules.

## Delegation profiles

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.
Give every handoff the fixed point, exact diff commands, source paths,
constraints and required output.

Name one independent owner for the complete diff and both assessment axes.
A fresh root, including one from another provider, can own the review directly
when it has sufficient reasoning capability. If the coordinator implemented
the change, use a fresh reviewer. Keep requirements and technical conclusions
distinct within that review; they do not require separate complete reviews.

- Use `read_high` or an equivalent high-effort owner for substantive review.
  A clear, bounded change with understood runtime effects may be reviewed
  directly at medium effort. Diff size alone does not justify lower effort
  or additional agents.
- Use `read_low` only to resolve a missing behaviour, test or standards map,
  or to verify selected source links. Use `read_medium` only for a specific
  requirements trace, verification or coverage uncertainty. Helpers report
  evidence and contradictions, not final findings.
- Use `read_deep` for a selected review or unresolved question whose difficult
  interacting contracts, destructive effects, authentication or secret
  boundaries, migrations, concurrency or cross-service recovery justify
  maximum reasoning. Material risk warrants scrutiny but does not automatically
  require maximum effort or a second complete review.
- Reserve `read_exceptional` or another senior reviewer for an unresolved
  material dispute with a complete evidence packet. Escalate the difficult
  question without repeating unrelated review work.

The owner's initial evidence contains raw code, diff, tests, repository
standards and runtime wiring, excluding requirements mappings, planning
artifacts and the implementer's explanation. Then supply selected intent and
coverage evidence to reconcile its conclusions. Keep all reviewers inside
the selected input boundary and wait for required results before returning
the assessment. Reuse relevant mapping and verification evidence; do not add
agents merely to fill roles.

The coordinator owns the fixed-point decision, final assessment, user
questions, and any repair. Read-only delegates do not alter code, contact
reviewers, or make external writes.

When comparing routing costs, record agent count, elapsed time, repeated
investigations, findings and reported usage. Leave missing measures unknown;
unlike reviews do not establish savings.

## Review the change

First trace the actual behaviour from public entry points through effects,
failure handling and recovery using code, tests and applicable configuration.
Identify the actors, inputs, state changes, contracts and invariants affected
by the diff. Derive concrete boundary and failure scenarios from those paths
and the surrounding system. Check who can act, which conditions permit effects,
what happens when an operation is incomplete, and how the next action follows.
Investigate interacting limits or imported assumptions when they create a
credible failure scenario. Compare comments and docs with executable behaviour.

Do this without relying on the implementer's narrative or treating the planning
artifacts as proof of correctness. If an expected domain outcome is uncertain,
use available repository evidence or ask a targeted question while continuing
the review of unaffected paths. Distinguish a verified technical defect from a
requirements question; do not invent policy to resolve the latter.

Then check requirements. Compare each in-scope required behaviour, accepted
decision, observable acceptance criterion, and applicable rollout or change
constraint with the diff and its verification. Report missing, partial, or
apparently incorrect behaviour; scope that the source did not ask for; and
tests that do not actually observe the intended behaviour.

Apply `$engineering-verification` when assessing the supplied evidence.
Confirm that results describe the actual revision or working-tree content
under review, that checks observed their claimed outcomes, and that blocked
or skipped checks remain explicit gaps. Check a shared contract's concrete
safety assumptions when material to the diff. Reuse the existing reviewers;
a completion summary is not an independent verification result. Rerun a
relevant check when evidence is stale, missing or cannot establish the claim.

For relevant lifecycle contracts, check the actual startup, mixed-version,
activation, retry and recovery paths against the selected state rows. Verify
what readiness permits and what can still happen after a partial external
effect; a healthy host does not by itself prove its worker can process safely.
For a stack, verify that the reviewed child includes its required predecessor
repairs and that its base isolates the intended slice. Keep local repairs and
the published PR head distinct when assessing delivery claims.

Scrutinise excessive verification scope as well as missing coverage. New journey
scenarios, fixtures or companion changes must protect a named gap that cheaper
seams cannot cover. Report unnecessary scope only when it creates an actionable
cost, fragility or correctness problem. Distinguish required suite execution
from new test authoring, and name a repository-rule conflict when it requires
an upstream decision rather than demanding more tests by default.

Apply `$engineering-testing` when assessing coverage and test quality. Map
required changed behaviour and credible failures to existing, updated or new
tests at the agreed seam, or to justified alternative verification. An unchanged
test can supply coverage; the absence of new test files is not a finding.
Identify material uncovered failures in new error paths, branches and
integration boundaries. Request a test only when it fills a concrete gap and
can observe that failure. Do not ask for private implementation tests,
unrelated coverage, or a case for every changed line or function.

Check new and changed tests for the named anti-patterns in that guidance:
tautological, implementation-coupled, change-detector, mock-only interaction,
vacuous, duplicate, coverage-only and speculative tests. Distinguish a
meaningful output snapshot or boundary-interaction contract from incidental
structure checks. Report a concrete missed guarantee or maintenance burden,
not a test style preference. Do not remove coverage merely because two tests
touch the same code.

Where the repository provides a coverage command or report, inspect coverage
for the diff or new code as well as any reported overall project coverage.
Distinguish line, branch, and function coverage when the tooling reports them;
new code can have good line coverage while important branches remain untested.
Without an explicit coverage requirement, low coverage alone does not establish
a missing-test finding; connect it to an uncovered required outcome or credible
failure.
Report the measured new-code or diff-coverage volume and the overall figure
separately. Do not invent a percentage threshold: apply one only when the
specification or repository standards define it. If no coverage measurement is
available, state that limitation and assess coverage from the test-to-behaviour
mapping instead.

Then check standards and risk. Apply documented repository rules before
general heuristics. Treat any heuristic as a judgement call, not a rule, and
skip matters already enforced by tooling. Look for misleading names, duplicated
logic, awkward data groups, inappropriate primitives for important domain
concepts, repeated branching, unnecessary abstraction, misplaced behaviour,
and avoidable dependency chains when they materially affect the changed code.
Also inspect error paths, data handling, compatibility boundaries, concurrency,
resource ownership, and security-sensitive input or output whenever relevant.

Do not report style preferences, hypothetical redesigns, pre-existing defects
outside the diff, or missing tests with no credible failure scenario. Do not
mark a change safe merely because tests pass; verify that the tests exercise
the claimed behaviour at the agreed seam.

## Report and return repairs to implementation

Report findings under separate `## Requirements` and `## Standards and risk`
headings. Keep those axes separate: a conventionally clean change can implement
the wrong requirement, and a correct feature can still violate a repository
constraint.

For every finding, include:

- priority and the affected file and line or narrow hunk;
- the unmet source requirement or standard, when applicable;
- a concrete failure scenario or reason the behaviour is unsafe; and
- the smallest credible fix or missing verification.

End with the number of findings on each axis, the verification evidence
reviewed, coverage evidence (including any new-code/diff and overall figures),
and any limitation such as an unavailable coverage command, full test suite,
or requirements source. If nothing meets the threshold, say that no actionable
findings were identified; do not claim the change is defect-free.

When this review follows `$engineering-implement`, return in-scope fixes to
that implementation step. After repairs, rerun the affected verification and
repository-required full checks for the repaired revision, and repeat this
review against the same fixed point across the complete ticket diff.
Escalate a finding that requires a new product or design decision to
`$engineering-decision-discovery` or
`$engineering-specification` instead of solving it in the diff.
