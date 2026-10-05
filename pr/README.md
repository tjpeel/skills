# Pull-request skills

| Skill | Overview |
| --- | --- |
| [`dependabot-approve-merge`](dependabot-approve-merge/SKILL.md) | Ranks, approves, merges, and monitors eligible Dependabot pull requests one at a time. |
| [`draft`](draft/SKILL.md) | Drafts an evidence-based pull-request title and description from implementation, tests, and optional ticket context. |
| [`manage`](manage/SKILL.md) | Safely inspects, pushes, creates, and updates GitHub pull requests using local Git and the GitHub CLI. |
| [`monitor`](monitor/SKILL.md) | Follows checks for the published PR head and completes only explicitly authorised repairs and publication. |
| [`replicate`](replicate/SKILL.md) | Recreates the intended outcome of a source GitHub pull request in the current destination repository. |
| [`review`](review/SKILL.md) | Reviews a colleague's pull request and reports actionable correctness, regression, security, or test risks. |
| [`sonar-fix`](sonar-fix/SKILL.md) | Repairs Sonar PR findings, tests, creates signed commits, pushes and repeats against fresh analyses until clean and green. |

## Using the workflow

Start with the skill for the requested action. Drafting, reviewing and
monitoring have different authority from publishing or merging.

| What you have | Start with | Supply |
| --- | --- | --- |
| A local change needing a title and description | `$pr-draft` | The branch and base, available check results, and ticket context if selected. |
| A branch to push, PR to create, or fields to edit | `$pr-manage` | The exact action, repository, branch, base and approved fields; the confirmed ticket key or selected work reference. |
| A published PR whose checks need following | `$pr-monitor` | The PR identity, requested outcomes and observation window; explicit repair/publishing scope if included. |
| A PR failing its Sonar gate or reporting new-code issues | `$pr-sonar-fix` | The PR URL and repair/push authority; optional project details, cycle limit and observation window. |
| A colleague's PR needing a correctness review | `$pr-review` | The PR or branch and base, stated intent, check evidence and any selected local inputs. |
| A source PR to reproduce in another repository | `$pr-replicate` | The source PR URL, destination checkout and alignment constraints. |
| A Dependabot queue to process | `$pr-dependabot-approve-merge` | The repository URL; explicitly request report-only mode to prevent approvals and merges. |

