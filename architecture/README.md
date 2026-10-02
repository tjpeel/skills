# Architecture skills

| Skill | Overview |
| --- | --- |
| [`adrs`](adrs/SKILL.md) | Recovers evidence-backed, retrospective architecture decision records from current code, Git history, and pull requests. |

## Using the workflow

Use `$architecture-adrs` when an implemented choice needs its history and
rationale recovered. Supply the selected repository, decision area or code
anchor, available Git and PR history, and the requested output scope. Use the
repository's ADR location and format, or select a destination when there is
no established convention.

Prompts use source names. In Codex, use the prefixed installed name; in
Claude Code, use the source name. See [invocation guidance](../docs/installation.md#invoke-a-skill)
or ask the agent to read the selected `SKILL.md` directly.

For a bounded decision seam:

```text
Use $architecture-adrs to recover the retained decision behind this
integration's status mapping in the selected repository. Trace its callers,
tests and Git/PR history. Draft an ADR only if the evidence supports durable
rationale or constraints, and distinguish explicit rationale from inference.
Follow the repository's ADR convention.
```

For broader recovery:

```text
Use $architecture-adrs on this repository's current architecture and history.
Identify decisions still material to operating or changing the system.
Return evidence-backed ADRs, historical coverage and confidence gaps;
exclude mechanical or superseded changes with reasons.
```

The workflow combines a history index with current-code decision seams,
investigates credible candidates, then checks the proposed records against
the evidence. It preserves product code. The handoff includes supported ADRs,
coverage, excluded candidates and unresolved facts; limited access limits
the coverage claim. Finding no supported ADR is a valid result.

Use [engineering decision discovery](../engineering/README.md#using-the-workflow)
for a future choice, or architecture survey to find refactoring opportunities.
ADR recovery is a separately requested documentation task; implementation
does not create ADRs by default. Use the
[productivity handoff](../productivity/README.md#using-the-workflow) if another
session must continue from selected evidence and drafts. Publication, commits
and other external actions follow the request and repository instructions.
