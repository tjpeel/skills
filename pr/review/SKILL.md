---
name: pr-review
description: Review a colleague's pull request with focused mapping and validation, then report only actionable correctness, regression, security, or test findings.
---

# Review pull request

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with repository and GitHub access. Follow all applicable
repository instructions: this normally includes `AGENTS.md` in Codex and
`CLAUDE.md` in Claude Code. Keep the review read-only in every platform; do not
use a platform's PR-comment or approval control unless the user separately
asks.
When a source skill is named with `$`, invoke it where supported; otherwise
read that source skill's `SKILL.md` and apply its guidance directly.

## Delegation profiles

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

Use this workflow when asked to review a pull request, branch diff, or colleague's proposed change. It is a review-only workflow.

Name one independent owner for the complete diff, covering technical risks,
selected intent and test quality. A fresh reviewer session, including one from
another provider, can own the review directly when its reasoning capability
is sufficient. If the coordinator implemented the change, use a fresh
reviewer. Do not add a reviewer solely to duplicate an already independent
owner.

Use `read_high` or an equivalent high-effort reviewer for substantive code
review. A clear, bounded change with understood runtime effects may be
reviewed directly at medium effort. Diff size alone does not justify lower
effort or extra agents. Use `read_deep` for a selected review or unresolved
question involving difficult interacting contracts, destructive data effects,
authentication or secret boundaries, migrations, concurrency or cross-service
recovery. Material risk warrants scrutiny, but does not automatically require
maximum effort or a second complete review.

Use `read_low` only for a missing behaviour or ownership map, and `read_medium`
only for a specific uncertainty in selected intent, verification or coverage.
These helpers return evidence and contradictions, not the final assessment.
Reserve `read_exceptional` or another senior reviewer for an unresolved
material dispute with a complete evidence packet. All delegates remain
read-only and inside the selected input boundary. The coordinator owns scope,
user questions and the final report.

## Inputs

Establish the pull request or branch, base branch, stated intent or ticket, and any known test results. If the base is unknown, identify it before judging the diff.

Pin the base and head commits and review their complete combined diff, including
configuration, comments and tests. Do not review only the last corrective commit
or treat a sequence of fixes as proof that the final behaviour is sound. Record
any working-tree changes separately; they are not part of the published PR.

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

These local artifacts are uncommitted process inputs, not ongoing
documentation. They supplement the review; their absence, unselected path or
broken links do not block it. State the requirements limitation and use the PR's
stated intent, code, tests and repository contracts for the available assessment.
Do not require private planning artifacts to be committed or shared. Findings
must be understandable from the code, public contract or supplied PR context;
do not expose private artifact contents in external comments.

## Workflow

1. Read applicable repository instructions, coding standards, service contracts and required check commands. Trace changed code from entry points through runtime wiring, side effects and recovery before relying on the author's explanation or planning artifacts.
2. Have the selected owner evaluate the complete diff at the chosen effort. Its initial packet contains raw code, tests, runtime wiring, repository standards and any behaviour map, excluding planning artifacts, requirements mappings and the author's explanation. Optional helpers address only the identified evidence gaps.
3. Then supply selected intent and coverage evidence to reconcile the owner's technical conclusions. The owner checks all review axes and reports only correctness, regression, security, compatibility, concurrency, or missing-test risks.
4. Escalate an unresolved material question using the delegation rules above. Reuse the pinned evidence and existing reviewers; retain one owner responsible for the complete final assessment.

Derive the technical checks from the changed paths and surrounding system:
identify affected actors, inputs, state changes, effects, contracts and
invariants, then walk concrete boundary and failure scenarios. Check which
conditions permit effects and how incomplete work is resolved. Investigate
interacting limits, adapted reference code and partial capabilities where they
create a credible failure path. Check comments against executable behaviour.
If a domain outcome remains uncertain, research it or ask a targeted question
while reviewing unaffected paths; do not invent policy or present that
uncertainty as a verified defect.

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

For each finding, include priority, file and line, a concrete failure scenario, and the recommended fix or test. Do not edit the pull request, comment externally, or include style-only nits. If no finding meets the threshold, say so clearly and mention any remaining test limitation.

## Cost control

Do not add agents for role completeness or repeat a complete review because a
bounded question needs more reasoning. Keep helper model and effort settings
explicit when the owner uses maximum reasoning. Reuse relevant mapping and
verification evidence, and wait for required helpers before returning the
assessment. When comparing routing costs, record agent count, elapsed time,
repeated investigations, findings and reported usage; leave missing measures
unknown and do not claim savings from unlike reviews.
