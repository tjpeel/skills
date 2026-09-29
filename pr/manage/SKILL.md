---
name: pr-manage
description: Safely inspect, push, and manage GitHub pull requests using local Git and the GitHub CLI. Use when asked to push a branch, create a draft pull request, or edit a pull request's title or description.
---

# GitHub PR management

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with local Git and GitHub CLI access. Follow all applicable
repository instructions: this normally includes `AGENTS.md` in Codex and
`CLAUDE.md` in Claude Code. Use each platform's normal approval mechanism for
external writes; the explicit user-authorisation requirements below still
apply.

## Delegation profiles

If delegation materially helps, select the least sufficient delegated
capability available in the current platform. In Codex, use the installed
custom profiles `read_low`, `read_medium`, `read_high`, `read_exceptional`, or
`write_medium`; do not substitute a Codex built-in role. In Claude Code, use an
equivalently bounded subagent only when subagents are available. A profile or
subagent is an effort and access boundary, not a task role: include the precise
task, inputs, constraints, and output shape in every handoff. If the equivalent
is unavailable, perform that bounded responsibility in the coordinating agent.

Use this personal skill for GitHub work across repositories. Read applicable
`AGENTS.md` and `CLAUDE.md` files before acting; they may define branch, PR, or
test requirements. Follow the precedence rules of the current platform when
the files conflict.

## Repository test gate

Treat applicable repository guidance as the source of truth for testing
requirements: `AGENTS.md` in Codex, `CLAUDE.md` in Claude Code, and any
repository documentation recognised by the current platform. Run every
required validation before committing, pushing, creating a PR, or editing PR
metadata.

If a required test cannot run because of a missing dependency, occupied port,
credentials, unavailable environment, or any other blocker, stop the
implementation and PR workflow. Report the blocker and request direction; do
not commit, push, create or edit a PR, or describe the omitted test as an
acceptable caveat. Never include language such as "tests were not run" or an
explanation for an unmet required test in a PR description.

## Preflight

When `scripts/pr-preflight.sh` is present, run it from the repository root as
`scripts/pr-preflight.sh [pr-number]`. It reports the repository, branch,
upstream, uncommitted changes, unpublished commits, and—when `gh` is
authenticated—the existing PR metadata. If the repository does not provide the
script, skip this optional preflight; its absence is not an unmet test gate.
If a present preflight script fails, treat that as a blocker.

Verify that `gh auth status` is authenticated for the target GitHub host before
creating or editing a PR. Do not expose credentials or tokens.

## Branch naming

Always create ticket branches as `<TICKET>-<short-kebab-description>`, for
example `MO-464-move-proxy-into-service`. Never use a `codex/` prefix or any
other generic prefix. If the ticket key is unavailable, request it before
creating the branch.

## PR identity and description wording

Every proposed or created PR title must begin with its ticket key, using the
format `<TICKET>: <Concise description>`, for example
`MO-464: Move proxy into service`. Confirm the ticket key before creating a PR
or changing its title.

When a generated PR description contains bullets, start the text of every
bullet (including nested and task-list bullets) with a capital letter. Rewrite
any item that would otherwise begin with lower-case text.

## Remote-write safeguards

Treat `git push`, `gh pr create`, and `gh pr edit` as external writes.

- Proceed only when the user has explicitly requested that exact action in the
  current task; otherwise present the proposed branch, base, title and body for
  approval.
- State the target repository, remote, branch, base branch, commits to push,
  and PR fields before performing the write.
- Never use force push, delete a branch, merge a PR, change reviewers or
  labels, or close issues unless the user separately asks.
- Preserve unrelated uncommitted work. Do not create a PR from a detached HEAD
  or a branch with no changes relative to its base.

## Push

Use the current named branch and its configured remote. For a branch without
an upstream, push with:

```bash
git push --set-upstream origin <branch>
```

For an existing upstream, use `git push`. Confirm the resulting remote SHA and
whether an existing PR will update automatically.

## Create a PR

Use the ticket-formatted branch and title above, plus the repository's required
PR-description structure. Write the body to a temporary Markdown file to
preserve formatting, then create a draft unless the user explicitly requests a
ready-for-review PR:

```bash
gh pr create --base <base> --head <branch> --title <title> --body-file <body-file> --draft
```

After creation, retrieve the PR URL and checks with `gh pr view`.

## PR Markdown formatting

Do not hard-wrap prose in a PR title or Markdown body. Keep each paragraph as
one physical line and let GitHub and the reader's client wrap it to the
available width. Use line breaks only for Markdown structure: headings, list
items, code blocks, blank lines, and intentional hard breaks.

## Edit a PR

Read the existing title and description first. Make only the requested title
or Markdown-body changes:

```bash
gh pr edit <number> --title <title> --body-file <body-file>
```

After editing, retrieve the PR and confirm the final fields. A branch push
updates its existing PR automatically; do not use `gh pr edit` unless its
metadata also needs changing.
