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

Delegate only when it materially helps.

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

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

When repository policy requires signed commits, verify the effective identity
and signing configuration before the relevant commit or push, then check the
resulting signature. Report whether local or GitHub verification was observed.
An unsigned commit does not authorise rewriting history or force pushing.

## Branch naming

Use the confirmed ticket key or selected work reference for the work. Resolve
it from the current request or explicitly selected ticket, specification or
launch context. Local engineering tickets use `**Work reference:**` (or legacy
`**Parent reference:**`). A work reference is an opaque folder key, not a
tracker identifier: any non-empty single folder name is valid except `.` or
`..`, path separators, or control characters. Preserve it exactly, with no
required tracker format or case conversion.
Check that it agrees with the selected `.sdlc/work/<reference>/` folder and
launch context when supplied. Do not scan process folders for a reference or
derive one from a local ticket sequence number, filename, branch or PR number.
If the reference is missing, conflicts with the selected inputs, or several
references are offered without selecting one for naming, resolve that gap
before creating a branch or publishing PR metadata.

For a new branch, follow the engineering naming form:

```text
<branch-safe-reference>-<short-ticket-description>
```

Use the ticket key or work reference unchanged as the prefix when the resulting
branch is valid; otherwise choose a short branch-safe rendering separately.
Validate the full name with `git check-ref-format --branch`. Derive the short,
lowercase description from the ticket's outcome, using letters, numbers and
hyphens. For example, work reference `read cache` and outcome “Add read path”
use branch `read-cache-add-read-path`. Preserve the exact work reference in
process paths and ticket metadata. Never use a `codex/` or other generic
prefix. Treat references and branch names as literal data in shell operations.

Verify an already prepared branch against the selected launch context and use
its recorded name; do not rename it to match a new rendering. If a proposed
branch already exists, verify it is the selected branch to resume or ask for
a new description rather than repurposing it.

## PR identity and description wording

Every proposed or created PR title must begin with the exact confirmed ticket
key or selected work reference, using `<reference>: <Concise description>`.
For example, a tracker ticket uses `EX-123: Add read path`; work reference
`read cache` uses `read cache: Add read path`, even when its branch prefix is
`read-cache`. If the exact reference cannot be represented in a title, report
the issue rather than trimming, truncating or replacing it.

Carry the same exact reference in the description's existing equivalent field,
or add `Ticket: <ticket-key>` or `Work reference: <reference>`. When a ticket
key is selected for the title and an associated work reference is also
supplied, retain both in the body. Each PR in a selected ticket stream keeps
the reference; its outcome description distinguishes the slice. Do not expose
private process paths or present local ticket sequence numbers as tracker keys.

For an existing PR, check its title and body against the selected reference
before editing. Apply these rules to the requested fields only. If another
field needs correction to carry the reference consistently, prepare that
correction and obtain authority before changing that field; do not silently
expand the metadata edit.

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

For an explicitly selected stack, use the supplied predecessor branch as the
PR base. Compare its current head with the delivered predecessor revision in
the launch context and reconcile any difference before creating the PR. An
independent root targets the repository's selected integration branch. Do not
silently target `main` for a child or change an existing PR's base. After an
upstream repair, identify affected descendants and complete only authorised
restacking and publication; a repaired local branch does not update a remote
child by itself. Keep this branch state in the current handoff rather than
editing local tickets to track heads.

Use the confirmed ticket key or selected work reference and the branch and PR
metadata rules above, plus the repository's required PR-description structure.
Write the body to a temporary Markdown file to preserve formatting, then
create a draft unless the user explicitly requests a
ready-for-review PR:

```bash
gh pr create --base <base> --head <branch> --title <title> --body-file <body-file> --draft
```

After creation, retrieve the PR URL and checks with `gh pr view`.

When the user requested monitoring after publication, continue with
`$pr-monitor` against the verified remote SHA. Creating the PR and retrieving
its current checks once does not complete that requested follow-through.

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
