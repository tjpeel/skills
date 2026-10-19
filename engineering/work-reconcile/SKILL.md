---
name: engineering-work-reconcile
description: Sanity-check and update an explicitly selected existing local engineering work item, including its specification, ticket scope and scheduling plan. Use to reconcile older or inconsistent planning artifacts; not to implement work, create an unrelated ticket set or rewrite saved execution history.
---

# Reconcile existing engineering work

Bring an existing specification and ticket set into agreement with approved
intent, the current code baseline and a usable dependency plan. A conversion
request authorises changes to the explicitly selected planning artifacts, not
new product decisions or implementation. An assessment-only request stays
read-only; a request merely to sanity-check does not authorise rewriting.
Preserve useful content and keep one ticket when the work is already a bounded,
independently useful change. Changing the format is not a reason to split it.

This skill updates existing artifacts. Use $engineering-to-tickets to create a
new set from an approved specification, and $engineering-implement to build a
ready ticket. Do not invoke the new-set writer over an existing ticket directory.

## Select the work and establish ownership

Resolve the current Git root and applicable repository instructions. Require an
explicit work reference or exact specification and ticket paths before writing.
A work reference selects only its own specification, ticket inventory and
planning metadata; do not scan other references, infer one from the branch, or
read unrelated logs. If the reference has multiple specifications or ambiguous
inputs, ask which ones belong to this reconciliation. Follow directly linked
sources only as far as needed to establish a contract or delivery boundary.

A reference is a non-empty opaque folder key. Preserve it exactly; reject `.`
and `..`, path separators and control characters. Resolve selected paths inside
the invoking repository and normal outputs beneath `.sdlc/work/<reference>/`,
including ancestor symlinks. The normal layout is:

```text
.sdlc/work/<reference>/
  specification.md
  plan.json
  tickets/
    01-<title>.md
```

The selected existing specification, ticket files and work-level `plan.json` are
the permitted write set. Keep stable filenames, ticket identities and numbering
where possible. New tickets are permitted only when a real delivery boundary
requires splitting this selected work; update affected links within the selected
set. New ticket names use the numbered kebab-case contract in
$engineering-to-tickets without invoking its new-set writer. Never delete or
overwrite unselected files. For explicit ticket subsets, preserve all unselected
plan entries and their fields; inspect sibling names and existing edges only as
needed to validate the combined graph. Read directly linked blockers only as
needed for the selected slice. A
correction requiring another ticket to change needs expanded write ownership
first.

Explicit legacy paths remain valid read-only sources. Migration needs a selected
work reference and authority for the named destinations; preserve the originals
unless their removal was explicitly requested. Do not silently migrate directories.

Before planning writes, verify the process folder is locally ignored and no
selected output is tracked. If exclusion is missing, include an append of
`/.sdlc/work/` to `git rev-parse --git-path info/exclude` in the backed-up write
set below, preserving existing entries. Do not change `.gitignore`, untrack files,
commit process material or publish it externally. Failed checks block writes.

## Check execution history before changing inputs

Establish whether any proposed output was captured before changing it. Use only
the selected reference's identified checkpoints or saved-run metadata: input
paths and hashes, ticket ownership and state, not entire logs or unrelated work.
Use the runner's documented read-only discovery when available. Verify supported
commands through its help; do not assume a runner's installation or storage
layout. A missing feature result does not rule out individual saved runs.

For standalone planning with no runner history, record the explicit user or
launcher evidence that these inputs were never captured. CLI absence, a ready
label, modification times or a clean tree cannot establish that. If applicable
history is unreadable, unlocated or ambiguous, continue assessment but block
writes to possible captured inputs until the gap is resolved.

Captured inputs stay immutable after stopped, blocked or completed runs,
including a shared specification captured by a sibling. Never edit frozen
hashes, execution journals, runtime/account/check selections or completion state.
For necessary content changes, explain the boundary and ask for a fresh work
reference before creating a replacement set; preserve the originals and history.

A dependency-only change for an unstarted ticket in a saved feature may use a
runner's supported guarded amendment after its eligibility checks and dry run
pass. This permits only the selected dependency amendment, not direct metadata
or captured Markdown edits, bypassing a hold or refreshing execution settings.
If the runner lacks that operation, return the limitation rather than editing
history by hand.

## Assess the selected delivery boundary

Read the selected specification and tickets in full. Inspect the relevant code,
contracts and existing tests far enough to distinguish behaviour already present
from changes still needed. Label code observations, executed verification and
unresolved assumptions separately. Do not run a full application suite merely
to convert planning metadata or claim tests passed from code inspection.

Check the following together rather than applying a formatting checklist:

- The ticket selects behaviour due now. The broader specification constrains
  relevant contracts and shared invariants; linked sibling tickets explain
  prerequisites or deferred ownership without adding delivery scope.
- Each capability serves a useful current outcome. Establish its caller,
  producer and prerequisites. A safe empty response or a test using invented
  future data does not justify early consumer surfaces. Keep dependent work in
  the appropriate slice unless a preparation step has a justified current
  purpose, cost and boundary.
- A ticket is an independently verifiable outcome that fits an implementation
  session. Separate layers, file counts and a broad specification do not alone
  justify more tickets. Do not generate tickets for explicitly deferred work.
