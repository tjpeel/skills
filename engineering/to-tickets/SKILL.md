---
name: engineering-to-tickets
description: Break an approved saved engineering specification into dependency-ordered local Markdown tickets. Use for multi-session implementation work; do not use to settle design decisions or implement the tickets.
---

# Engineering to tickets

Turn an approved saved specification into a small set of agent-ready local
tickets. Each ticket is a narrow, complete vertical slice that a fresh
implementation session can finish and verify independently. If the input is a
plan, conversation, draft, unapproved specification, or a specification without
a local path, return it to `$engineering-specification` rather than creating
tickets.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Local ticket contract

Work only in the Git repository from which this skill was invoked. Resolve its
root before creating files; if there is no Git root, stop and ask the user for
a repository. Do not create, update, or publish tickets in an external tracker.

Ask for a ticket reference before creating tickets if the user has not supplied
one.
It must be a non-empty, single directory name: it cannot be `.` or `..`, and
cannot contain a path separator. Preserve it exactly, so references such as
`MO-123` are valid. Use it as the parent folder in this exact layout:

```text
<repository-root>/.tickets/<ticket-reference>/
  01-<short-kebab-case-title>.md
  02-<short-kebab-case-title>.md
```

Number tickets in dependency order, with at least two digits. A ticket may name
only a lower-numbered ticket as a blocker. Never alter `.gitignore`. If the
reference directory exists and contains anything, show the collision and ask
the user for a new ticket reference. If it does not exist, or exists but is
empty, create the new ticket set there. Never merge, replace, overwrite, or
partially reuse an existing ticket set.

## Delegation profiles

For a small, clear specification, work directly. When independent mapping or
an audit would materially improve a non-trivial decomposition, use the least
sufficient delegated capability available in the current platform. In Codex,
use the installed custom profiles `read_low`, `read_medium`, `read_high`, or
`write_medium`; do not substitute a Codex built-in role. In Claude Code, use an
equivalently bounded subagent only when subagents are available. A profile or
subagent is an effort and access boundary, not a task role: give every handoff
its precise task, inputs, constraints, and required output. If the equivalent
is unavailable, perform that bounded responsibility in the coordinating agent.

- Use `read_low` to map unfamiliar current behaviour, domain vocabulary,
  decisions, and test seams needed to make the tickets credible.
- Use `read_medium` to audit a non-trivial draft for vertical slicing,
  dependency cycles, session-sized scope, omissions, and criteria that could
  actually fail at the baseline.
- Use `read_high` only for credible migration, data-loss, security,
  concurrency, compatibility, or cross-service risk, including whether risk
  sequencing creates a necessary blocker.
- Use `write_medium` as the sole local writer when delegation is warranted.
  Its scope is the new files beneath `.tickets/<ticket-reference>/`; it must
  not rewrite the agreed decomposition or overwrite existing files.

The coordinator owns reference validation, user questions, the decomposition,
and collision decisions. Read-only handoffs return evidence and audit findings
only.

## Build the ticket set

Read the approved saved specification in full. Confirm that its status is
`approved`, it has no blocking questions, and its path belongs to the invoking
repository. Check the repository, glossary, decisions, and tests only to fill
material evidence gaps; do not repeat investigation already captured by the
specification. Return an unsettled product or design choice to
`$engineering-decision-discovery` or `$engineering-specification` instead of
inventing it.

Before writing, audit coverage: every required behaviour, observable
acceptance criterion, and applicable change or rollout constraint in the
specification must be owned by at least one ticket. Reject ticket scope that is
not supported by the approved specification.

Also audit the state of the system after each ticket lands. Assign ownership
for failure and recovery paths, startup validation, readiness, and operational
budgets to the ticket that first introduces the affected behaviour. Do not
defer its safety or regression coverage to a later feature ticket. If a partial
path receives real inputs, its current disposition and any eventual retry,
dead-lettering, ordering or operator consequence must already be settled in the
specification. Return a gap upstream rather than treating "out of scope" as a
runtime policy.

Identify necessary prefactoring first. Fold it into the first vertical slice by
default. Create a separate prerequisite only when it can land green, is
independently verifiable, and creates a necessary seam or materially reduces
implementation risk. Prefer tracer-bullet vertical slices: each ticket delivers
a narrow, end-to-end behaviour across every layer that matters, is demoable or
otherwise verifiable on its own, and fits in one fresh implementation session.
Do not divide work into separate schema, API, UI, or test tickets. For a wide
mechanical change that cannot land green as vertical slices, use clearly
sequenced expand, migrate, and contract batches by blast radius. Keep each batch
independently green where possible. Create a final integrate-and-verify ticket
only when isolated green batches are genuinely impossible, and state that
exception in the ticket.

Build an acyclic blocker graph. Give every ticket explicit blockers, or `None
(can start immediately)`. A blocker represents an actual prerequisite, not a
preferred order. Each acceptance criterion must be observable, unambiguous,
and capable of failing at the starting revision. Reject criteria such as
"tests pass", implementation task lists, or claims already true at the
baseline.

Keep stale detail out of tickets: do not include file paths or code snippets.
The only exception is a short, labelled prototype fragment when it is the
clearest record of a settled state machine, reducer, schema, or type decision.

For a non-trivial ticket, provide a short sequence of observable implementation
increments, each with its verification seam. These are checkpoints within one
ticket, not new layer-based tickets or a list of implementation files. State
the current behaviour at deferred boundaries and name the later ticket that
changes it. Request a short code comment only where the partial behaviour
would otherwise mislead a reader; the comment must explain what happens now
and what later work adds. Its meaning must remain understandable without the
local ticket file.

## Create tickets

Validate the ticket reference and inspect its target directory before writing.
If the directory exists and contains anything, show the collision and ask for a
new reference; do not show a preview as a substitute for writing. Otherwise,
write the ticket set immediately. A missing `.tickets/` directory, or an empty
parent reference directory, is not a blocker and may be created as part of this
write.

Write one file for each ticket using this form:

```md
# 01: <Outcome-oriented title>

**Parent reference:** <ticket-reference>
**Source specification:** [<title>](<relative-path-to-approved-specification>)
**Status:** ready-for-agent
**Blocked by:** None (can start immediately)

## What to build

<The end-to-end behaviour delivered, in the project's domain language.>

## Acceptance criteria

- [ ] <Observable behaviour that is unmet at the baseline.>
- [ ] <Independent observable behaviour.>

## Decisions and constraints

<Only settled detail that a fresh implementation session needs. Omit this
section when it is empty.>

## Implementation increments

<For non-trivial work, ordered observable checkpoints and their test seams.>

## Deferred behaviour

<When applicable, current behaviour and consequences at incomplete boundaries,
the later ticket that changes each, and any comment needed to explain it.>
```

For a blocked ticket, list every blocker as a relative Markdown link, such as
`[01 — Add read path](01-add-read-path.md)`, under `**Blocked by:**`. The
`ready-for-agent` status means the ticket content is prepared; the blocker graph
still decides whether it can start. Report the created paths and the ready
frontier: tickets with no open blockers. Do not implement tickets, create
branches, or make external changes.

Before handing off, resolve every specification and blocker link from the
directory of the file containing it. Confirm the specification target exists
inside the invoking repository and blocker links resolve to the intended
lower-numbered tickets. A written file with a broken source link is not ready
for an isolated implementation session.
