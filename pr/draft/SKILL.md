---
name: pr-draft
description: Draft an evidence-based pull-request title and Markdown description from a repository's implementation, tests, and optionally a Jira ticket. Use when asked to prepare PR metadata, summarise what was identified and changed, or turn a ticket and local diff into a review-ready PR brief. This skill only drafts content; use github-pr-management for pushing, creating, or editing a GitHub PR.
---

# Draft PR Description

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with repository and GitHub read access. Follow all applicable
repository instructions: this normally includes `AGENTS.md` in Codex and
`CLAUDE.md` in Claude Code. When a source skill is named with `$`, invoke it
where supported; otherwise read that source skill's `SKILL.md` and apply its
workflow directly.

## Delegation profiles

If delegation materially helps, select the least sufficient delegated
capability available in the current platform. In Codex, use the installed
custom profiles `read_low`, `read_medium`, `read_high`, `read_exceptional`, or
`write_medium`; do not substitute a Codex built-in role. In Claude Code, use an
equivalently bounded subagent only when subagents are available. A profile or
subagent is an effort and access boundary, not a task role: include the precise
task, inputs, constraints, and output shape in every handoff. If the equivalent
is unavailable, perform that bounded responsibility in the coordinating agent.

Create an accurate PR brief from repository evidence. Never create, edit, or push a PR.

## Gather context

1. Read applicable `AGENTS.md` and `CLAUDE.md` files before inspecting the repository.
2. Identify a ticket key from the request, branch name, commits, or supplied link. If a key is available and the `jira-ticket-context` skill is installed, read and follow that skill to retrieve the ticket. Treat Jira as read-only.
   - Use the ticket's stated problem, acceptance criteria, dependencies, and rollout requirements.
   - If Jira access fails, say so plainly. Do not invent ticket context; ask whether to continue with a repository-only draft.
   - If no key is available, state that the draft is repository-only.
3. Inspect the branch, merge base, commits, staged and unstaged changes. Establish the exact implementation scope from code, configuration, migrations, documentation, and tests; do not rely on the ticket alone.
4. Inspect test changes and available test or build output. Distinguish the test approach from verification results. Never claim a command passed unless its result is available in the current task.

## Write the draft

Return a concise, copy-ready title and Markdown description.

- Use `<TICKET>: <concise outcome>` as the title when a ticket key is known; otherwise use a concise outcome title.
- Explain the problem using ticket facts and evidence from the repository. Clearly mark measurements, assumptions, or unknowns.
- Describe implementation changes by purpose and outcome, not as a file-by-file diff.
- Include schema, data, configuration, migration, deployment, compatibility, and rollback implications when they exist. Explicitly say when none were identified.
- Summarise the testing approach: important scenarios covered by new or changed tests and the behaviour each protects.
- Add a separate verification section with executed commands and their results. If tests have not run, say `Not run` rather than implying they passed.
- Identify deliberately excluded scope, follow-up work, or unresolved risks.

Use this structure unless the repository provides a required PR template:

```md
## What

## Why

## Implementation

## Testing approach

## Verification

## Data and rollout

## Scope and follow-up
```

## Handoff

Present the proposed repository, branch, base branch when known, title, and description. For a push, draft PR creation, or PR metadata edit, hand off to `github-pr-management`; those external writes require an explicit user request.
