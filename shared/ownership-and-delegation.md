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

| Band | Evidence that warrants it |
| --- | --- |
| `low` | Inventory, mapping, status observation or clear local change. |
| `medium` | Bounded analysis or implementation with interacting cases. |
| `high` | Consequential judgement, substantive review or material failure risks. |
| `xhigh` | Difficult synthesis of a small, complete evidence packet. |
| `max` | Sustained difficult investigation or complete-diff review. |

Read the applicable CLI guide for model choices, profile names and discovery:

<!-- cli:codex -->
- [Codex](cli/codex.md)
<!-- /cli -->
<!-- cli:claude -->
- [Claude Code](cli/claude.md)
<!-- /cli -->
<!-- cli:opencode -->
- [OpenCode with Synthetic](cli/opencode.md)
<!-- /cli -->

Record each handoff's responsibility, access, model, effort, selection evidence
and completion condition. Justify a stronger model or higher supported effort.
Preserve user model restrictions and skill authority. SDLC lead flags configure the lead; installed
profiles configure delegates. Skills do not change the coordinating chat's
settings. The agents catalogue's `model-policy` generates explicit selections;
it neither classifies tasks nor needs invoking at skill runtime. Report unsupported
effort settings as unavailable.

## Reassess and transfer ownership

Choose suitable capability upfront; changing it requires no failed attempt,
extra reviewer or approval merely for that choice. A delegate exceeding its
capability returns the unresolved question, evidence, completed work and
recommended model or effort. Do not repeat unchanged attempts.

Reassess at phase boundaries and return routine follow-through to cheaper
settings when supported. Avoid handoff costs that exceed a tiny task's benefit.

The coordinator owns reassignment. Stop or wait for the writer before transferring
its paths and artifact state; never create competing writers. Supply the unresolved
evidence packet rather than the transcript. Reuse an owner only when its model,
effort and permissions fit: prompt text cannot change a pinned profile.

If an API supports explicit model/effort overrides for an equivalent bounded role,
check its interface and context requirements; otherwise use the installed declared
name. Verify exposed settings and disclose unknown ones. Direct fallback retains
the coordinator's settings; do not relabel its model or effort without evidence.

## Separate observation from repair

Use the least sufficient supported profile for observation and factual log
collection. Observers return facts and make no repairs. Grade diagnosis and
repair separately. Commands that generate files need writer or coordinator
authority. Keep commits and external writes with the coordinator under the
skill's permissions. Standard speed is policy intent, not an asserted service
tier; use only supported client controls.

## Discover before falling back

Profiles are custom agents, not skills. Inspect the active CLI's agent tool and
the discovery paths in its guide. Skill-catalogue absence proves nothing.
Search no unrelated repositories or archives.

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
