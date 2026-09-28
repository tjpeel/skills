# Operating procedure

## 1. Preflight and queue inventory

1. Accept a full GitHub repository URL or `OWNER/REPO`. Resolve it with `gh repo view`; report an invalid URL or inaccessible repository rather than guessing.
2. Run elevated `gh auth status` for the target host. Stop if the account cannot read the repository or approve and merge when queue execution is requested.
3. Read accessible repository instructions.
4. Treat skill invocation as **queue execution** unless the user explicitly asks for a report without approvals or merges.
5. List the open PRs and retain Dependabot-authored items. For each, collect only what is needed to rank and process it:
   - URL, number, title, author, and draft state;
   - manifest/lockfile diff, dependency old/new versions, ecosystem, and direct/transitive scope when knowable;
   - available Dependabot advisory or release evidence; and
   - the current CI check rollup, including each check's conclusion and URL.

Read PR diffs through GitHub; do not check out, modify, or run commands on a Dependabot head branch. Do not inspect review state, rulesets, mergeability, branch freshness, default-branch activity, or any other merge-policy condition.

## 2. Rank the queue

Rank every open Dependabot PR by likely value, whether or not it is green. Use this order:

1. Security updates that remediate exploitable vulnerabilities, sorted by severity and production reachability when evidence is available.
2. Direct production dependencies with material reliability, compatibility, or support impact.
3. Transitive or development-only updates, with unblocking changes ahead of routine refreshes.

Within a tier, prefer clear release/advisory evidence, a smaller compatible version jump, and less downstream disruption. Call out uncertainty rather than inventing it.

## 3. Process the queue sequentially

For the highest-ranked remaining PR, refresh only its current CI check rollup.

- If it has no checks, or any check is not `SUCCESS`, leave it untouched, record the observed state, and continue to the next-ranked PR.
- If all checks are `SUCCESS`, approve it and merge it using the repository's permitted method. Do not enable auto-merge.
- If GitHub rejects an approval, leave the PR untouched, record the exact response, and continue to the next-ranked green PR.
- If GitHub rejects a merge because it cannot create a clean merge commit, post one comment whose complete body is `@dependabot recreate`. Record the rejection and that the recreation was requested. Do not rebase, edit, or retry that PR in this run.
- For any other merge rejection, leave the PR untouched, record the exact response, and continue to the next-ranked green PR. Do not diagnose, update, or retry the PR.

After a merge, identify and monitor the workflow runs for the resulting default-branch commit. Give runs a short discovery window, then wait with bounded polling and report progress at least every minute. If any observed main-branch run fails, is cancelled, or does not appear, stop the queue and report the run URL and conclusion; do not investigate or repair it. If the runs succeed, refresh the open Dependabot list, re-rank it, and repeat from the top.

Treat a recreate request as asynchronous. Do not wait for Dependabot to complete it or retry the affected PR during this run. Continue inspecting every other PR that was pending in the current queue: if its merge is rejected for the same clean-merge reason, add the same exact recreate comment. Once all pending PRs have been inspected, report the affected PRs as awaiting Dependabot and pause queue execution; a later explicit queue request starts a fresh run.

## 4. Report

For queue execution, report:

| PR | Dependency change | Priority evidence | Final state | Next action |
| --- | --- | --- | --- |

For a report-only request, omit final state and next action related to approval/merge. Do not claim merge eligibility in report-only mode.
