---
name: engineering-verification
description: Verify engineering outputs against real behaviour and report evidence for the actual revision. Use before declaring completion or when auditing verification; does not implement changes or replace test selection.
---

# Engineering verification

Establish whether the selected change delivers its required outcomes. Check
the actual artifact and retain enough evidence for another agent or the user
to assess the result. A completion message or green check alone does not
establish that the required behaviour was exercised.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow
applicable repository instructions, including `AGENTS.md` or `CLAUDE.md`, and
the current task's authorised scope. When this skill names another source
skill with `$`, invoke it where supported; otherwise read its `SKILL.md` and
apply the guidance directly.

Verification permits running the agreed checks in their local test or scratch
environment. Repairs, permanent tests or harnesses, commits and external
writes remain with the workflow authorised to make them. A failed check does
not authorise broader implementation or unrelated cleanup.

## Select the claim and its evidence

Use the current request and explicitly selected ticket or specification slice.
Read linked sources only when relevant to that slice. Do not discover intent
from branch names, neighbouring work folders or a delegate's summary.
Identify the required outcome, its independent expected result, and the
lowest-cost existing boundary that faithfully observes it. Apply
`$engineering-testing` when selecting or assessing tests; sufficient existing
coverage and justified verification without new tests are valid outcomes.

Match the check to the claim. Run the real command for CLI behaviour, drive
the changed user flow for UI behaviour, and read back persisted data for a
storage change. A unit test can establish isolated logic; it cannot establish
wiring or persistence it substitutes. Inspect the resulting installed or
generated artifact when that is what the user consumes. Type checks, lint,
source inspection and schemas can establish their own structural guarantees,
but do not substitute them for a required runtime outcome.

For a bug, use the triggering inputs and compare failure before the fix with
success afterwards. Distinguish an assertion that catches the defect from an
unrelated setup or import failure. For a substantial behaviour-preserving
change, establish the pre-change contract with existing coverage or a small
equivalence check before restructuring. Add performance measurement when a
performance claim or credible risk calls for it; name the metric, baseline,
method and acceptance rule. No fixed test count, live scenario count or
performance gate applies to every change.

## Identify what actually ran

Record the commit SHA and whether the checked artifact includes staged,
unstaged or untracked changes. For a dirty checkout, retain the inspected diff
or content hashes for affected files; `HEAD` alone does not identify those
bytes. Record relevant input, build or deployment identity when verification
uses something other than the checkout. A recent log or cached screenshot
does not prove which build produced it.

Run the check and inspect its result, including whether meaningful assertions
ran or were skipped. Capture the action and resulting state, along with
relevant side effects and effects that must not occur. Check readiness and
ownership before driving a running instance. Use an isolated test instance
when concurrent sessions could alter each other's results; leave the user's
active session alone unless the task explicitly selects it.

Check evidence at the point the required assertion or scenario should run.
A successful setup job or a test that returns before its assertion cannot
establish the business outcome. Report an omitted outcome as not run, or as
blocked when its prerequisite prevented execution, even if the runner reports
success. For a user flow, follow the relevant action through its resulting
state; loading the page alone does not establish that submission or
persistence obeys the contract.

Compare the environment assumptions that can trigger the reported failure
with the assumptions exercised by the check, such as a data-store setting,
validation mode or downstream response. Exercise the material difference at
an appropriate boundary, or state what remains unproven. This needs only the
relevant assumptions, not an inventory of every environment setting.

After a repair or change to relevant inputs, rerun affected verification and
the invoking workflow's required full checks. Committing the same verified
content does not by itself invalidate evidence. A changed implementation,
build, fixture or environment assumption does: reassess which checks remain
valid, rather than attaching old results to the new revision.

## Check the safety assumption when it matters

When the change affects shared code or a cross-system contract, identify the
one or two facts its safety depends on. Follow relevant consumers, pinned
dependency behaviour, lifecycle ordering or data formats far enough to check
those facts. Prefer running the real code at the relevant boundary. Label a
fact established only by inspection or inference accordingly, and name what
remains unproven. A caller inventory or empty search alone is not proof that
the change is safe. Keep this check within the selected change's credible
impact; do not produce a speculative risk catalogue.

When selected lifecycle rows govern safety, verify the relevant readiness,
permitted effects and recovery under their stated conditions. A startup pass
does not establish mixed-version compatibility or recovery after an external
effect. For an explicitly selected stack, bind evidence to the relevant
parent and child content; repaired local branches do not verify older remote
heads. Keep unexercised transitions explicit rather than extending a passing
steady-state result to them.

## Ownership and delegation

Perform a small check directly. Reuse the invoking workflow's mapper or
reviewer rather than spawning another agent to repeat its work. For a
non-trivial evidence audit, Codex can use the installed `read_medium` profile
to check criterion-to-result mapping, artifact identity, skipped checks and
unproven assumptions. Use `read_high` only when material security, data-loss,
migration or concurrency risk needs independent judgement. In Claude Code,
use an equivalently bounded configured subagent when available. If equivalent
delegation is unavailable, perform the audit directly and disclose that it
was not independent.

Give an auditor the selected sources, revision and diff boundary, raw results,
commands and required outcomes. It returns evidence gaps and contradictions;
it does not repair code, change expectations or approve delivery. The
coordinator owns the final assessment and any user questions. Do not accept
an implementation delegate's self-report without inspecting the relevant
artifact and results.

## Evidence and handoff

Keep the handoff in the conversation or the invoking workflow's existing
handoff. For each required outcome, state the checked revision or artifact,
command or action, expected and observed result, and status:

- **passed**: the relevant check ran and observed the required result;
- **failed**: the check observed a wrong result;
- **blocked**: an environment or prerequisite prevented the required check; or
- **not run**: the check was omitted, with its reason.

Report any unverified criteria and the remaining risk. A narrower passing
check does not convert a blocked required integration check into a pass.
Identify the verifier and any independence limitation. Describe only what
the evidence establishes; do not claim complete verification while a required
outcome is failed, blocked or not run.

No report file or maintained feature map is required. If evidence needs files,
use the invoking workflow's explicitly selected destination and ownership
rules. Otherwise create a fresh system temporary directory with
`mktemp -d "${TMPDIR:-/tmp}/engineering-verification.XXXXXX"`, keeping evidence
under `evidence/` and disposable state under `run/`. This skill owns only that
new directory and processes it starts; never reuse or overwrite another run.
Clean up owned processes and disposable state, retain evidence through the
handoff, and report its location. Do not kill by process name or remove the
evidence during teardown. Do not create, stage or commit repository artifacts
without a destination and write scope authorised by the invoking task.

When a skill change alters agent workflow behaviour, an occasional evaluation
can test whether the instructions affect the agent's actions. Read
[the behavioural evaluation cases](references/evaluation-cases.md) when that
evaluation is selected. It is separate from ordinary task verification and
does not require a new runner or an evaluation on every change.
