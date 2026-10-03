---
name: engineering-simplification
description: Simplify a selected area of existing code by removing unnecessary code, indirection and state while preserving observable behaviour. Use for scoped simplification, dead-code removal or reducing complexity; not for a broad architecture survey, feature retirement or review-only work.
---

# Engineering simplification

Make the selected code easier to understand and safely change. Look for
subtraction before introducing a replacement: whole branches, helpers,
duplicated decisions, compatibility paths or mutable relationships that no
longer earn their cost. A supported finding that no worthwhile change exists
is a valid result.

Judge the result by the concepts, indirections and state a reader must track.
Fewer lines or files can support that judgement, but do not establish it.
Moving complexity into callers, hiding it behind clever syntax or replacing
clear repetition with a generic framework is not a simplification.

## Platform compatibility

Use this workflow in Codex, Claude Code or another environment with equivalent
repository and command access. Follow applicable `AGENTS.md` or `CLAUDE.md`
guidance. Invoke source skills named with `$` where supported; otherwise read
their `SKILL.md` and apply the relevant guidance directly. No tracker,
catalogue setup or model-specific orchestration is required.

## Establish the scope and contract

Use the requested subsystem, files or explicitly selected diff. When the area
is implicit, establish a bounded scope from the request and current change,
then state it before editing. Use `$engineering-architecture-survey` for a
broader search for worthwhile refactors. A request to simplify authorises
local implementation within the selected scope, not retiring user-visible
features or publishing the change.

Read applicable constraints and relevant existing decisions. Use only process
inputs explicitly selected for this task and their directly linked relevant
sources; do not infer intent from branch names or scan neighbouring work
folders. Identify the starting revision and relevant pending changes, and
preserve edits owned by others.

Trace the affected behaviour through its entry points, callers, data and
effects. Establish the contract to preserve: relevant outputs, errors,
external interfaces and side effects, including ordering, resource ownership
or performance when those affect callers. Compare documented claims with the
current implementation and surface meaningful contradictions.

Pin that contract before restructuring. Run existing checks that observe the
relevant behaviour before editing. Fill a concrete gap with a small
characterisation test, recorded baseline or equivalence check; do not add
tests merely because files change. Type checks and lint establish structural
guarantees, not behavioural equivalence. Apply `$engineering-testing` when
selecting or changing tests.

Keep discovered defects or requested behavioural changes distinct from the
simplification. Do not silently redefine the pinned contract to make a
cleanup pass. Resolve consequential unsettled choices through
`$engineering-decision-discovery`; routine local choices need no planning
handoff or new specification.

## Identify worthwhile removals

For each credible candidate, identify the burden it removes, evidence that
its purpose is unnecessary or can be preserved more directly, and the
cheapest check that could disprove the proposal. Compare it with leaving the
code alone and with a smaller local change. Investigate only uncertainties
that can change the decision. Leave candidates with unresolved usage or
safety assumptions unchanged, report the gap and continue supported changes.

- **Unused code and dependencies:** trace entry points, public exports,
  dynamic lookup, configuration, scripts, build paths and import or
  registration effects where relevant. Check consumers outside the selected
  repository and deployed versions when compatibility depends on them. A
  search with no callers is evidence, not proof of disuse. Do not remove a
  published API, persisted migration or dependency merely because local
  application code does not reference it.
- **Layers and wrappers:** collapse forwarding that hides no useful decision.
  One caller or one implementation alone does not justify deletion. Preserve
  boundaries that provide adaptation, policy, ownership, compatibility,
  security or resource isolation; name what would move into callers.
- **Repeated validation and fallbacks:** remove them only after establishing
  where the invariant is enforced for every relevant path. Keep necessary
  runtime checks at trust boundaries. Static types alone do not establish
  that external, persisted or mutable data satisfies the invariant.
- **Duplicated rules and branches:** consolidate a decision at its owner or
  use a data structure that makes the existing domain clearer. Keep local,
  explicit repetition when extracting it adds more reader work than it saves.
  Do not invent a framework for hypothetical future uses.
