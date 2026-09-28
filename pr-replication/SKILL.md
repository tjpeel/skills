---
name: pr-replication
description: "Reproduce a GitHub pull request's intended changes in the current destination repository. Use when a source PR is the guide, not a patch to apply verbatim."
---

# PR Replication

## Agent policy

The named roles below are custom agents registered in `~/.codex/agents/`; select
them by their exact `name`. Never use Codex built-in `default`, `worker`, or
`explorer` agents. If a suitable custom agent is unavailable, complete that
responsibility in the coordinating agent rather than substituting a built-in.

Replicate the *intent and observable behavior* of a source GitHub pull request
in the repository where this skill is invoked. The source and destination may
have different structures, conventions, APIs, and histories. The source PR is
evidence for what to achieve; it is never a mechanical transplant.

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

## Team shape

Use this sequential team when delegation is available and the change is more
than a trivial one. Keep one implementation owner so destination edits do not
overlap. Pass the captured revision IDs and the mapping report to every role.

- **Source-to-destination analyst — `code_mapper`:** read-only. Build the
  behavior inventory and mapping report, identify destination integration
  points, and flag uncertainty. This role does not edit either repository.
- **Destination implementer — `implementer`:** the sole writer. Implement the
  mapped behavior idiomatically in the destination, add or adapt tests, and
  report each mapping item it completed. It must not modify source material or
  overwrite unrelated destination work.
- **Equivalence reviewer — `pr_reviewer`:** independent and read-only. Compare
  the captured source PR, mapping report, and destination diff for omissions,
  behavior drift, regressions, and unsafe assumptions.
- **Coverage and validation auditor — `validation_auditor`:** read-only. Check
  that the source's test intent and every mapping row have credible destination
  validation, and assess test output and known unrun checks.

For a small, obvious change, perform those responsibilities directly in the
same order rather than spawning agents. If a reviewer finds an issue, return
it to the same implementer, then repeat the affected validation and review.
Do not use review agents to make destination edits.

## Completion standard

Complete only when every source behavior is either implemented and validated
in the destination or documented as deliberately inapplicable with evidence.
Report the source revision used, the destination changes, validation commands
and results, and any residual limitations. Read
[the replication protocol](references/replication-protocol.md) before
implementation and review work.
