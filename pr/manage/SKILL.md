---
name: pr-manage
description: Inspect and publish GitHub PRs through local Git and the GitHub CLI. Use to push branches, create draft PRs or edit PR titles and descriptions.
---

# GitHub PR management

## Platform compatibility

Use this workflow in Codex, Claude Code or another environment with local Git
and GitHub CLI access. Follow applicable `AGENTS.md`, `CLAUDE.md` and
repository instructions, using platform precedence for conflicts. Platform
approval mechanisms do not replace the explicit user authorisation required
below.

## Delegation profiles

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

One quick deterministic read can stay with the coordinator. For sustained
target, preflight, validation-result or check inventory, use configured
`read_low`. Give the observer the repository, branch, PR and revision to
inspect. It may read evidence only; it must not edit files, mutate Git state or
write to GitHub. Reuse it across bounded observations and have it return the
observed revision, check/run identities, meaningful changes, terminal result
or blocker. End its assignment when that bounded question is answered.

Use `read_medium` for nontrivial evidence interpretation and `read_high` only
for difficult questions or material security/risk analysis. Keep publication
writes with the coordinator, who refreshes the target and relevant state
before acting. This skill authorises no implementation or repair. When the
user has authorised monitoring or repair after publication, hand off to
`$pr-monitor`; use that skill's observer and higher-reasoning writer phases
within its permitted scope.

## Repository test gate

Run every validation required by applicable repository guidance before
committing, pushing, creating a PR or editing PR metadata.

If any required test cannot run, stop the implementation and PR workflow,
report the blocker and request direction. Do not commit, push, create or edit
a PR. Do not present the omitted test as an acceptable caveat or explain an
unmet required test in the PR description, including “tests were not run”.

## Preflight

When present, run `scripts/pr-preflight.sh [pr-number]` from the repository
root. It reports repository, branch, upstream, uncommitted changes,
unpublished commits and, when `gh` is authenticated, existing PR metadata. Its
failure blocks the workflow; its absence does not violate the test gate.

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

When generating or substantively rewriting a PR description, apply $pr-draft
for evidence, review detail and Mermaid selection, including during SDLC runs.
Publish the approved body with its explanations and diagrams intact; do not
compress it into a capability list. For a narrow metadata edit, preserve
unrelated content rather than regenerating the description.

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

Start every generated description bullet, including nested and task-list
bullets, with a capital letter.

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

Apply the reference, branch, metadata and repository-template rules above.
Write the body to a temporary Markdown file, then create a draft unless the
user explicitly requests a ready-for-review PR:

```bash
gh pr create --base <base> --head <branch> --title <title> --body-file <body-file> --draft
```

After creation, retrieve the PR URL and checks with `gh pr view`.

When the user requested monitoring after publication, continue with
`$pr-monitor` against the verified remote SHA. Creating the PR and retrieving
its current checks once does not complete that requested follow-through.

## PR Markdown formatting

Keep each PR title and body paragraph on one physical line. Use line breaks
only for Markdown structure: headings, list items, code blocks, blank lines
and intentional hard breaks.

## Edit a PR

Read the existing title and description first. Make only the requested title
or Markdown-body changes:

```bash
gh pr edit <number> --title <title> --body-file <body-file>
```

After editing, retrieve the PR and confirm the final fields. A branch push
updates its existing PR automatically; do not use `gh pr edit` unless its
metadata also needs changing.
