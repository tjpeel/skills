# Ownership and delegation

The invoking skill sets the task, authority and permitted paths. Work directly
when the task is small, delegation adds no value and the coordinator's settings
fit. Delegate substantial routine work when a cheaper model or lower effort can
handle it reliably.

## Classify the responsibility

Choose access, model capability and effort separately, based on the evidence,
ambiguity, constraints and judgement required. Do not infer them from the lead's
settings, role title or diff size. Skill-specific profiles are starting points,
not fixed effort requirements.

For Claude, use Sonnet for ordinary mapping, implementation, factual checks and
bounded analysis with an established approach; interacting cases may warrant
high effort. Use Opus for difficult ambiguity, competing designs, cross-cutting
constraints or synthesis; a short judgement may need only low or medium effort.
These guidelines imply neither measured equivalence nor guaranteed performance.

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

Replace `<band>` with the selected effort. `read_deep` retains `read_max` settings;
`read_exceptional` retains `read_xhigh` settings. Unqualified Claude names select Sonnet.
This catalogue has only Sol profiles for Codex; do not invent another model or
assume Claude profiles can spawn there.

Record each handoff's responsibility, access, model, effort, selection evidence
and completion condition. Justify Opus or higher effort. Preserve user model
restrictions and skill authority. SDLC lead flags configure the lead; installed
profiles configure delegates. Skills do not change the coordinating chat's
settings. The agents catalogue's `model-policy` generates explicit selections;
it neither classifies tasks nor needs invoking at skill runtime. Both Claude
families must be installed to select between them.

## Reassess and transfer ownership

Choose suitable capability upfront; changing it requires no failed attempt,
extra reviewer or approval merely for that choice. A delegate exceeding its
capability returns the unresolved question, evidence, completed work and
recommended model or effort. Do not repeat unchanged attempts.

A Sonnet lead may escalate difficult work to Opus. An Opus lead should delegate
routine work to Sonnet. Reassess at phase boundaries and return mechanical
follow-through to cheaper settings once the hard question is resolved. Avoid
handoff costs that exceed a tiny task's benefit.

The coordinator owns reassignment. Stop or wait for the writer before transferring
its paths and artifact state; never create competing writers. Supply the unresolved
evidence packet rather than the transcript. Reuse an owner only when its model,
effort and permissions fit: prompt text cannot change a pinned profile.

If an API supports explicit model/effort overrides for an equivalent bounded role,
check its interface and context requirements; otherwise use the installed declared
name. Verify exposed settings and disclose unknown ones. Direct fallback retains
the coordinator's settings; do not call it Sonnet or low without evidence.

## Separate observation from repair

Use Sonnet low in Claude or Sol low in Codex for sustained observation and factual
log collection. Observers return facts and make no repairs. Grade diagnosis and
repair separately: a hard investigation may yield a clear low-effort fix. Commands
that generate files need writer or coordinator authority. Keep commits and external
writes with the coordinator under the skill's permissions; return to low observation
after repair.

Standard speed is policy intent, not a model/effort-derived service tier. Add no
unsupported fields. Claude Fast supports selected Opus models and may use paid
credits; do not switch Sonnet to Opus just for speed. Use supported client controls
and disclose incompatible choices.

## Discover before falling back

Profiles are custom agents, not skills. Check the live spawning tool for declared
names, such as `read_opus_medium`; skill-catalogue absence proves nothing.

If Codex availability is unclear, inspect the active user agents directory
(`${CODEX_HOME:-$HOME/.codex}/agents`) and the selected repository's `.codex/agents`.
Include symlinked TOML files, which plain `rg --files` may omit:

```sh
find "${CODEX_HOME:-$HOME/.codex}/agents" -maxdepth 1 -name '*.toml' -print
```

Read name, model, effort and access through links and follow active `config_file`
registrations. Search no unrelated repositories or archives. In Claude, inspect
configured subagents and their declared settings.

Attempt the bounded handoff when the tool advertises the selected profile. A
readable definition does not prove it can spawn or access its model. Distinguish
runtime rejection from missing/unreadable configuration; do not retry unchanged,
guess filename aliases or edit configuration.

Use an equivalent explicitly supported capability if available. Otherwise report
the unavailable model/effort and actual fallback. Preserve access boundaries and
user model restrictions. Work directly only within the lead's authority and ability;
return a blocker if those are insufficient. Disclose non-independent review and
never claim equivalent completion without evidence.

## Keep handoffs bounded

Give each delegate its question, selected inputs, model/effort, constraints, permitted
paths, required evidence or output and completion condition. Use a small task
packet instead of the full conversation where supported. Before adding an owner,
identify the unanswered question and why existing evidence or ownership cannot
resolve it efficiently. Do not repeat completed investigation. Wait for required
results and inspect artifacts before accepting completion.

Read-only delegates return evidence. One local writer owns its assigned paths,
preserves unrelated edits and returns changed files and verification. Keep user
questions, scope decisions, commits and external writes with the coordinator under
the invoking skill's authority.
