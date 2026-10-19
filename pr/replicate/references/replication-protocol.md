# Replication protocol

Use this protocol when applying `$pr-replication`. It is a behavior-alignment
workflow, not a cherry-pick substitute.

## Capture and analysis

Capture stable source base and head revisions. Review the diff and unchanged
context to establish what changed and why, including repository instructions,
review comments affecting the final implementation and tests. For closed,
draft, merged or cross-repository PRs, record the final head used before
treating them as sources.

Inspect the destination independently. Find its analogous domain model,
entrypoints, configuration, integrations, feature gates, error handling, and
test conventions. Similar filenames are not evidence of a correct counterpart.

Create a mapping report with at least these fields:

| Source evidence | Intended behavior | Destination counterpart | Decision | Validation |
| --- | --- | --- | --- | --- |
| Source file, symbol, and source revision | Observable effect and constraints | Target file/symbol or subsystem | implement / adapt / not applicable, with reason | Test, check, or inspection that demonstrates the result |

Include deleted behavior. Explain each `adapt` or `not applicable` decision
through a real destination difference; neither excuses an unimplemented item.

Before implementation, use the report to inspect these common omissions when
they appear in the source PR:

- public API, CLI, UI, response, error, default, and backwards-compatibility
  behavior;
- data models, serialization, persistence, schema/migrations, cache keys, and
  generated artifacts;
- permissions, authentication, secrets, input validation, logging, telemetry,
  feature flags, retries, concurrency, and performance constraints;
- dependency, build, deployment, configuration, documentation, and test changes;
- additions, modifications, and deletions, including source test cases that
  express behavior not obvious from production code.

## Implementation

Make the smallest coherent destination change that meets the mapping report and
the destination's local conventions. Translate abstractions when necessary;
never copy source paths, imports, dependencies, configuration, or generated
output just because they occur in the source PR. Keep compatibility promises of
the destination unless the user explicitly changes them.

Keep one destination writer. Its handoff identifies changed files, completed
mapping rows, reused coverage, tests added or adapted for distinct gaps, and
assumptions. Matching line counts or unrelated passing tests do not establish
equivalence.

Run the narrowest relevant formatter, static analysis, unit/integration tests,
and build checks documented by the destination. Expand coverage when the source
change crosses interfaces or the initial checks do not exercise the mapped
behavior. If a required check cannot run, preserve its output/reason and mark
that mapping row as not fully validated.

## Independent review and audit

Give the reviewer the source PR at the captured revisions, the mapping report,
the destination diff, and validation results. The reviewer should independently
ask:

1. Does every source behavior have a credible destination row and outcome?
2. Does the destination implementation preserve the behavior, boundary cases,
   error semantics, and compatibility relevant to that row?
3. Did the adaptation accidentally introduce source-specific assumptions,
   omit a deletion, or modify destination behavior beyond the source intent?
4. Are configuration, data, security, generated-output, and dependency effects
   correctly addressed for the destination?

The validation auditor then checks the mapping report against test intent. It
should verify that new source test scenarios have destination coverage or a
recorded incompatibility reason; that checks exercise the right layer; and that
the reported command results support the claimed outcome. Existing destination
tests can supply that coverage without additions. Assess assertions against
the mapped contract rather than copying weak source tests. Distinguish
unexecuted tests from passing tests.

Resolve actionable findings with the same implementation owner. Re-run checks
affected by the fix and have an independent reviewer recheck the resolved area.
One full review-and-fix cycle is normally sufficient; repeated unresolved
findings, ambiguous product behavior, or a risky migration should be escalated
to the user with evidence instead of silently broadening the change.

## Final handoff

State the source PR URL and captured head revision, destination baseline,
implemented/adapted/inapplicable mapping decisions, files changed, and exact
validation results. Call out any unavailable source material, skipped checks,
or decisions the user may want to review. Do not commit, push, or create a
destination PR as part of replication unless separately requested.
