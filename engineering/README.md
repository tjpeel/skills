# Engineering skills

| Skill | Overview |
| --- | --- |
| [`architecture-survey`](architecture-survey/SKILL.md) | Finds and ranks evidence-backed architectural refactoring opportunities before work is selected. |
| [`simplification`](simplification/SKILL.md) | Removes unnecessary code, indirection and state in a selected area while preserving observable behaviour. |
| [`investigation`](investigation/SKILL.md) | Traces an observed failure or regression and distinguishes supported causes before a repair is chosen. |
| [`decision-discovery`](decision-discovery/SKILL.md) | Leads an evidence-informed conversation that resolves prospective engineering decisions for later specification. |
| [`specification`](specification/SKILL.md) | Turns settled decisions into a reviewable implementation specification for later ticket decomposition. |
| [`to-tickets`](to-tickets/SKILL.md) | Turns an approved specification into dependency-ordered local Markdown tickets. |
| [`implement`](implement/SKILL.md) | Implements one ready ticket in bounded, verified increments, scrutinises adapted reference code, and runs full checks before review. |
| [`code-review`](code-review/SKILL.md) | Reviews actual runtime behaviour and the complete local diff, then checks the current delivery slice against approved intent. |
| [`testing`](testing/SKILL.md) | Selects tests for concrete coverage gaps and rejects tautological, implementation-coupled, change-detector and other weak or redundant tests. |
| [`verification`](verification/SKILL.md) | Checks actual outcomes and safety assumptions, identifies the tested artifact, and reports evidence and unresolved criteria. |

## Using the workflow

Start with the skill that matches the work you have. Use the full sequence
when consequential decisions and work spanning several sessions need explicit
handoffs. A small, settled change can go from an approved specification
straight to implementation.

| What you have | Start with | Supply |
| --- | --- | --- |
| An existing codebase with no improvement selected | `$engineering-architecture-survey` | A target area, pain point or request for a broader survey. |
| A selected area to simplify without changing behaviour | `$engineering-simplification` | The subsystem, files or diff, relevant constraints and existing checks. |
| An observed failure, regression or runtime discrepancy | `$engineering-investigation` | The symptom, selected repositories or environment, and available triggering or comparison evidence. |
| An outcome with unresolved design choices | `$engineering-decision-discovery` | The proposed change, constraints and selected evidence. |
| Settled decisions needing an implementation contract | `$engineering-specification` | The decision handoff or current conversation, and a work reference. |
| An approved specification spanning several implementation sessions | `$engineering-to-tickets` | The exact saved specification path. |
| A ready ticket or small approved specification slice | `$engineering-implement` | The exact ticket path or explicitly bounded specification slice. |
| An existing change needing review | `$engineering-code-review` | The fixed point for the diff and any selected ticket or specification. |
| A test plan or suite needing a coverage assessment | `$engineering-testing` | Required behaviour, credible failures and the relevant existing checks. |
| A completion claim needing evidence | `$engineering-verification` | The selected artifact, required outcomes and available check results. |

