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

Keep all external writes with the coordinating agent. When delegation is available, use `read_low` for the inventory: PR identity, dependency diff, check conclusion, and an impact ranking with uncertainty. Use `read_high` only when the leading candidate's dependency impact needs code/test interpretation; it must return an evidence-backed risk assessment. Both profiles are read-only and must not approve, merge, comment, or alter GitHub state. The coordinator ranks the queue, processes at most one green PR at a time, and monitors main before reassessing the queue. If delegation is unavailable, the coordinator performs those read-only steps itself.

Select the least sufficient delegated capability available in the current
platform. In Codex, use the installed custom profiles `read_low`,
`read_medium`, `read_high`, `read_exceptional`, or `write_medium`; do not
substitute a Codex built-in role. In Claude Code, use an equivalently bounded
subagent only when subagents are available. A profile or subagent is an effort
and access boundary, not a task role: include the precise task, inputs,
constraints, and output shape in every handoff. If the equivalent is
unavailable, perform that bounded responsibility in the coordinating agent.

## Completion standard

Return the ranking and a clear result for every open Dependabot PR: merged, skipped because its checks were not fully green, recreation requested after a clean-merge conflict, skipped because GitHub rejected another action, or blocked after a failed main-branch run. In report-only mode, return the ranking without an approval verdict. For a skipped, awaiting-recreation, or blocked PR, state the current check state or GitHub response and a practical next action. If a custom PR is likely necessary, propose its narrow objective and validation plan only; do not create it unless separately asked.
