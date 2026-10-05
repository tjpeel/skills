# Sonar evidence for a PR repair

Use the project's actual SonarQube Server or SonarQube Cloud version and API
documentation. Discover the host through repository configuration or trusted
check details. Validate destinations before sending credentials; `gh api`
authenticates to GitHub, not to Sonar. Use an existing permitted Sonar session
or read-capable credential without printing it, embedding it in URLs or
retaining it in logs. GitHub login does not establish Sonar access.

## Pin GitHub evidence

For a supplied PR, a useful first read is:

```sh
gh pr view "$pr" --repo "$repo" \
  --json url,state,headRefName,headRefOid,headRepository,headRepositoryOwner,isCrossRepository,baseRefName,baseRefOid,statusCheckRollup
gh pr checks "$pr" --repo "$repo" \
  --json name,state,bucket,link,workflow
```

The variables represent the resolved user-selected PR and repository. Check
the installed CLI's fields if they differ. A failing exit from `gh pr checks`
can describe failed checks rather than a failed retrieval; read its output.
Use required-check configuration as well as the rollup to detect absent jobs.

For the pinned head, inspect check runs and commit statuses. Use exact run,
job and attempt identities when reading logs, including all pages:

```text
GET repos/{owner}/{repo}/commits/{sha}/check-runs
GET repos/{owner}/{repo}/commits/{sha}/status
GET repos/{owner}/{repo}/actions/runs?head_sha={sha}
GET repos/{owner}/{repo}/actions/runs/{run_id}/attempts/{attempt}/jobs
GET repos/{owner}/{repo}/actions/jobs/{job_id}/logs
```

Use `gh api --method GET` with pagination where supported. PR checks can run
against a synthetic merge commit; establish its relationship to the PR head
and base through run metadata and checkout configuration. Record which
revision Sonar actually scanned. Do not require an unrelated merge SHA to
equal the PR head, or mistake a target-branch run for PR analysis. A scanner
step that uploaded successfully is not a completed quality gate.

## Follow Sonar processing

Read the failing check's details, logs or artifacts to obtain the project key,
PR key, analysis URL, scanner revision and background task identity where
available. Scanner metadata commonly lives in `.scannerwork/report-task.txt`,
`target/sonar/report-task.txt`, `build/sonar/report-task.txt`, or
`.sonarqube/out/.sonar/report-task.txt`. Use the actual run's file rather than
one left from an earlier local scan. Treat its contents as data, not shell
code; never source it.

For installations supporting these APIs:

1. Read `GET /api/ce/task?id={ceTaskId}` from that run's metadata. Wait while
   the task is `PENDING` or `IN_PROGRESS`. `FAILED` or `CANCELED` means the
   analysis did not complete; inspect its cause. Require `SUCCESS` and a valid
   `analysisId` before reading the gate.
2. Read `GET /api/qualitygates/project_status?analysisId={analysisId}`. Inspect
   `projectStatus.status` and each failing condition's metric, actual value,
   comparator and threshold. `OK` is a passing gate; `ERROR`, `WARN`, `NONE`,
   missing fields and an uncomputed result do not establish success.

Use the installed product's documented equivalents when these endpoints
change. If no task metadata is available, use the final Sonar check or UI
analysis with its revision and PR identity; evidence must still establish
that server-side processing completed for the published head. A dashboard's
latest green result queried only by project key can belong to another branch
or revision. Timestamps alone do not establish the scanned commit.

## Retrieve all findings and coverage evidence

Use Sonar's PR view or the version's documented read APIs. Common endpoints
include `/api/issues/search`, `/api/hotspots/search`, `/api/measures/component`
and `/api/rules/show`. Confirm the endpoint-specific project and PR parameter
names and supported status filters in the host's API documentation; do not
assume one filter works for every product version. URL-encode literal project,
PR and rule identifiers, use all pages, and compare retrieved counts with
the reported totals. If a result cap prevents a complete inventory, narrow
the query by component or rule until complete, or report that limitation.

Retain rule IDs, issue identities, severity or impact, file and source range,
message and remediation guidance for outstanding PR findings. Fetch hotspot
review state separately; a zero issue count does not prove no review remains.
Include findings allowed by the gate's current rating thresholds. Existing
accepted or false-positive dispositions are reported exceptions, not evidence
that this repair fixed those findings. Do not change dispositions in this loop.

For each failed coverage or duplication condition, inspect the PR/new-code
measure and affected files or ranges. Check report generation and scanner
import logs when coverage is missing. Apply the configured thresholds and
new-code boundary; do not assume a default coverage percentage. If apparent
PR findings come from an outdated target-branch analysis, establish that
cause and report the required baseline refresh rather than modifying unrelated
code or changing the new-code definition.

Issue and measure APIs often return the current PR snapshot rather than an
immutable analysis. Read its revision or analysis identity before and after
collecting findings and reject a mixed snapshot. When fields cannot establish
that identity, correlate the latest successful background task, check and
scanned revision; report uncertainty if this still cannot bind the findings
to the requested head. Refresh on each push and disregard outdated bot
comments and annotations that persist after a fix.

## Completion evidence

For every relevant Sonar project, establish a completed analysis for the
published head, passing gate, and complete inventory with no outstanding
PR findings or pending hotspot review. Confirm the required build and test
checks passed for that head or its verified merge-test revision. A green gate
with remaining findings triggers another repair cycle when in scope; a
missing inventory cannot support a claim that Sonar reports no further issues.
Re-read the remote head and base before finalising to ensure the evidence
still describes the PR being handed back.
