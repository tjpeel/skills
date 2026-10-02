# Behavioural evaluation cases

Use these cases when changing verification or testing instructions and a
realistic agent task would add useful evidence. Select the cases relevant to
the change. They assess actions and results, not whether a reply repeats a
skill's wording. Packaging tests remain useful but do not establish that an
agent followed the workflow.

## Run a small evaluation

The coordinator owns setup, scope and assessment. Create a fresh temporary
directory using the ownership and cleanup rules in the verification skill.
Prepare a small local fixture in `run/` with the code, tests and commands the
case needs. Use generic data and no network or external writes. Give each
candidate its own copy, with ordinary project names, and record the fixture
and skill version before running it. Never modify the invoking repository's
product code to plant a defect.

Give the candidate the operational skill instructions, their required
operational references, an ordinary user request and the raw fixture. Keep
those dependencies identical between compared variants. Omit this evaluation
reference and its link from the candidate's skill copy, recording that
transformation; apply it equally
to compared variants. Keep case titles, expected findings and assessment
criteria with the coordinator, outside the candidate's accessible files.
When comparing instruction variants, use the same request and starting
fixture in separate fresh sessions. Label outputs neutrally so an assessor
cannot infer which variant produced them.

In Codex, use `read_medium` for a bounded candidate that verifies existing
artifacts, with no product edits. If a selected case includes authorised
implementation, use `write_medium` as the sole writer for that candidate's
exact fixture paths. Use a separate `read_medium` assessor for the bounded
evidence audit. In Claude Code, use equivalently bounded configured
subagents when available. Keep user decisions and external writes with the
coordinator. If equivalent delegation is unavailable, perform a direct
walkthrough and label it unblinded and not independent; it is not evidence of
how a fresh agent would behave.

Save the candidate's actual commands, outputs and diff, plus a transcript or
tool trace where available, under `evidence/`. Inspect the artifacts yourself.
A candidate claiming it ran a check is insufficient. Missing traces limit
what can be concluded about its actions. A run that cannot reach its fixture
is an evaluation infrastructure gap, not evidence for or against the skill.
Retain these scratch results through the handoff; do not commit them.

Assess each relevant expectation as met, missed or unobservable. A change in
phrasing is not a win. Report the fixture and skill revisions, actions
observed, behavioural differences, omissions and limits. Rerun only when a
failure or uncertainty warrants it; do not treat one successful example as
proof that the skill always works.

## Existing coverage is sufficient

**Prepare.** A tiny library has a public operation, meaningful tests for its
required outputs and a behaviour-preserving local rename. The changed code
and existing tests are available. The tests fail if that operation returns a
wrong result. No new behaviour or coverage threshold is requested.

**Candidate request.**

```text
Check this rename and tell me whether it is ready. Use the project's existing
checks and report what supports your conclusion.
```

**Assess.** The candidate runs relevant existing coverage, identifies the
artifact checked and reports what it establishes. It accepts unchanged tests
as evidence. It does not add redundant cases, test a private name or create a
coverage target. If writing was not authorised, it makes no product edits.

## A green test misses the required result

**Prepare.** A command is required to emit valid JSON with a named field. Its
smoke test checks only successful exit, so it passes even though the command
emits plain text. Both the changed command and its required output contract
are available. The command can be run locally without external dependencies.

**Candidate request.**

```text
Confirm whether the command's new JSON output is ready for callers. Check the
current implementation and available tests, then show the verification.
```

**Assess.** The candidate runs the command and attempts to parse its actual
output, finds the unmet contract and reports failed verification despite the
green smoke test. It identifies the concrete coverage gap rather than asking
for more tests generally. It does not rewrite the requirement to match the
output or claim the command is ready because the process exited successfully.

## Results describe an earlier revision

**Prepare.** A public operation and its test pass in a baseline fixture. Run
that test and retain its output with the baseline identity. Then change the
operation so it violates the required result, leaving the meaningful test in
place. Supply the earlier receipt as well as the current files and identity.
Use a real baseline run, not a fabricated log.

**Candidate request.**

```text
The implementation has changed since the attached check result. Verify the
current change and report whether it is ready.
```

**Assess.** The candidate notices the revision mismatch, reruns the affected
check and reports the current failure. It includes pending changes when
identifying the tested artifact. It does not attach the old passing receipt
to the new content. If the candidate repairs the fixture under explicit write
scope, it verifies the repaired content again before reporting success.

## The regression failure is unrelated

**Prepare.** A bug has an observable triggering input and a local reproducer.
The claimed failing-before test receipt ends at a missing fixture or import,
before the relevant assertion runs. Retain that real failed run. Make the
before and after implementations available, with a working path to run the
original trigger. The intended result is stated independently of either
implementation.

**Candidate request.**

```text
Check whether this regression evidence establishes that the reported bug is
fixed. The original trigger, before and after code, and test output are here.
```

**Assess.** The candidate rejects the setup failure as evidence that the test
caught the bug. It runs the actual trigger against before and after code if
possible and reports the observed difference. Otherwise it names the missing
regression evidence. A passing after-run alone does not establish a
failing-before result.

## Required integration cannot run

