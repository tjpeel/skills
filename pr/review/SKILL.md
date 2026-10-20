---
name: pr-review
description: Review a colleague's pull request with focused mapping and validation, then report actionable technical findings and evidence-backed scope recommendations.
---

# Review pull request

## Platform compatibility

Use this workflow in Codex, Claude Code or another environment with repository
and GitHub access. Follow applicable repository instructions, including
`AGENTS.md` or `CLAUDE.md`. Keep reviews read-only; PR comments and approvals
require a separate user request. Invoke `$` source skills where supported;
otherwise read and apply their `SKILL.md`.

## Delegation profiles

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

Use this read-only workflow for a PR, branch diff or colleague’s proposed
change.

Assign one independent owner the complete diff, technical risks, selected
intent and test quality. A capable fresh reviewer session, including another
provider’s, can own this directly. Use a fresh reviewer if the coordinator
implemented the change; do not duplicate an already independent owner.

Use `read_high` or an equivalent high-effort reviewer for substantive code
review. Treat changes touching more than about 20 files, or introducing
persistence, a migration or a public endpoint, as substantive. Medium effort is
appropriate only for a clearly bounded change with understood runtime effects
outside those cases. This selects the owner's effort; it does not require an
additional reviewer. Use `read_deep` for a selected review or unresolved question
involving difficult interacting contracts, destructive data effects,
authentication or secret boundaries, migrations, concurrency or cross-service
recovery. Material risk does not automatically require maximum effort.

Use `read_low` only for a missing behaviour or ownership map, and `read_medium`
only for a specific uncertainty in selected intent, verification or coverage.
These helpers return evidence and contradictions, not the final assessment.
Reserve `read_exceptional` or another senior reviewer for an unresolved
material dispute with a complete evidence packet. All delegates remain
read-only and inside the selected input boundary. The coordinator owns scope,
user questions and the final report.

## Inputs

Establish the PR or branch, base, stated intent or ticket, and known test
results. Resolve an unknown base before judging the diff.

Pin the base and head commits and review their complete combined diff, including
configuration, comments and tests. Do not review only the last corrective commit
or treat a sequence of fixes as proof that the final behaviour is sound. Record
any working-tree changes separately; they are not part of the published PR.

Review from a checkout of the pinned head commit with the base available. A
diff alone cannot establish repository-wide writers, readers or reachability.
If a checkout is impossible, review the available diff and report that access
boundary, the surrounding behaviour left unverified and its effect on findings.
Do not present a diff-only review as a complete repository investigation.

Before assigning reviewer work, confirm that the pinned commits and selected
input paths resolve, match verification evidence to the reviewed revision,
and check the available model and tool boundaries. Validate any supplied input
hashes or handoff contract. Identify stale or missing evidence as a gap; do not
treat passing CI as a correctness assessment. Supply read-only reviewers with
the diff and command results they cannot collect within their tool boundary.

## Find local intent when available

When the independent coordinating root owns the review, defer reading planning
artifacts and the author's explanation until its initial technical assessment.
Validate supplied paths beforehand, then read selected intent to reconcile
that assessment. A delegated owner receives the same staged evidence.

Use only a ticket path or specification slice explicitly supplied for this
review. New process files live beneath `.sdlc/work/<reference>/`, where the
reference is an opaque folder key, not a tracker identifier. Explicit legacy
inputs in `.tickets/` or `.specifications/` remain valid during transition.
Do not scan those directories or infer a task from a branch, PR title, recency,
or matching reference. A reference alone does not select a file.

Resolve a selected ticket's specification link from the ticket's directory
and read the target when available inside this checkout. Read other process
files only when directly linked and relevant to the slice, a named dependency,
or a deferred boundary. Do not load unselected files in the same work folder
or follow unrelated work. Check source claims against current code; surface
stale or conflicting intent. Give delegates the same selected paths and input
boundary. The ticket selects the current delivery
slice; the specification supplies contract and shared invariants. Check deferred
behaviour against the actual intermediate runtime outcome, without demanding
features explicitly assigned to later tickets.

