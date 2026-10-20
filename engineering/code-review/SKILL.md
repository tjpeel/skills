---
name: engineering-code-review
description: Review a local change against approved intent and repository standards for actionable technical risks and design or scope recommendations. Use after implementation or for another local change; no implementation or external PR review.
---

# Engineering code review

Review a local diff independently of its implementation on two axes:

- **Requirements:** does the change deliver the approved ticket or
  specification without unsupported scope?
- **Standards and risk:** does the change respect documented repository
  conventions and avoid actionable correctness, regression, security,
  compatibility, concurrency, or test risks?

Use after `$engineering-implement` completes focused verification, or for
another local change. This skill does not edit, commit, push, publish comments
or approve pull requests. Use `$pr-review` for a colleague’s pull request.

Code documents implemented functionality. Specifications and local tickets
are uncommitted process inputs; do not require them to be committed, refreshed or
maintained after delivery. Missing ADRs, context files or guides alone are
not defects. Request docs only for an explicit requirement or material
knowledge gap code cannot convey. Report misleading claims or broken
signposts in relevant docs when they could cause a concrete future error.
Prefer removing duplicate explanations or linking to code over extending them.

## Platform compatibility

Use this workflow in Codex, Claude Code, or another environment with
equivalent repository and command access. Follow applicable repository
instructions, including `AGENTS.md` in Codex and `CLAUDE.md` in Claude Code.
Invoke `$` source-skill references where supported; otherwise read the
referenced `SKILL.md` and apply it directly.

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

Review from the complete source tree at the recorded head, with the fixed
point available, rather than from a diff alone. Include pending changes when
those are part of the declared boundary. If full source is unavailable, name
the missing paths and conclusions that cannot be established.

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
the change, use a fresh reviewer unless the controller explicitly reserves that
independent stage for later and requests self-review now. In that mode, keep the
same inspection checks, disclose self-review, and do not launch a duplicate
whole-change reviewer or claim independence. Keep requirements and technical conclusions
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

## Repeated review with retained evidence

Keep the original base and selected requirements as the review fixed point.
When a controller supplies a verified prior inspection, exact reviewed and current
revisions, a complete correction manifest and inherited coverage with provenance,
review the correction and its affected behaviour instead of rereading unchanged
bodies. Inspect callers, consumers, tests, configuration and documentation whose
meaning may have changed; unchanged bytes alone do not establish independence.
Include deleted, renamed and reverted paths even when absent from the final PR
manifest. Reopen any inherited inspection affected by the correction.

Give every earlier finding and recommendation an evidence-backed disposition.
Confirm that the affected behaviour is covered before completing a cumulative
review. Preserve original reports and identify inherited versus newly inspected
coverage; do not claim a fresh full inspection of inherited bodies. If baseline
identity, objects, scope or coverage cannot be verified, or impact cannot be
bounded, revoke inheritance and complete a full review. Do not search past a
newer unfinished review to bypass its gaps. Keep current-revision verification
requirements and an independent owner.

Use helpers for named unresolved questions and explicit path ownership. Reuse
completed mapping and substantive inspection from the owner or a helper; inspect
source again to settle a new uncertainty, not merely to reproduce another
reviewer's work. Return concise source evidence and remaining uncertainty rather
than bulk inventories or transcripts. Delegation isolates context but is not
free work.

## Review the change

Inspect every changed file, including tests, documentation and configuration.
Read relevant test setup and assertions rather than relying on names or passing
results. After repairs, preserve the original fixed point; a verified cumulative review may inspect the correction and affected behaviour without rereading inherited coverage. Without such a baseline, review the full change, not only the
last corrective commit.

For new or changed fields, indexes, filters, endpoints, links, configuration,
messages and behavioural claims, trace production sources, consumers and
prerequisites. Group shared paths without hiding exceptions. Establish current
caller outcomes, investigating unwritten or unread values, empty or constant
results and unreachable paths. A producer claim needs a production write
location or established external source; declarations, projections, indexes
and fixtures are insufficient. Existing data or external producers may justify
a path, but a deferred label or hypothetical source does not establish use.
If no writer is found, record the production paths searched and close the
question: establish a current source, report a material unresolved prerequisite,
or recommend a scope decision with the cost of shipping the dependent surface.
Absence of an in-repository writer does not prove retained data is empty.
For deferred capabilities, identify current storage, migration, API and
operational costs and their present purpose.

