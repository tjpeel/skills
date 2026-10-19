---
name: pr-replicate
description: "Reproduce a GitHub pull request's intended changes in the current destination repository. Use when a source PR is the guide, not a patch to apply verbatim."
---

# PR Replication

## Platform compatibility

Use this workflow in Codex, Claude Code or another environment with
repository, GitHub and command access. Follow applicable repository
instructions, including `AGENTS.md` or `CLAUDE.md`. Invoke `$` source skills
where supported; otherwise read and apply their `SKILL.md`.

## Delegation profiles

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

Reproduce the source PR’s *intent and observable behavior* in the invoking
repository. Adapt to destination structures, conventions, APIs and history;
use the source as evidence, never a mechanical transplant.

The source repository is read-only. Edit only the invoking destination project.
Do not create commits, push branches, or open/update a pull request unless the
user explicitly requests that separate action.

## Establish the basis

1. Confirm the input is a specific GitHub PR and the current project is a Git
   repository. Record the source PR URL, its base and head commit IDs, and the
   destination branch/commit and working-tree state before editing. Use the
   captured source head throughout the task; if it changes, disclose that and
   refresh the analysis before implementation.
2. Read the source PR's changed files, commits, relevant discussion/context,
   and tests. Inspect enough source code at both the PR base and head to
   understand the behavior, rather than relying only on a rendered diff.
3. Read destination instructions and the surrounding destination code,
   contracts, test setup, and conventions. Preserve unrelated local edits.
4. Produce a source-to-destination mapping before making changes. Include
   every meaningful source change, its user-visible or system behavior, the
   destination counterpart, validation evidence, and an explicit reason for
   anything that is not applicable.

If source access is unavailable, ask the user for access or a supplied diff;
do not infer a PR's contents from its title. If the mapping exposes a material
product, compatibility, security, or migration choice with no safe equivalent,
present the alternatives and wait for direction.

Apply `$engineering-testing` to destination verification. Preserve the source
tests' behavioural guarantees, not their number or implementation structure.
Identify existing destination coverage before adding or adapting a test, and
record any uncovered behaviour and its independent expected result. Source
tests are evidence to assess; do not reproduce tautological, change-detector
or internal-interaction tests just because the source contains them.

## Team shape

For nontrivial changes, use this sequential team when delegation is available.
Keep one destination writer, and give every role the captured revisions and
mapping report.

- **Source-to-destination analyst — `read_low`:** Build the
  behavior inventory and mapping report, identify destination integration
  points, and flag uncertainty. This role does not edit either repository.
- **Destination implementer — `write_low`:** the sole writer. Implement the
  mapped behavior idiomatically in the destination, add or adapt tests only
  for identified coverage gaps, and report each mapping item it completed.
  It must not modify source material or overwrite unrelated destination work.
- **Equivalence reviewer — `read_high`:** Compare
  the captured source PR, mapping report, and destination diff for omissions,
  behavior drift, regressions, and unsafe assumptions.
- **Coverage and validation auditor — `read_medium`:** Check
  that the source's test intent and every mapping row have credible destination
  validation, and assess test output and known unrun checks.

Handle small, obvious changes directly in the same order. Return findings to
the same implementer, then repeat affected validation and review. Reviewers
must not edit destination files.

## Completion standard

Complete only when every source behavior is either implemented and validated
in the destination or documented as deliberately inapplicable with evidence.
Report the source revision used, the destination changes, validation commands
and results, and any residual limitations. Read
[the replication protocol](references/replication-protocol.md) before
implementation and review work.