The prompts below use source skill names. In either provider, use installed
names derived from your chosen prefix; see
[how to invoke a skill](../docs/installation.md#invoke-a-skill). If a skill is
not loaded, ask the agent to read its selected `SKILL.md` and apply the workflow
directly.

For maintenance discovery, start with a survey:

```text
Use $engineering-architecture-survey to examine the installer and its callers.
Find refactors that would reduce coordinated changes or difficult verification.
Rank the candidates by benefit, effort and risk, with source evidence.
```

The survey returns a shortlist without modifying code or settling its design.
Select a candidate before implementing it. Use `$engineering-simplification`
for a bounded change that preserves behaviour; use decision discovery when
consequential choices remain unresolved. Request a saved report only when
another session needs it; Markdown is the default, with HTML available when
requested.

For a selected simplification, go directly to the local change:

```text
Use $engineering-simplification on the selected command parser and its callers.
Remove unnecessary forwarding and duplicated validation where the evidence
supports it. Preserve public behaviour and verify with the existing checks.
```

Simplification pins the existing contract, checks whether proposed removals
are safe, then makes and verifies the smallest worthwhile change. It can
conclude that no change earns its cost. Existing coverage can be sufficient;
line counts and one-caller wrappers alone do not justify edits. It needs no
process folder or new specification for a settled local refactor. Follow
repository commit instructions and request publication separately.

For a runtime problem, start with `$engineering-investigation`. It establishes
the relevant running artifact, traces the affected path and separates facts
from hypotheses. Existing checks and comparable controls guide the next
action. It returns evidence for a repair or a consequential design choice;
it does not require the full planning sequence merely to investigate a bug.

```text
Use $engineering-investigation to investigate this write operation: it
succeeds with the local defaults but fails with strict validation enabled.
Use the supplied local reproducer and configurations. Check the actual
execution path and distinguish supported causes from unresolved hypotheses.
```

Investigation returns findings and the smallest supported next action in the
conversation. A repair needs its own authority or an existing request that
includes it. Scratch evidence stays in an owned temporary directory; live
data changes and deployments are outside an investigation-only request.

For example, adding a check for broken local skill links could use work
reference `link-check`:

1. Resolve the decisions. Request a saved handoff when another session will
   need it; otherwise discovery can stay in the conversation.

   ```text
   Use $engineering-decision-discovery for work reference link-check.
   Explore a small check for broken local links in this skills catalogue.
   Settle its scope, expected results and verification. Save the settled handoff.
   ```

2. Write the specification from the selected decisions.

   ```text
   Use $engineering-specification with
   .sdlc/work/link-check/decisions.md for work reference link-check.
   Write the implementation specification with observable acceptance criteria.
   ```

3. Review the saved specification, then explicitly approve it and request
   decomposition if separate tickets would help.

   ```text
   I approve .sdlc/work/link-check/specification.md.
   Use $engineering-to-tickets on that specification to create small,
   independently verifiable tickets.
   ```

4. Select one ticket whose blockers are complete. Replace the placeholder
   with the exact path returned by ticket decomposition.

   ```text
   Use $engineering-implement on <exact-ready-ticket-path>.
   Implement that ticket in verified increments and finish with code review.
   ```

For the smaller route, approve the saved specification and invoke
`$engineering-implement` with its exact path and the slice to deliver. A work
reference identifies a folder; it does not select every input inside it.
Select each later ticket explicitly once its blockers are complete.

When explicitly requesting a dependent series, supply the selected tickets
and intended dependency order. The coordinator launches one implementation
unit at a time with its predecessor revision, destination branch, review
boundary and PR base. Independent roots start from updated `main`; a child
starts from its verified predecessor. Parent repairs make affected children
stale until the repaired content is carried through and reverified. Branch
state belongs in the launch context, rather than maintained local tickets.

```text
Coordinate implementation of <selected-parent-ticket-path> followed by
<selected-child-ticket-path>, one ticket per invocation. Use the parent's
verified delivered revision for the child's launch and its branch as the
intended PR base. Carry any parent repair through the selected child and
reverify the affected content. Finish with verified local commits.
```

Implementation already applies testing and verification guidance and invokes
code review after its checks. You do not need a separate prompt for each.
Use those skills directly for a focused test assessment, evidence audit or
review of an existing change. For a standalone review, supply the original
commit or other fixed point so the review covers the intended diff.

Planning stages save local, ignored process inputs. Implementation creates
verified local commits according to repository instructions. Request pushing,
PR creation or tracker updates separately. For another checkout, use the
selected-input handoff described under [Local work folders](#local-work-folders).

If the request also includes publishing and monitoring, implementation hands
off to `$pr-manage` and `$pr-monitor` within that authority. The latter checks
the current published SHA through the requested terminal results, and repairs
only when authorised. A local pass or initial check lookup does not complete
that delivery request. Merge and history-rewrite authority remain separate.
See the [PR workflow](../pr/README.md#using-the-workflow) for publication and
monitoring prompts, including a bounded repair-and-publish loop.

Use `$engineering-testing` when planning, writing or reviewing verification.
Existing coverage and verification without new tests are valid outcomes; a
new case needs a required behaviour or credible failure that current checks
do not adequately cover. Test count and coverage percentages alone do not
justify additions.

Use `$engineering-verification` at increment completion and during review.
Record what actually ran against which revision, the expected and observed
result, and any required checks that failed, were blocked or were not run.
Reuse existing checks and reviewers. When changing agent workflow behaviour,
the [optional evaluation cases](verification/references/evaluation-cases.md)
provide small tasks for checking agents' actions and outputs.

For a focused assessment, select the boundary rather than requesting tests
for every changed file:

```text
Use $engineering-testing to assess this change's period-eligibility rule
against the supplied contract and existing tests. Identify concrete gaps
and the checks that already protect the required outcomes.
```

```text
Use $engineering-verification to assess the supplied completion claim.
Check the current revision, whether the required assertions actually ran,
and the resulting persisted state. Report expected and observed outcomes
and any failed, blocked or unrun criterion.
```

Testing returns a coverage assessment and justified test choices. Verification
returns evidence for the selected content; it does not repair code merely
because a check exposes a defect. For a standalone local review:

```text
Use $engineering-code-review on the complete change since <fixed-point-SHA>.
Use <selected-ticket-path> as the delivery slice and resolve its linked
specification. Report actionable findings and verification limitations.
```

For changes crossing lifecycle or external-effect boundaries, discovery
settles the relevant startup, coexistence, activation, retry and recovery
states. Specification preserves their prerequisites and permitted effects;
tickets carry the slice's rows into implementation and verification. Model
only states that can change the outcome, including the point after which
reverting configuration cannot undo an effect. A common activation date or
healthy host alone does not establish those contracts.

Code is the documentation of implemented functionality. Do not generate
additional docs by default during implementation. Read the code, tests and
configuration to establish what the system does. Supporting documents should
signpost those sources and preserve knowledge they cannot convey: decision
rationale, external constraints
or domain meaning that would otherwise be lost. Do not maintain a second
description of functionality that can drift from the implementation. Use clear
names, structure and focused comments to make the code understandable.

Specifications and local tickets are uncommitted process inputs: they state
intended changes and acceptance criteria for the selected work. Do not maintain
them as ongoing documentation or refresh them after implementation. An
additional document needs an explicit request, an applicable repository
requirement or a material knowledge gap that code cannot convey. Missing ADRs,
context files or guides alone are not a reason to create them.

## Local work folders

New process files share one folder per piece of work in the invoking Git
repository:

```text
.sdlc/work/<reference>/
  architecture-survey.md # only when a saved survey report is requested
  decisions.md          # only when a saved discovery handoff is requested
  specification.md
  tickets/
    01-<short-kebab-case-title>.md
    02-<short-kebab-case-title>.md
```

The reference is an arbitrary short folder key, such as `cache`, `upload-v2`,
or `ABC-123`; it has no tracker or naming format. Preserve it exactly. The only
restrictions are those needed for one safe folder name: non-empty, neither
`.` nor `..`, no path separators or control characters, and no resolved path
outside `.sdlc/work/`. Other references can coexist without affecting the
selected task. The convention needs no SDLC runner or external tracker setup.

Each skill uses only the current request, explicitly selected process inputs,
and their directly linked relevant sources, alongside applicable repository
guidance and affected code. A reference selects a folder, not all its contents.
Do not discover intent from branch names, titles, recency, sibling work folders,
or unselected files in the same folder. Verify source claims against current
code and surface stale or conflicting intent. Delegates inherit this boundary.

Survey owns only its requested `architecture-survey.md` (or
`architecture-survey.html` when HTML was requested); discovery owns only its
requested `decisions.md`; specification owns only its
selected specification; ticket decomposition owns only its new `tickets/` set.
Check collisions at those targets, not at the whole work folder. Never overwrite
an unselected artifact, merge an existing ticket set, or migrate other work.
Implementation and review consume selected inputs without maintaining them.

Verify that process files are untracked and ignored. An existing ignore rule
may satisfy this, but a committed `.gitignore` rule is not required. Writers
use Git's local exclude file when needed, resolved with
`git rev-parse --git-path info/exclude`; preserve existing entries and leave
`.gitignore` unchanged. Never stage or commit process files. Explicitly
supplied `.specifications/` and `.tickets/` inputs remain supported during the
transition, but new files use `.sdlc/work/`. Do not search the legacy directories
or migrate their contents automatically. Durable ADRs and domain context keep
their established repository conventions and require a separate request or
applicable repository requirement.

For another checkout, ticket decomposition reports an explicit process input
list per ready ticket. Before launching a worker, the launcher or coordinator
copies only those selected inputs at the same relative paths, verifies Git
exclusion in the destination, and checks required links there. Local excludes
are not carried by a clone. Reuse byte-identical inputs and stop on differing
files, tracked targets, or incomplete input sets. Leave unrelated work untouched.
The launch message identifies the destination checkout, agreed starting commit,
selected ticket or specification slice, and exact input paths. These are
session inputs; no additional maintained handoff document is required.

Discovery establishes the domain rules and derives the guard rails from them.
Each handoff preserves those rules, observable outcomes and relevant boundary
and failure cases without relying on the previous conversation. The
specification defines acceptable intermediate states; tickets connect the
slice's contracts, prerequisites and verification for a fresh implementation
agent. Independent ready tickets can be assigned to separate agents, with one
owner per ticket and isolated checkouts. Implementation completes and verifies
one increment before beginning the next.
Review assesses the code independently of the planning assumptions, then checks
requirements. Local tickets and specifications support the agent workflow;
the code and focused comments must remain understandable to a reviewer who
does not have those files. Verify any relevant supporting document against the
code before relying on it; surface contradictions rather than treating prose
as proof of behaviour.