First trace the actual behaviour from public entry points through effects,
failure handling and recovery using code, tests and applicable configuration.
Identify the actors, inputs, state changes, contracts and invariants affected
by the diff. Derive concrete boundary and failure scenarios from those paths
and the surrounding system. Check who can act, which conditions permit effects,
what happens when an operation is incomplete, and how the next action follows.
Investigate interacting limits or imported assumptions when they create a
credible failure scenario. Compare comments and docs with executable behaviour.

Do not treat the implementer’s narrative or planning artifacts as proof of
correctness. Resolve uncertain domain outcomes from repository evidence or
a targeted question while reviewing unaffected paths. Distinguish technical
defects from requirements questions; do not invent policy.

Challenge the assumptions that make the change useful and trustworthy. Look
for behaviour that can appear successful while failing the user's intent, rules
represented in several places that can drift, and complexity or scope without
a demonstrated current purpose. Follow concrete user and failure paths rather
than treating specification compliance or passing tests as sufficient evidence.
Report the observable consequence and smallest justified improvement;
distinguish defects from recommendations that require a scope decision. Do not
silently remove contracted behaviour or treat a preference as a defect.

Compare completion and reported outcomes on timeout, cancellation and failure
paths: can completed work be discarded or partial effects reported as total
failure, and what happens on retry? Respect an explicit deadline contract.
Compare shared states, classifications, mappings and links across their producers
and consumers. Report repeated rules or magic values when they create a concrete
drift risk, especially a silent fallback. Compare related branches for inconsistent
caller-visible recovery and diagnostic behaviour.

Then check requirements. Compare each in-scope required behaviour, accepted
decision, observable acceptance criterion, and applicable rollout or change
constraint with the diff and its verification. Report missing, partial, or
apparently incorrect behaviour; scope that the source did not ask for; and
tests that do not actually observe the intended behaviour.

Check factual claims in selected intent and changed documentation against code
and verification evidence. Distinguish unsupported claims from externally
unverified facts. Agreement between code and specification does not establish
that a capability has a useful current path.

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

In controller-managed implementation self-review, keep inspection evidence and
non-blocking design or scope recommendations in the summary. If the controller
reserves structured review fields for its independent reviewer, leave
`recommendations` empty and `review_coverage` null. Self-review does not change the
implementation role; do not return independent-review statuses or claim approval.
Report actual blockers through the implementation's supported status and fields.

## Evidence of completed inspection

Retain a compact inspection record in the final report, not just a statement
that the full diff was reviewed. Include:

- producer/consumer rows with source and consumer file locations, current caller
  outcome, and any unresolved prerequisite; state explicitly when a source was
  not found and distinguish searched production code from test fixtures;
- changed-file coverage, grouping related files when useful, with the behaviour
  and test assertions inspected and any paths left unread or only skimmed;
- relevant unchanged dependencies traced when a changed claim or recovery action
  relies on them; being outside the diff does not establish their behaviour;
- the disposition of earlier findings and recommendations supplied in the review
  history: retained, resolved by an identified change, or withdrawn with evidence.

Keep this record in the final report, not command transcripts or a new
repository document. For JSON without dedicated fields, use the summary.
A no-findings result still requires the record.

Do not claim full inspection while material test assertions, prerequisites or
supporting paths remain unexamined. If relevant content was only skimmed, finish
that inspection or name the bounded unfinished work. With a controller supporting
review_incomplete, return that status with partial coverage and named gaps so the
same session can continue. Reserve limitations for genuine unavailable evidence;
not running isolated controller checks again is not itself an inspection gap.

## Completion and reporting

Before returning, confirm the original fixed point, reviewed content,
producer/consumer trace, every changed file including tests and docs, and both
assessment axes. Finish accessible omissions; report genuine access or
evidence blockers and their uninspected scope. Passing checks and familiarity
with the implementation do not replace review.

Keep two output tiers within the assessment axes below:

- **Defects and verification risks:** use the finding fields below for actionable
  correctness, regression, security, compatibility, concurrency and test risks.
- **Design and scope recommendations:** give file and line, concrete user,
  maintenance or drift cost, and the suggested change for premature capability,
  duplicated rules, inconsistent behaviour or unrelated scope. These do not
  authorise changing approved contracts. Exclude formatting and naming preferences.

Make either tier explicitly empty when appropriate. With controller-supplied
structured output, use its findings and recommendations fields rather than
turning a scope recommendation into an automatic repair.

## Report and return repairs to implementation

Report findings under separate `## Requirements` and `## Standards and risk`
headings; neither assessment substitutes for the other.

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
