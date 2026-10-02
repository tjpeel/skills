---
name: engineering-architecture-survey
description: Find and rank evidence-backed refactoring opportunities in an existing codebase before work is selected. Use for architectural friction, coupling or difficult verification; do not use for reviewing a diff, recovering historical ADRs or implementing a refactor.
---

# Engineering architecture survey

Find changes that would repay their cost by reducing the knowledge, coordination
or verification needed to change the codebase. Return a short, cited list of
credible candidates. A survey can find no worthwhile candidates.

Survey the current code without changing source, tests, configuration, glossary
or ADRs. Keep the findings in the conversation unless a saved report is
requested or required by applicable repository instructions. A candidate is a
proposal, not an accepted design or permission to implement it.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When a source skill is named with `$`,
invoke it where supported; otherwise read its `SKILL.md` and apply that
workflow directly. The survey itself needs no tracker or catalogue setup.

## Bound the survey

Use the user's named area, pain point or constraint. If none was supplied, use
recent Git history to locate repeatedly changed areas before examining their
current code. Distinguish feature work from generated files, formatting and
mechanical updates. Change frequency guides attention; it does not prove a
design problem. Widen the scope when the history supplies no useful focus, and
state the areas actually examined and any limits.

Read applicable guidance and relevant existing terminology and architectural
constraints. Domain records may be named `GLOSSARY.md`, `CONTEXT.md` or
something else; follow the repository's guidance and the document's content.
If `CONTEXT-MAP.md` exists, follow its relevant links rather than assuming every
record is named `CONTEXT.md`. A context file may contain a glossary alongside
broader domain constraints. When both names exist, read the relevant content
and surface contradictions; do not assume the files are interchangeable.
Verify claims against current code. Preserve established names and locations;
do not create, rename or synchronise records because an expected filename is
missing. Treat stale or conflicting records as uncertainty to resolve, not
permission to ignore their constraints.

Use only process inputs explicitly supplied for this task or directly linked
as relevant sources from those inputs. Do not scan `.sdlc/work/`,
`.specifications/`, `.tickets/` or `.handoffs/` for intent, or infer it from a
branch name or folder reference. Apply the same boundary to delegates.

Identify the checked-out revision and relevant uncommitted changes. Trace a
representative behaviour through entry points, callers, dependencies, effects
and existing tests. Locate where one change or failure requires coordinated
knowledge across those paths. Read history or run existing focused checks when
they can resolve a concrete uncertainty; a survey does not require the full
test suite or exhaustive history reconstruction.

## Delegation profiles

For a small area with a clear behaviour path, work directly. A survey spanning
several packages, shared callers and independent behaviours can benefit from
bounded mapping and candidate analysis. Use the least sufficient delegated
capability available. In Codex, use the installed custom profiles `read_low`,
`read_medium` or `read_high`; do not substitute a built-in role. In Claude
Code, use an equivalently bounded read-only subagent only when available. If
the equivalent is unavailable, perform that responsibility directly.

- Use `read_low` to map a specified area, recent changes, callers, contracts
  and tests. It returns source anchors and observed friction, not a redesign.
- Use `read_medium` to assess a bounded candidate against those raw sources:
  whether it would reduce caller knowledge or coordinated changes, what it
  would cost, which guarantees must survive and what counter-evidence exists.
- Use `read_high` only for a credible material migration, data-loss, security,
  concurrency or cross-service risk that needs deeper investigation.

Give each handoff the precise area, questions, selected inputs, relevant source
anchors, constraints and required output. Parallelise independent areas, not
duplicate tours of the repository. The coordinator owns the scope, ranking,
recommendations, user questions and any requested report. Delegates do not
alter files, settle designs or make external writes.

## Assess candidates against observed friction

Look for responsibilities that leak into callers, repeated branching or policy,
dependencies that require several modules to change together, interfaces that
force callers to understand internals, and behaviour that existing tests cannot
observe through a useful contract. Show a concrete change or failure scenario
and the code that makes it costly. File count, module size, missing tests and
personal style preferences alone do not establish a candidate.

A deep module exposes useful behaviour while hiding complexity callers do not
need to know. Consider whether moving a responsibility behind a smaller,
coherent interface would concentrate that knowledge and its verification.
Imagine removing an abstraction: would useful isolation disappear, repeated
logic spread to callers, or unnecessary indirection simply vanish? Treat this
as a question, not a mechanical rule for merging or deleting modules.

