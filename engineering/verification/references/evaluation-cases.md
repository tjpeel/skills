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