During intent reconciliation, trace each new capability to the selected
acceptance criteria or a necessary invariant, as well as its current caller and
producer. Captured sibling context does not enlarge the selected delivery
slice. If a producer is deferred, assess the independently useful outcome now
or the agreed preparation purpose, cost and boundary. Flag spec-compliant but
unnecessary work as a scope recommendation: keeping producer and dependent
consumers in one appropriate slice may be preferable. Reconcile that
recommendation with approved intent; it is not authority to remove contracted
behaviour or demand later features in this PR.

These local artifacts are uncommitted process inputs, not ongoing
documentation. They supplement the review; their absence, unselected path or
broken links do not block it. State the requirements limitation and use the PR's
stated intent, code, tests and repository contracts for the available assessment.
Do not require private planning artifacts to be committed or shared. Findings
must be understandable from the code, public contract or supplied PR context;
do not expose private artifact contents in external comments.

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

## Workflow

1. Read applicable repository instructions, coding standards, service contracts and required check commands. Trace changed code from entry points through runtime wiring, side effects and recovery before relying on the author's explanation or planning artifacts.
2. Trace reachability at the pinned head. For each new or changed field, index, filter, endpoint, link, configuration key, message or behavioural documentation claim, search for its production sources, consumers and prerequisites. Record a compact producer/consumer table; group items sharing the same path without hiding exceptions. State what the caller can observe in the current delivery stage. Investigate apparently unwritten, unread, always-empty, constant or unreachable behaviour. Existing data and external producers can be valid sources: establish that context before reporting a missing connection. Where useful operation depends on deferred work, identify costs already incurred and whether a current use justifies them.
3. Have the selected owner evaluate the complete diff at the chosen effort, including changed tests, documentation and configuration. Read the tests' relevant assertions and setup, not only method names or passing results. Its initial packet contains raw code, tests, runtime wiring, repository standards and any behaviour map, excluding planning artifacts, requirements mappings and the author's explanation. Optional helpers address only identified evidence gaps.
4. Then supply selected intent and coverage evidence to reconcile the owner's technical conclusions. Check factual claims in the PR description and changed documentation against executable behaviour and evidence, including current scope and deferred capabilities. Distinguish unsupported claims from facts that require unavailable external verification. Report technical risks and evidence-backed design or scope recommendations separately.
5. Escalate an unresolved material question using the delegation rules above. Reuse pinned evidence and existing reviewers; retain one owner responsible for the complete final assessment.

Finish material inspection available at the pinned revision before reporting a
completed review. Passing checks, code/document agreement or a large diff do not
justify leaving relevant accessible behaviour unexamined. Complete both the
technical assessment and intent reconciliation. If access, evidence, usage or a
decision prevents completion, state that boundary and what remains uninspected;
do not present voluntary omissions as unavailable evidence. Full inspection can
still retain a genuine external-verification limitation.

Derive the technical checks from the changed paths and surrounding system:
identify affected actors, inputs, state changes, effects, contracts and
invariants, then walk concrete boundary and failure scenarios. Check which
conditions permit effects and how incomplete work is resolved. Investigate
interacting limits, adapted reference code and partial capabilities where they
create a credible failure path. Check comments against executable behaviour.
If a domain outcome remains uncertain, research it or ask a targeted question
while reviewing unaffected paths; do not invent policy or present that
uncertainty as a verified defect.

For timeout, cancellation and failure paths, compare the reported result with
work that actually completed. Check whether success can be discarded, partial
effects can be reported as total failure, and retries change the consequences.
Respect an explicit deadline contract rather than assuming every late result
must be accepted. Compare shared state and classification names across their
producers and consumers, especially where an unrecognised value silently takes
a fallback. Repeated strings matter when they create a credible drift risk.

Challenge the assumptions that make the change useful and trustworthy. Look
for behaviour that can appear successful while failing the user's intent, rules
represented in several places that can drift, and complexity or scope without
a demonstrated current purpose. Follow concrete user and failure paths rather
than treating specification compliance or passing tests as sufficient evidence.
Report the observable consequence and smallest justified improvement;
distinguish defects from recommendations that require a scope decision. Do not
silently remove contracted behaviour or treat a preference as a defect.

