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

## Workflow

1. Inspect the diff in the context of the changed code and tests.
2. For a non-trivial review, run `read_low` and `read_medium` in parallel: one maps behavior and ownership; the other checks stated intent and test coverage.
3. Ask `read_high` to evaluate the diff and their evidence. It should report only correctness, regression, security, compatibility, concurrency, or missing-test risks.
4. Use a separate `read_high` handoff only when a finding concerns a plausible high-impact security, data-loss, migration, concurrency, or cross-service failure.

## Findings format

For each finding, include priority, file and line, a concrete failure scenario, and the recommended fix or test. Do not edit the pull request, comment externally, or include style-only nits. If no finding meets the threshold, say so clearly and mention any remaining test limitation.

## Cost control

Do not delegate a one-file obvious review. Do not use a second `read_high` handoff for low-impact or speculative concerns.
