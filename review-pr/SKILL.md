---
name: review-pr
description: Review a colleague's pull request with focused mapping and validation, then report only actionable correctness, regression, security, or test findings.
---

# Review pull request

## Agent policy

The named roles below are custom agents registered in `~/.codex/agents/`; select
them by their exact `name`. Never use Codex built-in `default`, `worker`, or
`explorer` agents. If a suitable custom agent is unavailable, complete that
responsibility in the coordinating agent rather than substituting a built-in.

Use this workflow when asked to review a pull request, branch diff, or colleague's proposed change. It is a review-only workflow.

## Inputs

Establish the pull request or branch, base branch, stated intent or ticket, and any known test results. If the base is unknown, identify it before judging the diff.

## Workflow

1. Inspect the diff in the context of the changed code and tests.
2. For a non-trivial review, run `code_mapper` and `validation_auditor` in parallel: one maps behavior and ownership; the other checks stated intent and test coverage.
3. Ask `pr_reviewer` to evaluate the diff and their evidence. It should report only correctness, regression, security, compatibility, concurrency, or missing-test risks.
4. Use `risk_adjudicator` only when a finding concerns a plausible high-impact security, data-loss, migration, concurrency, or cross-service failure.

## Findings format

For each finding, include priority, file and line, a concrete failure scenario, and the recommended fix or test. Do not edit the pull request, comment externally, or include style-only nits. If no finding meets the threshold, say so clearly and mention any remaining test limitation.

## Cost control

Do not delegate a one-file obvious review. Do not invoke `risk_adjudicator` for low-impact or speculative concerns.
