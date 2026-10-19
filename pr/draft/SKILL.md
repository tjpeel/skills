---
name: pr-draft
description: Draft an evidence-based PR title and Markdown description from implementation, tests and optional ticket context. Use for PR metadata or review-ready summaries; publishing belongs to $pr-manage.
---

# Draft a PR description

Produce copy-ready metadata explaining the problem, changed behaviour and
verification without requiring the reviewer to reconstruct the diff. This
skill is read-only: do not push, create or edit a PR.

Follow applicable repository instructions, including `AGENTS.md` or
`CLAUDE.md`. Invoke named source skills where supported; otherwise read their
`SKILL.md`. Handle ordinary drafts directly. Before delegating, read [the
ownership and delegation guide](references/ownership-and-delegation.md).
Readers gather only code and test evidence; the coordinator owns the draft and
handoff.

## Gather evidence

- Identify the selected ticket key or work reference. Use installed ticket-context
  guidance when available and keep ticket access read-only. Use its problem,
  acceptance criteria, dependencies and rollout constraints. If access fails,
  disclose it and ask whether to continue repository-only; without a selected
  reference, identify the draft as repository-only in the handoff.
- Inspect the branch, merge base, commits and pending changes across code,
  configuration, migrations, documentation and tests. For a stack, establish
  the actual predecessor and PR base; separate inherited work, this slice,
  deferred capabilities and local changes from published content.
- Trace the changed path through callers and dependencies far enough to explain
  its decisions, ordering, boundaries and material failure or recovery behaviour.
  A ticket or commit summary alone is insufficient implementation evidence.
- Bind verification claims to observed results for the reviewed content. After
  signing or rebasing, check tested and published trees before reusing evidence.
  Keep candidate hashes and reconciliation in the handoff.

## Write for the reviewer

Use `<reference>: <concise outcome>` when a ticket key or selected work reference
is known; otherwise use the outcome alone. Preserve the exact selected reference
in title and body. Put `Ticket: <ticket-key>` or `Work reference: <reference>`
before the first heading; retain both when both were supplied.

Follow the repository's required PR template. Otherwise use these headings once,
in this order, with non-empty content; use “Not applicable” only when appropriate:

```md
## What
## Why
## Implementation
## Testing approach
## Verification
## Data and rollout
## Scope and follow-up
```

Scale detail to behaviour and review risk, without section sentence limits.
Substantial changes need more than a capability list. Explain:

- **What / Why:** The concrete trigger, previous outcome or limitation, and
  resulting behaviour, grounded in ticket and repository evidence.
- **Implementation:** How the changed path works and why the important choices
  matter. Cover material decisions, ordering, identity or state, contracts and
  failure/recovery handling. Use domain terms rather than a file inventory.
- **Testing approach:** The important regression conditions and expected
  outcomes, including the failures they protect against; “covers retries” alone
  does not explain what happens after a partial failure.
- **Verification:** Relevant evidence beyond routine CI, such as observed
  before/after behaviour, manual checks, query plans or rollout validation.
  State material limitations and missing required checks explicitly. Never
  imply an unrun check passed. Omit routine CI command lists, counts and approvals.
- **Data and rollout:** Material schema, configuration, migration, deployment,
  compatibility and rollback implications, including ordering or prerequisites.
- **Scope and follow-up:** Deliberately excluded behaviour, unresolved risks and
  required follow-up without implying deferred capabilities already exist.

Keep assumptions and unknowns explicit. Exclude conversation history, access
troubleshooting, agent/controller logistics, private process paths and local
sequence numbers presented as tracker keys. Use one physical line per prose
paragraph in the output; retain Markdown structural line breaks.

## Use Mermaid when it clarifies the change

Actively assess the changed behaviour for a useful diagram before finalising.
Include a compact fenced `mermaid` diagram when a changed interaction, control
or data flow, state transition, retry/recovery path or ordering constraint is
material to understanding the PR and can be represented accurately from evidence.
This is the expected choice for those changes, including drafts produced during
SDLC runs; do not omit it merely to keep the description short.

Use a flowchart for branches or state, or a sequence diagram for participants and
ordering. Place it beside the explanation it supports, usually in Implementation,
within the required template. Show the changed path, key decision or failure
branch and relevant boundary, using actual domain labels. Identify before/after
behaviour when needed; do not imply unchanged or deferred work is new.

Omit Mermaid when it adds no understanding: a small isolated fix, mechanical
rename, dependency bump or prose-only edit often needs none. Prefer a table for
value or precedence comparisons, or available safe screenshots for a UI change.
Never invent interactions to justify a diagram. If evidence is insufficient,
keep that limitation explicit in the handoff. Do not add an empty diagram section
or an omission explanation to the PR.

Check the fence, syntax and consistency of every node and edge with the reviewed
code. Render with available tooling when practical; do not claim a render check
that did not run. Keep the prose needed to explain rationale and consequences;
a diagram does not replace it or prove verification occurred.

## Final check and handoff

Check the template, exact references, evidence-backed claims and material
verification gaps. Add any explanation needed to trace the changed path and
important failure outcome. Confirm diagram-suitable changes have an accurate
diagram.

Return the proposed repository, branch, known base, title and description.
Keep drafting or access limitations in the handoff and preserve $pr-manage's
required-test gate. Hand off authorised publication to $pr-manage; external
writes still require the user's explicit request.