- **Mutable state:** derive values instead of synchronising copies, narrow
  scope and remove unnecessary sharing when the contract permits it. Check
  ordering, identity, lifetime and cost before replacing stored state.
- **Legacy internal APIs:** inventory callers, migrate them and remove the
  old path together when consumer ownership and deployment or rollback
  constraints allow it. Otherwise retain the smallest necessary transition
  and state the condition for its later removal.
- **Comments and tests:** remove stale narration, commented-out code and
  redundant implementation assertions within scope. Preserve rationale,
  public contracts, external constraints, legal notices and distinct
  behavioural guarantees. Never weaken a test to accommodate a regression.

## Make and verify the smallest worthwhile change

Choose the candidate supported by the evidence and worth its cost. Remove
independent dead weight first when that leaves a verifiable state; keep
coupled caller migrations and their replacement together. Prefer focused
steps that preserve the pinned contract over a speculative rewrite. Update
relevant references, imports, configuration and dependency metadata so the
deletion leaves no broken wiring or orphaned resources.

Run the relevant checks after each meaningful step and the full checks
required by the invoking repository before completion. For a substantial
reshape, compare old and new behaviour at an observable boundary, including
relevant failure paths and effects. Verify the actual generated or installed
artifact when that is what consumers use. Apply `$engineering-verification`
to the evidence; report failed, blocked or unrun checks accurately.

Inspect the complete diff from the starting point. Confirm where reader work
decreased and whether complexity moved elsewhere. Discard speculative edits
that do not repay their cost, reverting only changes owned by this task.
Do not broaden cleanup to unrelated code or silently repair a pre-existing
failure. Follow repository instructions for commits; pushing, PR creation and
external writes require their own authority.

## Ownership and delegation

Handle a small, clear local change directly. A representative non-trivial
case is removing an internal adapter used across several packages, with
dynamic registration and independent test paths: bounded mapping and a fresh
contract audit can expose assumptions the writer missed.

Use the least sufficient configured capability. In Codex use the installed
profiles below; in Claude Code use an equivalently bounded configured
subagent when available. If unavailable, perform the responsibility directly
instead of substituting a broader built-in role.

- `read_low` maps specified callers, effects, dependencies and existing checks,
  returning source anchors and unresolved usage without proposing a rewrite.
- `write_medium` is the sole local writer for explicitly owned source, test
  and configuration paths. Give it the pinned contract, selected candidate,
  constraints and required checks; it must preserve others' edits.
- `read_medium` audits the completed diff and raw verification evidence
  against the contract, identifying moved complexity or missed consumers.
- `read_high` investigates a credible material security, data-loss,
  concurrency or compatibility risk that cheaper checks cannot settle.

Parallelise independent mapping, not competing edits to the same code. The
coordinator owns scope, candidate selection, user decisions, commits and
external writes. A writer's completion message does not replace inspection
of its diff and checks.

## Local artifacts and result

Edit existing source, tests and configuration in their established locations
within the selected repository. Create a permanent test only at its existing
test seam and naming convention for a distinct coverage gap. Name any new
source or test path in the scope before writing; preserve unrelated edits and
do not overwrite or regenerate unselected files. Do not create a report,
process folder or maintained description of the implementation by default.

For a temporary equivalence harness or baseline, create one exclusively owned
directory with `mktemp -d "${TMPDIR:-/tmp}/engineering-simplification.XXXXXX"`.
Use fixed children `run/` for fixture copies and `evidence/` for commands,
outputs and baselines. Never copy secrets or live data into a fixture, reuse
another run's directory or overwrite its evidence. Retain it through the
handoff and report its exact path when it supports a claim. Clean up only
that owned directory after its evidence is no longer needed; do not commit
scratch artifacts.

Report what was removed or reshaped, the reader work it eliminated, the
contract held, and the checks against the actual revision or pending diff.
Include relevant limitations, retained boundaries and unresolved candidates.
If no change was worthwhile, explain the evidence without padding the result
with cosmetic edits.
