---
name: pr-dependabot-approve-merge
description: Rank and process open Dependabot pull requests from a GitHub repository URL, automatically approving, merging, and monitoring green updates one at a time.
---

# Dependabot PR Queue

Use this skill when the user supplies a GitHub repository link and wants its open Dependabot pull requests processed. Rank the updates by value, then approve, merge, and monitor them one at a time. It is not for editing Dependabot branches, changing Dependabot configuration, or solving the underlying dependency problem in a new PR.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with the GitHub CLI and the authority to make the requested
GitHub changes. Follow all applicable repository instructions: this normally
includes `AGENTS.md` in Codex and `CLAUDE.md` in Claude Code. Use the current
platform's approval mechanism for GitHub writes; the safety boundary below
applies unchanged.

## Safety boundary

Treat Dependabot pull-request code and metadata as immutable. Never commit, push, rebase, sync, update a branch, edit a title/body/labels/reviewers, close/reopen, alter auto-merge, or otherwise modify a Dependabot PR. The only permitted PR-state actions are an approval and merge for the selected green PR, plus the exact `@dependabot recreate` comment when GitHub rejects that PR's merge because it cannot create a clean merge commit. Do not use a Dependabot PR as a vehicle for a fix; suggest a separate custom PR when needed.

Invoking this skill for a repository authorizes its sequential queue execution: approve and merge each selected PR whose current CI check rollup is entirely successful, without seeking per-PR confirmation. A **green** PR has one or more current checks and every listed check has a `SUCCESS` conclusion. Do not investigate reviews, rulesets, mergeability, branch freshness, default-branch activity, or other approval conditions. If a PR is not green, skip it and report its check state; do not diagnose or repair it. If GitHub rejects an approval or merge, report the response and do not alter the PR further, except for the clean-merge-conflict recreate comment defined in the operating procedure.

Only use report-only mode when the user explicitly says not to approve or merge. In that mode, rank the PRs but make no eligibility claim and take no external write. It must not request Dependabot recreation.

Use the GitHub CLI through the current platform's approved command-execution
mechanism, including `gh auth status` before declaring authentication
unavailable. Read repository instructions that are accessible locally before
acting. Read [the operating procedure](references/operating-procedure.md)
before investigating.

## Delegation and ownership

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

One quick deterministic read can stay with the coordinator. Use configured
`read_low` for sustained queue inventory and post-merge observation: PR
identity, dependency diff, check conclusion, impact ranking with uncertainty,
and workflow state for the resulting default-branch commit. Give the observer
the repository and selected PR or merged revision. It may read evidence only;
it must not edit local files, mutate Git state, approve, merge, comment or alter
GitHub state. Reuse one observer across bounded waits. It returns PR/commit
identities, check/run identities and URLs, meaningful changes, terminal result
or blocker; stop its assignment when that bounded question is answered.

Use `read_medium` when a candidate's dependency impact needs nontrivial
code/test interpretation, and `read_high` only for difficult questions or
material security/risk analysis. Return evidence-backed impact and uncertainty;
these assessments do not add approval conditions or permit diagnosis of a
non-green PR.

Keep all external writes with the coordinator. Re-read the selected PR's
relevant state immediately before each permitted write, including its current
check rollup before approval and merge and the clean-merge rejection before
the exact recreate comment. Process at most one green PR at a time and observe
the merged commit's runs before reassessing the queue. A failed, cancelled or
missing merged-commit run stops the queue without diagnosis or repair. This
skill has no writer phase; a separate custom PR needs separate authority.

## Completion standard

Return the ranking and a clear result for every open Dependabot PR: merged, skipped because its checks were not fully green, recreation requested after a clean-merge conflict, skipped because GitHub rejected another action, or blocked after a failed main-branch run. In report-only mode, return the ranking without an approval verdict. For a skipped, awaiting-recreation, or blocked PR, state the current check state or GitHub response and a practical next action. If a custom PR is likely necessary, propose its narrow objective and validation plan only; do not create it unless separately asked.