Assess test coverage by whether tests expose those outcomes, separately from
whether the suite passes. Inspect the required-check evidence for the pinned
head, and identify stale, partial or unavailable results. Passing tests alone
do not establish correctness, and a requirements match does not excuse a
technical defect.

Assess unnecessary test expansion as well as missing coverage: identify the
named failure a broader layer protects and why cheaper seams cannot cover it.
Report extra scenarios, fixtures or companion changes only for a concrete cost,
fragility or correctness issue. Separate running mandatory suites from creating
new scope; identify a conflicting repository rule for an upstream decision
rather than silently overriding it.

Apply `$engineering-testing` to coverage and test quality. Existing tests count
even when unchanged; request an addition only for a concrete uncovered failure
at a boundary that can reproduce it. Do not require tests for every changed
file, function or layer. Assess tautological, implementation-coupled,
change-detector and other named anti-patterns by the guarantee they miss or
concrete maintenance burden they introduce, not as style-only findings.

## Findings format

Report two tiers, making either explicitly empty when appropriate.

- **Tier 1 — defects and verification risks:** correctness, regression, security,
  compatibility, concurrency and missing-test risks. Include priority, file and
  line, a concrete failure scenario, and the smallest justified fix or test.
- **Tier 2 — design and scope recommendations:** premature or unused capability,
  duplicated rules, repeated magic values, inconsistent behaviour and unrelated
  changes. Include file and line, the concrete user, maintenance or drift cost,
  and the suggested change. These are recommendations, not permission to change
  approved requirements. Formatting and naming preferences stay out.

A specification match does not rule out a Tier 2 concern. Use the caller's
structured output categories when provided and populate its required fields;
keep recommendations distinct from defects that may enter automatic repair.
Do not edit the PR or comment externally. If neither tier contains an actionable
item, say so clearly and retain genuine review or verification limitations.

For each producer claim, identify the production write location or established
external source. A declaration, projection, index or test fixture is not a
producer. When a search finds no writer, record the production paths searched
and close the question explicitly: a current source is established, a material
prerequisite remains unresolved, or a design/scope recommendation explains the
cost of shipping the dependent surface now. A deferred label or a hypothetical
external producer is not evidence of current use. Do not infer that a missing
in-repository writer proves all retained data is empty; state that boundary.

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

Retain this inspection record even with no findings. It does not require
command transcripts or a repository document. If JSON lacks dedicated fields,
put the record in its summary rather than omitting it.

Do not claim full inspection while material test assertions, prerequisites or
supporting paths remain unexamined. If relevant content was only skimmed, finish
that inspection or name the bounded unfinished work. With a controller supporting
review_incomplete, return that status with partial coverage and named gaps so the
same session can continue. Reserve limitations for genuine unavailable evidence;
not running isolated controller checks again is not itself an inspection gap.

### File inspection accounting

Where the caller provides `review_coverage.inspection`, account for each changed
file and material supporting path. Record substantive inspection evidence, or mark
it incomplete and name the remaining work. A method inventory, selected bodies,
or passing checks cannot establish the quality of unexamined assertions, fixtures
or helpers. Inspect enough setup, controls and shared helpers to assess the
behaviour the tests claim to protect.

Reconcile prose and structured coverage. Finish accessible unread or skimmed
paths or retain them as named gaps; neither full coverage nor
external-verification limitations can hide unfinished inspection. Continue
with the same owner and pinned checkout; closing a gap needs no fresh whole-PR
review or duplicate check run.

## Completion check

Before finalising, confirm pinned revisions, producer/consumer traces, both
review phases, inspection of every changed file including tests and
documentation, and Tier 2 findings or an explicit empty result. Never
fabricate unavailable-source traces or count test names as assessment. Finish
accessible material omissions; when blocked, disclose the actual access,
evidence, usage or decision boundary and uninspected scope.

## Cost control

Do not add agents for role completeness or repeat a complete review because a
bounded question needs more reasoning. Keep helper model and effort settings
explicit when the owner uses maximum reasoning. Reuse relevant mapping and
verification evidence, and wait for required helpers before returning the
assessment. When comparing routing costs, record agent count, elapsed time,
repeated investigations, findings and reported usage; leave missing measures
unknown and do not claim savings from unlike reviews.
