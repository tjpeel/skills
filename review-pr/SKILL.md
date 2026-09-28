---
name: review-pr
description: Review a colleague's pull request with focused mapping and validation, then report only actionable correctness, regression, security, or test findings.
---

# Review pull request

## Delegation profiles

Use the least sufficient custom profile from `~/.codex/agents/`: `read_low`,
`read_medium`, `read_high`, `read_exceptional`, or `write_medium`. A profile is
an effort and access boundary, not a task role: include the precise task,
inputs, constraints, and output shape in every handoff. Never use Codex
built-in `default`, `worker`, or `explorer` agents. If a required profile is
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
