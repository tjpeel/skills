# Pull-request skills

| Skill | Overview |
| --- | --- |
| [`dependabot-approve-merge`](dependabot-approve-merge/SKILL.md) | Ranks, approves, merges, and monitors eligible Dependabot pull requests one at a time. |
| [`draft`](draft/SKILL.md) | Drafts an evidence-based pull-request title and description from implementation, tests, and optional ticket context. |
| [`manage`](manage/SKILL.md) | Safely inspects, pushes, creates, and updates GitHub pull requests using local Git and the GitHub CLI. |
| [`monitor`](monitor/SKILL.md) | Follows checks for the published PR head and completes only explicitly authorised repairs and publication. |
| [`replicate`](replicate/SKILL.md) | Recreates the intended outcome of a source GitHub pull request in the current destination repository. |
| [`review`](review/SKILL.md) | Reviews a colleague's pull request and reports actionable correctness, regression, security, or test risks. |

Use `$pr-monitor` when the request includes following an ordinary PR's checks
to completion. It keeps local validation, publication and final check results
distinct, and refreshes evidence after each new head. Monitoring alone is
read-only; a repair-and-publish loop needs that authority in the request.
Dependabot queue processing keeps its separate merge policy and no-repair
boundary.