Prompts use source names. In either provider, use the prefixed installed name.
See [invocation guidance](../docs/installation.md#invoke-a-skill)
or ask the agent to read the selected `SKILL.md` directly.

### Draft, publish and monitor

Monitoring and repair use separate reasoning levels:

| Phase | Profile | Reasoning |
| --- | --- | --- |
| Sustained inventory, check polling and log collection | `read_low` | Low |
| Non-trivial diagnosis or a repair evidence audit | `read_medium` | Medium |
| Implementation and required local tests | `write_medium` | Medium |
| Difficult diagnosis or material security/behaviour risk | `read_high` | High |

The configured profile supplies the model. Skills report the actual model
and effort when available; they do not change the chat's selected settings.
One observer is reused across waits and receives the new revision after each
push. The coordinator retains signatures, commits and external writes.
Dependabot monitoring follows the low-reasoning observation phase but retains
its no-repair boundary. If a configured profile cannot run, the direct fallback
retains the coordinator's settings and is reported as such.

Prepare reviewable metadata from the actual diff:

```text
Use $pr-draft for the current branch against <base-branch>.
Use the supplied ticket context and current check results. Return a title
and Markdown description explaining the problem, delivered behaviour and
verification. Keep it as a draft for review.
```

Drafting returns copy-ready text and the proposed repository, branch and base.
It does not push or change a GitHub PR. After approving that text, request the
publication steps explicitly:

```text
Use $pr-manage to push the current branch and create a draft PR against
<base-branch> for work reference <reference>, using the approved title and
description. Then use
$pr-monitor to follow <requested-checks> for the published head.
```

PR management runs repository-required checks and preflight when present,
verifies the target and performs only the requested push or field writes.
The handoff gives the PR URL and published revision. For an existing PR,
name only the fields to change; a branch push updates its content without
authorising metadata edits. PR titles and descriptions retain the confirmed
ticket key or exact selected work reference; a branch may use a Git-safe
rendering. Follow applicable repository naming instructions and do not turn
local ticket sequence numbers into external tracker identities.

Monitoring binds check results to the current remote SHA and waits for the
requested terminal outcomes. A local pass or successful scanner step does
not establish a completed final analysis. For a bounded repair loop:

```text
Use $pr-monitor on <PR-URL>. Follow <requested-checks> for its current head.
Repair supported failures within this change's scope, run required checks,
commit and push those repairs, and monitor the new published revision.
Report the final check evidence or the precise blocker.
```

Monitoring alone is read-only. A requested repair-and-publish loop can continue
within that authority, while merge, force-push and other history-rewrite
actions need their own authority. For a
[selected engineering stack](../engineering/README.md#using-the-workflow),
supply the verified predecessor and intended PR base. Parent repairs make
affected descendants stale until carried through and reverified.

### Repair a Sonar gate

```text
Use $pr-sonar-fix on <PR-URL>. Fix the Sonar findings and failing gate
conditions, run the required tests, create verified signed commits and push.
Monitor each new build and Sonar analysis, repeating when it reports more
issues, until the current PR is clean and all required checks are green.
```

This request authorises each in-scope repair, signed commit and push without
per-cycle approval. The skill checks every relevant Sonar project against the
published revision and retrieves the complete outstanding PR finding list.
A passing gate alone does not establish that the PR has no further findings.
It preserves the quality policy and leaves finding dispositions to their
authorised reviewers.

The default bounds are five repair pushes and a 60-minute elapsed window;
provide different limits in the request when needed. Missing signing or
required validation, unresolved ownership, out-of-scope repairs and incomplete
analysis evidence stop the loop with a specific blocker. The handoff includes
the published SHA, signed commits, tests and final build and Sonar evidence.
For inspection only, explicitly request a read-only diagnosis.

### Review a colleague's change

```text
Use $pr-review on <PR-URL>. Review the complete pinned base-to-head diff,
runtime wiring and required-check evidence. Report only actionable findings
with a concrete failure scenario, source location and recommended fix.
```

Review returns findings and evidence limitations. It does not edit code,
post comments or approve the PR. Select local ticket or specification paths
explicitly when they should inform the review; unavailable planning files
limit the requirements assessment without preventing a code review.

### Reproduce another repository's PR

```text
Use $pr-replicate on <source-PR-URL> in this destination repository.
Map each meaningful behaviour to its destination counterpart before editing.
Adapt it to the supplied constraints and verify the destination outcomes.
```

Replication pins the source revision, keeps the source read-only and changes
only the destination. It returns the mapping, implemented behaviour,
deliberately inapplicable items and verification. Commits, pushes and PR
creation need a separate explicit request. Use `$pr-draft` and `$pr-manage`
when those delivery steps are then requested.

### Process Dependabot updates

```text
Use $pr-dependabot-approve-merge on <repository-URL>.
Process eligible green updates sequentially and monitor the default branch
between merges. Report each PR's resulting state and next action.
```

Invoking this workflow authorises its defined approvals and merges without
per-PR confirmation. It leaves Dependabot code and metadata untouched, skips
checks that are not fully green and does not repair them. Its limited recreate
comment applies only to the clean-merge failure defined by the skill. To
inspect the queue without writes:

```text
Use $pr-dependabot-approve-merge on <repository-URL> in report-only mode.
Rank the updates without approving, merging or requesting recreation.
```

The handoff records merged, skipped, awaiting-recreation or blocked PRs and
the relevant check state. A needed custom repair is a separate request.