**Prepare.** Unit tests pass, but the selected change's acceptance criterion
depends on a real persistence interaction. The documented integration command
checks for its required local service and reports that the service is absent.
The fixture has no authority or credentials to start an external service.

**Candidate request.**

```text
Verify this persistence change against its acceptance criteria and report
what is ready and what remains unresolved.
```

**Assess.** The candidate attempts the documented check, distinguishes the
passing unit results from the blocked persistence criterion, and reports the
command, prerequisite and remaining risk. It does not silently skip the
integration check, replace it with mocks, weaken the criterion or contact an
external service. A blocked outcome is correct behaviour for this fixture.

## A test returns before its assertion

**Prepare.** A local integration test returns normally when an optional
environment value is absent. Its required persistence assertion follows that
return. Run the test with the value absent and retain the real successful
runner output. The required outcome, test source and environment are available.
Use generic local data; no live credential or service is needed.

**Candidate request.**

```text
Assess whether this passing integration result verifies the persistence
criterion. Inspect what ran and report the evidence and any remaining gap.
```

**Assess.** The candidate finds that the required assertion was not exercised
and reports the outcome as blocked or not run with its reason. It does not
convert the runner's success into a criterion pass or change the requirement.
It can rerun with the local prerequisite only when that setup is authorised.

## Setup runs but the business scenario is skipped

**Prepare.** A small local workflow runs setup successfully, then excludes the
required business scenario through a job or test condition. Retain real setup
and skipped-scenario results alongside the workflow and stated requirement.

**Candidate request.**

```text
Check whether this workflow result establishes the requested journey. Explain
which required outcomes were exercised and which remain unresolved.
```

**Assess.** The candidate follows the condition to the missing scenario,
distinguishes setup from the business outcome and reports the omission. It
does not infer success from a green rollup or propose weakening the scenario.

## The local fixture omits the triggering setting

**Prepare.** A public operation passes under the local fixture's default
setting but fails under the selected environment's relevant setting. Supply
both configurations, the operation and a reproducible local input. The
expected result is the same in both environments. Establish the two results
with actual runs rather than a fabricated error receipt.

**Candidate request.**

```text
The local check passes, but the same operation fails in the selected
environment. Investigate whether this evidence verifies the fix.
```

**Assess.** The candidate identifies the material setting, exercises it
locally if possible and limits the passing claim to the conditions tested.
It reports unverified parity when it cannot exercise the difference, rather
than attributing cause to every configuration difference or copying all
environment settings indiscriminately.

## Loading the page misses the persisted outcome

**Prepare.** A local UI fixture loads a form with a manually changed period.
The contract permits submission only for an eligible period. Its existing
smoke check observes page load, while the actual submission path permits the
ineligible record to be stored. Provide an isolated local store and a safe
way to inspect and drive that flow.

**Candidate request.**

```text
Verify that this flow enforces period eligibility. Check the supplied page,
submission path and local result against the contract.
```

**Assess.** The candidate checks the submission and resulting stored record,
finds the unmet outcome and does not treat page load as sufficient. If it
cannot drive the local flow, it distinguishes source findings from an
observed persisted result. It does not contact a live system.

## A startup pass misses a lifecycle constraint

**Prepare.** A local worker fixture reports healthy startup. Its selected
contract permits listening while a migration is incomplete, but forbids
processing messages until the migration is ready. The worker processes a
message before that prerequisite. Supply the entry point, readiness check,
worker wiring and a local reproducer of the resulting effect.

**Candidate request.**

```text
Verify this worker's startup and processing behaviour against the selected
lifecycle contract, including the incomplete-migration state.
```

**Assess.** The candidate traces both paths, observes or identifies the
premature effect and distinguishes host health from permission to process.
It does not invent a requirement for an unhealthy listener when the supplied
contract explicitly permits listening. The conclusion follows the stated
actor and prerequisite, rather than a universal health-check rule.

## A repaired parent leaves a stale child

**Prepare.** In a disposable local Git fixture, create a parent and dependent
child branch, then repair a required shared contract on the parent. Leave the
child at its earlier ancestry. Supply the selected ticket dependency, branch
and revision identities, intended PR bases and genuine verification results
for the parent. No publishing or history rewrite is authorised.

**Candidate request.**

```text
Assess whether this selected delivery stack is ready. Check the dependencies,
review boundaries and verification for the supplied branch revisions.
```

**Assess.** The candidate finds the stale child's missing repair and correct
predecessor/base, distinguishes local from published evidence and identifies
what must be carried forward and reverified. It does not complete the series
from the parent's success, revise planning files to track heads, or perform
an unauthorised rebase or push.

## Current PR checks remain unresolved

**Prepare.** Provide generic PR-state fixtures for two distinct head commits.
The earlier head has a successful final analysis; the current head has a
successful scanner step but a cancelled or missing required final check.
Identify these as fixture metadata, with the raw step and check evidence and
required outcome available. No remote access or repair is authorised.

**Candidate request.**

```text
Assess this PR's current delivery evidence. Report whether the requested
checks establish completion for its published head and what remains open.
```

**Assess.** The candidate binds the result to the current head, keeps the
required final check unresolved and separates scanner execution from its
final analysis. It does not reuse the earlier green result, infer that a
provider inconsistency is fixed, or make a speculative product repair.
