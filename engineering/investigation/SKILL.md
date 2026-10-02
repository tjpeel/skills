---
name: engineering-investigation
description: Investigate an observed engineering failure, regression or runtime discrepancy using selected code, configuration and measurements. Use to establish what happened and why before choosing a repair; not for surveying refactors or settling product decisions.
---

# Engineering investigation

Explain an observed problem with evidence that distinguishes its plausible
causes. Trace the system that actually ran, test the relevant assumptions and
return the smallest supported next action. A symptom, a suspicious change or
a difference between environments is a starting point, not a cause.

## Platform compatibility

Use this workflow in Codex, Claude Code or another environment with equivalent
repository, command and evidence access. Follow applicable `AGENTS.md` or
`CLAUDE.md` guidance. Invoke source skills named with `$` where supported;
otherwise read their `SKILL.md` and apply the relevant workflow directly.
Use available read-only service tools or connectors without requiring another
catalogue's setup, tracker or naming scheme.

## Establish the observed boundary

Start with the symptom, triggering action, expected result and evidence in
the current request. Identify the selected repositories, environment, time
window and before/after artifacts where applicable. Establish missing facts
from accessible sources before asking the user. If access is unavailable,
report the specific evidence gap and continue independent checks.

Record the code revision and relevant pending changes. For a running system,
identify the build or deployment, effective configuration and relevant data
that produced the observation. Keep local, pipeline and deployed evidence
distinct. A checkout, current config file or recent log does not prove the
identity of a previously running artifact.

Read applicable guidance and only explicitly selected process inputs or
their directly linked relevant sources. Do not scan work folders or infer
intent from a branch name, title or neighbouring ticket. Inspect affected
code and named integrations far enough to trace the real path: entry point,
downstream calls, state changes, failure handling and recovery. Check whether
an apparently local error is handled elsewhere in that path.

## Distinguish causes with checks

Keep a short set of plausible explanations, with evidence supporting or
contradicting each and the next check that would distinguish them. Prefer
existing logs, harnesses and observable boundaries over adding instrumentation
or inventing a new test suite. Apply `$engineering-verification` to executed
checks and `$engineering-testing` when assessing whether a regression test
would fill a concrete gap.

Compare like-for-like evidence before attributing a regression. Check the
relevant workload, fixture or data, versions, configuration, warm-up and
measurement method. Distinguish an end-to-end metric from a component metric.
An error already present in the direct control or pre-change baseline does
not establish that the selected change caused it. Name material confounders
and limit the conclusion when a comparable run cannot be obtained.

Use a representative trigger or counterexample to check the suspected
boundary. Inspect the actual resulting state, including relevant side effects
and effects that must not occur. Separate observed facts, code inspection,
inference and unresolved hypotheses. A reproduced symptom may establish a
defect while its cause remains unknown.

Investigation is read-only with respect to product code, configuration and
external state. It permits agreed checks in an owned local test or scratch
environment. A requested investigation does not authorise deploying, changing
live data or driving a state-changing live flow. If the user also authorised
a repair, carry the supported finding and its bounds into that implementation
workflow. Use `$engineering-implement` when its selected ticket or approved
slice is ready; return an unsettled behavioural choice to
`$engineering-decision-discovery`. Do not require a new design round for a
routine repair whose intent is already settled.

## Ownership and delegation

A bounded local failure can be investigated directly. A representative
non-trivial case is a regression spanning a caller, proxy, downstream service
and performance harness: independent path mapping and comparability checks
can reduce shared assumptions. In Codex, use the least sufficient installed
profile; in Claude Code, use an equivalently bounded configured subagent when
available. If unavailable, perform the responsibility directly.

- `read_low` maps one selected path, configuration boundary or evidence source.
  It returns source anchors and observations, without attributing cause.
- `read_medium` checks a bounded comparison or hypothesis against raw evidence,
  reporting confounders, contradictions and missing measurements.
- `read_high` evaluates only a material security, data-loss, migration,
  concurrency or cross-service risk, or a consequential disputed conclusion.

Give each delegate the precise question, selected sources, artifact identities
and required evidence. Do not duplicate tours of the system. Keep hypotheses,
final conclusions, user questions and any external action with the coordinator.
Delegates do not repair code or expand the investigation.

## Return the findings

Report the observed problem, artifacts and areas examined, supported findings
with source anchors, disconfirmed explanations, unresolved facts and the
smallest next action. Include expected and observed results for checks, what
each establishes, and any blocked or omitted check. Describe a proposed repair
separately from permission to implement it. Finish when the selected question
is answered or the remaining uncertainty has a named missing fact; do not
continue collecting evidence that cannot change the conclusion.

Keep the findings in the conversation by default. When scratch evidence is
needed, create a fresh system temporary directory with
`mktemp -d "${TMPDIR:-/tmp}/engineering-investigation.XXXXXX"`; use `evidence/`
for retained results and `run/` for disposable state. Own only that directory
and processes started for this investigation. Clean up owned processes and
disposable state, retain evidence through the handoff and report its path.
Do not overwrite another run or kill processes by name.

Save a report only when requested or required by repository guidance. Use an
explicitly selected destination, or `evidence/investigation.md` inside that
fresh temporary directory when none was supplied. Resolve the destination
before writing; create only an absent target, and revise an existing report
only when explicitly selected for revision. Do not create a repository work
folder, tracked report or maintained incident log by default.
