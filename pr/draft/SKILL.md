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

Delegate only when it materially helps.

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

Create an accurate PR brief from repository evidence. Never create, edit, or push a PR.

## Gather context

1. Read applicable `AGENTS.md` and `CLAUDE.md` files before inspecting the repository.
2. Identify a ticket key from the request, branch name, commits, or supplied link. If a key is available and the `jira-ticket-context` skill is installed, read and follow that skill to retrieve the ticket. Treat Jira as read-only.
   - Use the ticket's stated problem, acceptance criteria, dependencies, and rollout requirements.
   - If Jira access fails, say so plainly. Do not invent ticket context; ask whether to continue with a repository-only draft.
   - If no key is available, state that the draft is repository-only.
3. Inspect the branch, merge base, commits, staged and unstaged changes. Establish the exact implementation scope from code, configuration, migrations, documentation, and tests; do not rely on the ticket alone.
4. Inspect test changes and available test or build output. Bind any cited result to the reviewed changes. When signing or rebasing changes commit IDs, establish whether the tested and published trees match before reusing evidence. Keep candidate hashes and that reconciliation in the handoff; never claim a command passed without its result.
5. For a selected stack, establish the actual predecessor and base before describing this PR's slice. Separate inherited work from new behaviour, local repairs from published content, and this slice from deferred capabilities. Use public behaviour and the supplied work reference in external wording; do not expose private process paths or local ticket sequence numbers as tracker identities.

## Write the draft

Return a concise, copy-ready title and Markdown description. Select content
for the reviewer of the final change: conversation history, tool/access
troubleshooting and task logistics belong in the handoff, not the description.
Preserve limitations that affect the change or interpretation of verification.
Describe the completed behaviour, using the repository's domain language. Avoid
instructions such as "correct the design sentence" and reports about the agent,
controller, orchestration, signing or review process.

- Use `<TICKET>: <concise outcome>` as the title when a ticket key is known; otherwise use a concise outcome title.
- Explain the problem using ticket facts and evidence from the repository. Clearly mark measurements, assumptions, or unknowns.
- Describe implementation changes by purpose and outcome, not as a file-by-file diff.
- Include schema, data, configuration, migration, deployment, compatibility and rollback implications only when material to this change.
- Mention new or changed regression scenarios once when they help explain the behaviour protected. Do not repeat routine CI commands, passing checks, test counts or review approvals; the PR's checks already show those results. Do not add a testing section merely to say no tests were needed.
- Use Verification for relevant evidence beyond routine CI: an observed before/after result, manual check, performance measurement or rollout-specific validation. State the outcome and any material limitation briefly. Keep a missing required check or unresolved verification gap explicit; never imply unrun checks passed.
- Identify deliberately excluded scope, follow-up work, or unresolved risks.

Follow a required repository PR template. Otherwise use only useful sections
from the structure below, merging or omitting sections that repeat content or
add nothing relevant:

```md
## What

## Why

## Implementation

## Testing approach

## Verification

## Data and rollout

## Scope and follow-up
```

## Explain the change visually

Add a compact visual within the useful section when it explains the change more
clearly than prose. Preserve the structure above; a diagram is optional, not a
new template or a required section.

- Use a small table for precedence rules, state transitions or before/after values.
- Use Mermaid for interactions, control flow or data flow. Show only the participants, decisions and boundaries needed to explain the changed behaviour.
- Use pseudocode, a call tree or a short diff sketch when order or a changed decision is the point. Avoid reproducing a file inventory or the full code diff.
- For a visible UI change, use relevant before/after screenshots when available and safe to share. Do not invent screenshots or create an HTML artifact that cannot be read in the PR.

Place the visual beside the short explanation it supports. Use actual domain
labels and distinguish previous behaviour from the implemented result. Remove
prose that merely repeats the visual. A diagram explains behaviour; it does not
establish that a check ran or that the result was observed.

## Handoff

Present the proposed repository, branch, base branch when known, title, and description. For a push, draft PR creation, or PR metadata edit, hand off to `github-pr-management`; those external writes require an explicit user request.
