---
name: engineering-to-tickets
description: Break an approved engineering specification into dependency-ordered local Markdown tickets. Use for multi-session implementation work; do not use to settle design decisions or implement the tickets.
---

# Engineering to tickets

Turn a settled plan, specification, or current conversation into a small set
of agent-ready local tickets. Each ticket is a narrow, complete vertical slice
that a fresh implementation session can finish and verify independently.

## Local ticket contract

Work only in the Git repository from which this skill was invoked. Resolve its
root before creating files; if there is no Git root, stop and ask the user for
a repository. Do not create, update, or publish tickets in an external tracker.

Ask for a reference number before publishing if the user has not supplied one.
It must be a non-empty decimal string; preserve leading zeroes. Use it as the
parent folder in this exact layout:

```text
<repository-root>/.tickets/<reference-number>/
  01-<short-kebab-case-title>.md
  02-<short-kebab-case-title>.md
```

Number tickets in dependency order, with at least two digits. A ticket may name
only a lower-numbered ticket as a blocker. Never alter `.gitignore`. If the
reference directory or a target file already exists, do not merge or overwrite
it silently: show the collision and ask the user for a new reference number or
explicit replacement authority.

## Delegation profiles

For a small, clear specification, work directly. When independent mapping or
an audit would materially improve a non-trivial decomposition, use the least
sufficient custom profile from `~/.codex/agents/`: `read_low`, `read_medium`,
`read_high`, `read_exceptional`, or `write_medium`. A profile is an effort and
access boundary, not a task role: give every handoff its precise task, inputs,
constraints, and required output. Do not use Codex built-in `default`,
`worker`, or `explorer` agents. If a profile is unavailable, perform that
bounded responsibility in the coordinating agent.

- Use `read_low` to map unfamiliar current behaviour, domain vocabulary,
  decisions, and test seams needed to make the tickets credible.
- Use `read_medium` to audit a non-trivial draft for vertical slicing,
  dependency cycles, session-sized scope, omissions, and criteria that could
  actually fail at the baseline.
- Use `read_high` only for credible migration, data-loss, security,
  concurrency, compatibility, or cross-service risk, including whether risk
  sequencing creates a necessary blocker.
- Use `write_medium` as the sole local writer after explicit approval. Its
  scope is the approved files beneath `.tickets/<reference-number>/`; it must
  not rewrite the agreed decomposition or overwrite existing files.

The coordinator owns reference validation, user questions, the decomposition,
approval, and collision decisions. Read-only handoffs return evidence and
audit findings only.

## Build the ticket set

Read the supplied specification, plan, or current conversation in full. Check
the repository, glossary, decisions, and tests only to fill material evidence
gaps; do not repeat investigation already captured by the input. Return an
unsettled product or design choice to `$engineering-decision-discovery` or
`$engineering-specification` instead of inventing it.

Identify necessary prefactoring first. Prefer tracer-bullet vertical slices:
each ticket delivers a narrow, end-to-end behaviour across every layer that
matters, is demoable or otherwise verifiable on its own, and fits in one fresh
implementation session. Do not divide work into separate schema, API, UI, or
test tickets. For a wide mechanical change that cannot land green as vertical
slices, use clearly sequenced expand, migrate, and contract batches by blast
radius, followed by an integration or verification ticket when needed.

Build an acyclic blocker graph. Give every ticket explicit blockers, or `None
(can start immediately)`. A blocker represents an actual prerequisite, not a
preferred order. Each acceptance criterion must be observable, unambiguous,
and capable of failing at the starting revision. Reject criteria such as
"tests pass", implementation task lists, or claims already true at the
baseline.

Keep stale detail out of tickets: do not include file paths or code snippets.
The only exception is a short, labelled prototype fragment when it is the
clearest record of a settled state machine, reducer, schema, or type decision.

## Approve, then write

Before writing files, show the proposed tickets in dependency order. For each,
give its number, title, blockers, and the end-to-end behaviour it delivers.
Ask the user to confirm the granularity and blocker edges, and revise until
they explicitly approve the set. Do not create `.tickets/` before that
approval.

After approval, write one file for each ticket using this form:

```md
# 01: <Outcome-oriented title>

**Parent reference:** <reference-number>
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
```

For a blocked ticket, list every blocker as `01 — <title>` under `**Blocked
by:**`. Report the created paths and the ready frontier: tickets with no open
blockers. Do not implement tickets, create branches, or make external changes.
