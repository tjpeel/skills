---
name: architecture-adrs
description: Recover retrospective architecture decision records from a codebase and its Git and pull-request history. Use when durable implementation choices need evidence-backed ADRs; do not use to invent future decisions or conduct an ordinary code review.
---

# Retrospective ADRs

Create a reflective but concise set of ADRs that explains decisions still material to operating or changing the system. Use two complementary lenses: accountable historical coverage and current-code materiality. The output is evidence-led: distinguish a documented rationale from an inference drawn from code or history.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and Git-history access. Follow
all applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When a source skill is named with `$`,
invoke it where supported; otherwise read that source skill's `SKILL.md` and
apply its workflow directly.

## Delegation profiles

Use the least sufficient delegated capability available in the current
platform. In Codex, use the installed custom profiles `read_low`,
`read_medium`, `read_high`, `read_exceptional`, or `write_medium`; do not
substitute a Codex built-in role. In Claude Code, use an equivalently bounded
subagent only when subagents are available. A profile or subagent is an effort
and access boundary, not a task role: include the precise task, inputs,
constraints, and output shape in every handoff. If the equivalent is
unavailable, perform that bounded responsibility in the coordinating agent.

- Use `read_low` to establish the current system shape and locate present-day evidence, and for exhaustive Git and pull-request indexing with a PR-coverage classification.
- Use `read_medium` to turn a bounded history cluster or current-code decision seam into a cited decision dossier, and to audit ADR coverage and factual support.
- Invoke `read_exceptional` only to decide whether completed dossiers support an ADR and to draft or consolidate it. This is the sole exceptional-effort handoff.
- Use `read_high` only for a material migration, data-loss, concurrency, security, or cross-service dispute.

## Two-lens investigation

Start by reading applicable repository instructions and asking for the intended ADR scope if it is not apparent. Preserve the checked-out state and do not make source changes as part of the investigation.

### Historical accountability lens

Build an index of the full history, but do not ask a model to read the full history verbatim. Use Git and pull-request metadata to identify changed paths, migrations, schemas, public contracts, integrations, security boundaries, operational configuration, and test changes.

Have `read_low` return both a structured coverage table and a PR-coverage classification: `candidate`, `supporting evidence`, `superseded`, `mechanical`, `reviewed—no durable decision`, or `unavailable`. A PR-by-PR matrix is an accountability record, not a requirement to create one ADR per PR. Read PR descriptions or discussion only for credible candidates and enough ambiguous entries to classify them safely.

### Current-code materiality lens

Use `read_low` to map the current architecture independently and to identify decision seams in addition to broad component boundaries. A decision seam is code that turns external, persisted, or workflow state into a domain or public meaning: for example, integration mappers, `switch`/pattern matches over source-owned enums, selection and fallback rules, normalisation/defaulting, status transitions, version checks, retry classification, and boundary-specific validation.

For a nominated code anchor—or a seam found through this scan—trace its callers, tests, public or persisted consequences, and file history. A small method can support an ADR when it expresses a stable, consequential policy at an integration or domain boundary. Do not promote ordinary DTO mirroring, incidental null handling, or local implementation convenience without evidence that the logic defines a retained constraint. Read [the decision-discovery guide](references/decision-discovery.md) when selecting or tracing seams.

Investigate clusters or seams that either explain a present-day boundary, encode a consequential source-to-domain choice, or change an earlier durable choice. Send only those bounded candidates to `read_medium`. Read [the evidence dossier format](references/evidence-dossier.md) before requesting or assessing a dossier.

Keep Astra selective:

- Give `read_exceptional` the current-code map, the PR-coverage summary, and only completed decision dossiers; never the raw complete log or unfiltered PR corpus.
- Use `high` reasoning for synthesis, but call it only for credible candidates and final consolidation.
- Prefer `not enough evidence for an ADR` over plausible reconstruction. One historical change alone can be evidence, but its confidence and rationale limits must be explicit.
- Reuse a durable dossier when one decision appears in multiple PRs; do not pay for repeated synthesis of the same material. Do not merge distinct decisions merely to reduce the count: merge only when they own the same boundary and consequences.

## Produce and verify ADRs

Each ADR should state the context, decision, status, consequences, and evidence. Cite precise PRs or commits and relevant paths. Explain whether each rationale is explicit, corroborated, or inferred. A coherent set may include both broad architectural boundaries and smaller source-to-domain policy decisions when both remain material; it should not turn implementation details, transient experiments, dependency upgrades, formatting changes, or superseded approaches into ADRs.

Run `read_medium` over the complete ADR set, PR-coverage classification, and current-code seams considered. Resolve duplicate decisions, missing counter-evidence, unsupported causal claims, and contradictions with current code. The final handoff and ADR README should include:

- the ADR index and coverage summary;
- an accountable PR-coverage table or a link to a concise generated coverage record, with exclusions and reasons;
- source anchors considered but excluded, where they were material enough to investigate;
- confidence gaps and open questions.

It must not claim complete substantive historical coverage unless the index demonstrates it.
