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

Use the least sufficient delegated capability available in the current
platform. In Codex, use the installed custom profiles `read_low`,
`read_medium`, `read_high`, `read_exceptional`, or `write_medium`; do not
substitute a Codex built-in role. In Claude Code, use an equivalently bounded
subagent only when subagents are available. A profile or subagent is an effort
and access boundary, not a task role: include the precise task, inputs,
constraints, and output shape in every handoff. If the equivalent is
unavailable, perform that bounded responsibility in the coordinating agent.

Use this workflow when asked to review a pull request, branch diff, or colleague's proposed change. It is a review-only workflow.

## Inputs

Establish the pull request or branch, base branch, stated intent or ticket, and any known test results. If the base is unknown, identify it before judging the diff.

Pin the base and head commits and review their complete combined diff, including
configuration, comments and tests. Do not review only the last corrective commit
or treat a sequence of fixes as proof that the final behaviour is sound. Record
any working-tree changes separately; they are not part of the published PR.

## Find local intent when available

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
2. For a non-trivial review, run `read_low` and `read_medium` in parallel: one maps behaviour and ownership; the other checks the explicitly supplied intent sources and test coverage.
3. Ask `read_high` to evaluate the complete diff. Its initial packet contains raw code, runtime wiring, repository standards and the behaviour map, excluding planning artifacts, requirements mappings and the author's explanation. Then supply intent and coverage evidence to reconcile its conclusions. It should report only correctness, regression, security, compatibility, concurrency, or missing-test risks.
4. Use a separate `read_high` handoff only when a finding concerns a plausible high-impact security, data-loss, migration, concurrency, or cross-service failure.

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

Apply `$engineering-testing` to coverage and test quality. Existing tests count
even when unchanged; request an addition only for a concrete uncovered failure
at a boundary that can reproduce it. Do not require tests for every changed
file, function or layer. Assess tautological, implementation-coupled,
change-detector and other named anti-patterns by the guarantee they miss or
concrete maintenance burden they introduce, not as style-only findings.

## Findings format

For each finding, include priority, file and line, a concrete failure scenario, and the recommended fix or test. Do not edit the pull request, comment externally, or include style-only nits. If no finding meets the threshold, say so clearly and mention any remaining test limitation.

## Cost control

Do not delegate a one-file obvious review. Do not use a second `read_high` handoff for low-impact or speculative concerns.