- Acceptance criteria describe behaviour unmet at the inspected baseline,
  observable failure cases and credible existing test seams. Preserve approved
  outcomes when removing stale implementation instructions or duplication.
- Separate actual prerequisites from preferred order, source links and
  informational references. Distinguish a planned prerequisite from evidence
  that it is delivered. Do not mark a ticket complete solely from a code match.

Make evidence-backed structural and metadata corrections within settled intent.
A required outcome that appears unnecessary is a scope recommendation, not
permission to remove it. Resolve material behaviour changes or contradictions
before editing the affected documents; return a targeted decision through
$engineering-specification, or $engineering-decision-discovery when design is
unsettled. Report the proposed reduction and its current evidence. Do not leave
an apparently ready ticket that hides the question or invent another feature
to make the original requirement useful.

## Reconcile uncaptured artifacts

Before any write, preflight the complete target set for selection, containment,
tracking, exclusion and capture status. Back up existing targets, including the
Git exclude file if it needs an append, under a fresh system temporary directory
named `engineering-work-reconcile.XXXXXX` created with `mktemp -d`. Preserve
repository-relative paths, record hashes and which targets were absent, and
report the backup path. This invocation owns that directory; never reuse or
overwrite another backup, and retain it through handoff.

Recheck content hashes, absent-target collisions and capture status immediately
before replacement. When a runner can start, hold a supported execution/input
guard through the writes, or obtain the launcher's exclusive ownership of these
inputs. If neither is possible, stay read-only: hashes alone cannot detect a run
capturing unchanged files during assessment. Standalone work needs evidence that
no execution can start during the write window. Use atomic replacement where
supported. On failure, report
the exact partial state and do not declare readiness. Restore only this
invocation's writes when safe; never overwrite concurrent edits with a backup.

Amend the selected documents in place rather than creating a parallel report or
rewriting them into a longer template. Keep implementation scope compact, link
shared definitions, and retain material guard rails and verification limits.
Readiness requires an explicitly approved source specification and no blocking
questions. Reconciliation cannot confer approval. Assessment and draft
corrections may proceed within authority, but must not promote unapproved or
unresolved work to ready; report any existing ready label as stale.

A ready ticket uses `**Status:** ready-for-agent`; this means its content is
prepared, not that dependencies have finished. List exact sibling ticket links
under `**Blocked by:**`, or `None (can start immediately)` for an independent
root. Preserve genuine prerequisite relationships after they are satisfied;
readiness is determined from their actual state.

For an uncaptured ticket set, create or reconcile its work-level `plan.json`:

```json
{
  "version": 1,
  "tickets": {
    "01-current-change.md": { "depends_on": [] }
  }
}
```

Every selected ticket needs an entry. Derive `depends_on` only from explicit
blocker metadata, not other Markdown links. Preserve existing supported
priorities, path declarations and unknown fields. Stop plan writes on an
unrecognised version rather than interpreting or downgrading it. Also withhold
ticket additions, removals, renames and any edit requiring a plan change; report
scheduling validation and readiness as unresolved. Independent prose corrections
may proceed within authority. Reject unknown targets, self-dependencies and
cycles. Keep the Markdown blockers and the scheduling edges in agreement.

No CLI is required for uncaptured planning: validate the version-1 JSON, links
and graph directly. An optional runner command must support the existing plan,
preserve its fields and unselected entries, stay within the selected write set,
and offer a reviewed dry run. Do not use a whole-set importer on a selected
subset or bypass captured-input protections. Never install a runner, invent
flags or assume a command's writes from its name.

## Verify and hand off

Re-read the saved artifacts against the original intent and inspected baseline.
Verify selected ticket/plan coverage, preserved unselected entries, blocker
agreement, valid links, an acyclic combined graph and each ticket's useful
outcome. Check that deferred context did
not become new scope and no required outcome disappeared. A clean metadata plan
is not proof that implementation or production verification has happened.

When supported, run the selected ticket's SDLC dry run to check the handoff
without starting a model or changing execution settings. Otherwise state the
manual checks performed. Report changed paths, the reason for any scope or
splitting decision, current ready frontier with evidence for satisfied
blockers, unresolved
decisions, backup path and next implementation command. When prerequisite
completion is unknown, report only independent roots as ready. Include an
exact repository-relative worker input list: the selected ticket,
approved specification and only linked process sources, blockers or deferred
boundaries needed for that slice. Do not transfer the full plan or sibling
inventory merely because it was inspected. Ignored inputs do not travel to
another checkout automatically. Its launcher must establish
local exclusion, reuse only byte-identical inputs, stop on collisions and resolve
required links in the destination before starting the worker. Keep a valid
one-ticket item as one ticket
with an empty dependency list. Do not start implementation or a runtime build
unless separately requested.

For a clear small item, work directly. For a non-trivial split or disputed
boundary, read [the ownership and delegation
guide](references/ownership-and-delegation.md)
before selecting profiles. A `read_medium` delegate may audit the selected
sources and proposed scope/dependency graph; reserve `read_high` for material
risk or a consequential disputed conclusion. A single `write_low` delegate may
apply settled changes only to named uncaptured artifacts. Keep scope decisions,
capture checks, user questions and final validation with the coordinator.