Small functions and thin adapters can protect compatibility, ownership,
security or operational isolation. Trace those purposes before recommending
consolidation. Preserve meaningful boundaries and avoid proposing a new port,
framework or abstraction merely to add a test double. Compare the candidate
with leaving the code alone and with a smaller local change. State where
complexity moves; fewer files do not necessarily mean less complexity.

Identify the existing behavioural guarantees, tests and other verification a
refactor must preserve. Apply `$engineering-testing` when assessing a concrete
coverage gap or proposing test changes. Do not assume interface tests justify
deleting all lower-level tests; replacements must preserve their distinct
guarantees. A hard-to-test path may warrant better verification without an
architectural change.

Check candidates against relevant accepted decisions. Surface a conflict only
when observed friction justifies reconsidering that constraint, and state the
evidence and decision that would need reopening. Do not silently overturn it
or turn a theoretical alternative into a recommendation.

## Present a ranked shortlist

For each credible candidate, give:

- the affected behaviour and precise repository-relative file and line anchors;
- the observed friction and its concrete change or failure scenario;
- the proposed responsibility or contract change, without designing a full
  replacement interface;
- the expected benefit, likely effort, compatibility or rollout risk, and
  behavioural verification to preserve;
- counter-evidence, assumptions and facts still needing investigation; and
- a recommendation strength: `Strong` when the friction and likely benefit are
  supported, `Worth exploring` when a named uncertainty remains material, or
  `Speculative` when the proposed benefit is unverified.

Rank by benefit relative to cost and risk, using the evidence rather than an
invented numerical score. Do not pad the shortlist with speculative candidates.
Distinguish observed current structure from proposed structure. Use a small
before/after diagram when it explains the change more clearly than prose;
HTML is optional, and repository vocabulary takes precedence over a prescribed
architecture glossary.

Name the candidate worth investigating first and why, or explain why none met
the threshold. State the survey boundary and evidence gaps so the report does
not imply a comprehensive audit or prove that a proposed refactor is safe.

## Save a report only when requested

Resolve the invoking Git repository's root. A requested saved report uses
`<repository-root>/.sdlc/work/<reference>/architecture-survey.md`; use
`architecture-survey.html` instead when an HTML report was requested. Reuse the
reference explicitly selected for this task or supplied by a selected work
path; ask for one if neither supplies it. It is an opaque folder key: preserve
any non-empty single folder name except `.` or `..`, path separators or control
characters. Do not derive it from a title, branch or tracker identifier.
Treat it as literal data in filesystem and shell operations, and confirm the
resolved target stays beneath `.sdlc/work/`, including existing symlinks.

This skill owns only the selected report file. Other files may coexist in the
work folder; neither their presence nor the reference selects them as inputs.
Create the report only when absent. Update an existing report only when the
user explicitly selects it for revision; otherwise report the collision and
request another reference or explicit selection. Do not merge reports, replace
an unselected format, or update decisions, specifications or tickets.

The report is an uncommitted process artifact, not maintained documentation.
Before writing, verify that the target is untracked and locally ignored. If
needed, append `/.sdlc/work/` to the local exclude file resolved by
`git rev-parse --git-path info/exclude`, preserving existing entries. Leave
`.gitignore` unchanged. If exclusion cannot be established or the target is
tracked, keep the findings in the conversation and report the condition. Never
stage, commit or silently untrack the report.

For HTML, use a standalone file with inline styling and static diagrams; no
CDN scripts or external assets are needed. Escape repository text as data.
Check the saved report's citations and display before opening it through the
available file preview. Return its absolute path. If file writes are unavailable,
return the findings in the conversation and state that no report was saved.

## Hand the selected candidate to design

Finish with the shortlist. Let the user select which candidate to investigate,
unless the current request already selects one or authorises a next stage.
Carry its evidence, constraints, trade-offs, verification guarantees and open
questions into `$engineering-decision-discovery`. That workflow resolves the
design; `$engineering-specification` can then capture settled implementation
intent. If those skills are unavailable, return the same evidence as a concise
handoff. Selection alone does not authorise code changes, tracker updates or
new ADRs; respect any such work already authorised in the current request.
