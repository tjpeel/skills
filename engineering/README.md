# Engineering skills

| Skill | Overview |
| --- | --- |
| [`decision-discovery`](decision-discovery/SKILL.md) | Leads an evidence-informed conversation that resolves prospective engineering decisions for later specification. |
| [`specification`](specification/SKILL.md) | Turns settled decisions into a reviewable implementation specification for later ticket decomposition. |
| [`to-tickets`](to-tickets/SKILL.md) | Turns an approved specification into dependency-ordered local Markdown tickets. |
| [`implement`](implement/SKILL.md) | Implements one ready ticket in bounded, verified increments, scrutinises adapted reference code, and runs full checks before review. |
| [`code-review`](code-review/SKILL.md) | Reviews actual runtime behaviour and the complete local diff, then checks the current delivery slice against approved intent. |
| [`testing`](testing/SKILL.md) | Selects tests for concrete coverage gaps and rejects tautological, implementation-coupled, change-detector and other weak or redundant tests. |

Use `$engineering-testing` when planning, writing or reviewing verification.
Existing coverage and verification without new tests are valid outcomes; a
new case needs a required behaviour or credible failure that current checks
do not adequately cover. Test count and coverage percentages alone do not
justify additions.

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

Discovery owns only its requested `decisions.md`; specification owns only its
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
