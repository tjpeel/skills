# Ownership and delegation

The invoking skill defines the task, authority and permitted paths. Use this
guide to classify each bounded responsibility and select its execution profile.
Handle small tasks directly when delegation adds no value and the coordinator's
settings fit. Delegate substantial routine work away from a stronger coordinator
when a cheaper model or lower effort can do it reliably.

## Classify the work before choosing a profile

Choose access, model capability and reasoning effort independently. Base the
choice on the task's evidence, ambiguity, constraints and required judgement,
not the coordinator's current model, effort, the role title or diff size alone.
Skill-specific profile names are starting points for the described work; they
do not fix every implementation at medium or every audit at high.

For Claude, use Sonnet for ordinary mapping, clear implementation, factual
checks and bounded analysis with an established approach. Sonnet can use high
reasoning effort when interacting cases warrant it. Choose Opus when difficult
ambiguity, competing design choices, cross-cutting constraints or synthesis
warrant stronger model capability. Opus can use low or medium effort when its
capability fits a short judgement task. These are selection guidelines, not
claims of measured equivalence or guaranteed performance.

| Band | Evidence that warrants it |
| --- | --- |
| `low` | Inventory, mapping, status observation or clear local change. |
| `medium` | Bounded analysis or implementation with interacting cases. |
| `high` | Consequential judgement, substantive review or material failure risks. |
| `xhigh` | Difficult synthesis of a small, complete evidence packet. |
| `max` | Sustained difficult investigation or complete-diff review. |

| Runtime/model | Read profile | Write profile |
| --- | --- | --- |
| Codex Sol 6.1 | `read_<band>` | `write_<band>` |
| Claude Sonnet 5.5 | `read_<band>` | `write_<band>` |
| Claude Opus 5.5 | `read_opus_<band>` | `write_opus_<band>` |

Replace `<band>` with the selected band. `read_deep` retains `read_max` settings;
`read_exceptional` retains `read_xhigh` settings. Existing unqualified Claude
names select Sonnet. Codex currently has only Sol in this catalogue; do not
invent a second model or assume a Claude profile is spawnable from Codex.

A Sonnet lead may hand difficult work to Opus. An Opus lead should send routine
implementation, mapping and observation to Sonnet at suitable effort. At a phase
boundary, reassess the remaining work: a difficult design decision does not
justify keeping its mechanical follow-through on Opus or max effort. Avoid
fragmenting tiny tasks where handoff costs exceed the benefit.

For each delegation, record a short classification: bounded responsibility,
access, model, effort, evidence for that choice and completion condition. State
why Opus or higher effort is warranted when selected. Preserve explicit user
model restrictions and the invoking skill's authority. The lead's SDLC model
and reasoning flags control the lead; installed profiles control delegates.
These skills do not change the coordinating chat's settings.

Selection is driven by these skill instructions. `model-policy` in the agents
catalogue resolves explicit selections and generates installed definitions;
it does not classify tasks and is not required or called at skill runtime.
Install both Claude families before expecting either to be selectable.

## Reclassify when evidence changes

Select an appropriate model upfront when warranted; no failed attempt, approval
step or extra reviewer is required merely to change capability. If a delegate
finds unresolved ambiguity or constraints beyond its selected capability, it
returns the specific question, evidence, work completed and recommended model
or effort to the coordinator. Do not keep repeating unchanged attempts.

The coordinator owns reassignment. Stop or wait for the current writer before
transferring its permitted paths and artifact state to another writer. Supply
the unresolved evidence packet, not the entire transcript. Do not create
competing writers. Reuse an existing owner only when its model, effort and
permissions fit; prompt text cannot change a pinned profile. When the hard part
is resolved, return routine follow-through to a cheaper profile or lower effort.

An available API may support explicit model/effort overrides on an equivalent
bounded role; inspect its actual interface and context requirements. Otherwise
spawn the installed declared name. Verify exposed settings and disclose unknown
ones. If a selected model or effort cannot be spawned, report the rejection or
missing capability and actual fallback. Direct work retains the coordinator's
settings; do not label it Sonnet or low without evidence.

## Size observation and repair separately

Use Sonnet low in Claude, or Sol low in Codex, for sustained status observation
and factual log collection. Observers return facts and do not implement fixes.
Grade diagnosis separately from repair: a clear fix can stay low even after a
hard investigation. Test commands that generate files need writer or coordinator
write authority. Keep commits and external writes with the coordinator under
the invoking skill's permissions, then return to low observation as appropriate.

Standard speed is policy intent. Do not infer service tier from model or effort
or add unsupported native fields. Claude Fast supports selected Opus models and
may use paid credits; do not switch Sonnet to Opus merely to satisfy a speed
request. Use supported client controls and disclose incompatible choices.

## Discover profiles before falling back

Profiles are custom agents, not skills. Their absence from a skill catalogue
says nothing about spawning availability. Check the live spawning tool and use
the declared `name`, such as `read_opus_medium`, rather than a prefixed filename.

In Codex, if availability is unclear, inspect the active user agent directory
(`${CODEX_HOME:-$HOME/.codex}/agents`) and the selected repository's `.codex/agents`.
Include symlinked TOML files; plain `rg --files` can omit them:

```sh
find "${CODEX_HOME:-$HOME/.codex}/agents" -maxdepth 1 -name '*.toml' -print
```

Read relevant name, model, effort and access fields through links. If active
configuration uses `config_file` registrations, follow the relevant registration.
Do not search unrelated repositories or archived profiles. In Claude, inspect
available configured subagents and the relevant declared names and settings.

Attempt the actual bounded handoff when the tool advertises the selected
profile. If it rejects the request, distinguish runtime rejection from a missing
or unreadable file. Do not retry the unchanged request, guess filename aliases,
or edit configuration as part of a skill. A readable profile does not prove
that the current session can spawn it or access its configured model.

Use an equivalent explicitly supported capability when available. Otherwise,
report the selected model/effort that could not be used and the actual fallback
settings. Continue directly only within the coordinator's authority and ability;
if the unresolved problem exceeds that ability, return the blocker rather than
claiming equivalent completion. Disclose when review could not be independent.
Never silently substitute a broader access boundary or override a user model
restriction.

## Keep ownership explicit

Give each delegate its question, selected inputs, model and effort choice,
constraints, permitted paths, required evidence or output and completion condition.
Use a small task packet rather than the entire conversation where supported.
Do not delegate merely to repeat completed investigation. Before adding another
owner, identify the unanswered question and why the existing evidence and owner
cannot resolve it efficiently. Wait for required results before finalising.

Read-only delegates return evidence. One permitted local writer owns its assigned
paths, preserves unrelated edits and returns changed files and verification.
Keep user questions, scope decisions, commits and external writes with the
coordinator under the invoking skill's authority. Inspect artifacts and results
before accepting a delegate's completion claim.
