# Ownership and delegation

Handle small, clear tasks directly. Delegate when a bounded independent task
would improve the evidence or save time. The invoking skill defines each
delegate's responsibility and write scope; this reference defines how to
discover and select the capability.

## Select the capability

Use the least sufficient configured profile available in the current session:

| Profile | Responsibility |
| --- | --- |
| `read_low` | Inventories, repository mapping and quick evidence checks. |
| `read_medium` | Bounded analysis, drafting and evidence or acceptance audits. |
| `read_high` | Material risk analysis, complex planning or independent review. |
| `read_deep` | Bounded investigation or complete-diff review whose difficulty justifies maximum reasoning. |
| `read_exceptional` | A small, evidence-complete synthesis that justifies exceptional effort. |
| `write_medium` | One scoped local change as the sole writer, when the invoking skill permits it. |

A profile sets effort and access, not the task. Preserve its configured model,
reasoning and access boundaries. Finding a writer profile does not authorise a
write or expand the invoking skill's scope.

A coordinator running at Ultra or max does not make every handoff exceptional.
Use the profile's explicit effort for its bounded task. Raise effort only for
a selected task whose evidence or failed lower-effort attempt justifies it.

Keep reasoning depth separate from agent count. A difficult review can need
one strong reviewer without extra mapping or audit agents. Select `read_deep`
upfront when the task warrants it, or for an unresolved difficult question;
`read_exceptional` remains limited to synthesis from a completed evidence
packet. Client Ultra can also enable proactive delegation and is not a
portable model-effort value. Do not change pinned settings through a handoff
prompt or assume the client applied a requested model or effort. Report the
actual settings when exposed; otherwise leave them unverified.

## Size monitoring and repair phases separately

For workflows that observe checks and then repair failures, choose effort for
each phase. Sustained read-only inventory, status polling and log collection
belong with `read_low` at low reasoning. Prefer deterministic queries and
native waits; reuse one observer when repeated results need interpretation.
A single quick read can stay with the coordinator. Do not keep a higher-effort
writer or reviewer processing unchanged status results, or spawn an agent for
every poll.

When evidence identifies a failure, move its diagnosis to `read_medium` at
medium reasoning. Use `read_high` at high reasoning for a difficult root cause
or material security, behaviour or concurrency risk. A local repair and its
tests belong with `write_medium` at medium reasoning as the sole scoped writer.
The read-only observer collects facts and does not design or implement fixes.
An existing owner can retain a small repair when its effort and write scope
already fit; profile selection must not create competing writers.

Task-specific observer inputs, return conditions and write paths belong in
the invoking skill. Keep commits and external writes with the coordinator,
then give the observer the newly published revision and return to low-effort
observation. Test commands that generate files need the local writer's or
coordinator's permitted write scope; a read-only observer may inspect their
results but cannot run them by assuming they are read-only.

Report the selected profile, actual model and reasoning effort when starting
a phase, where those settings are exposed. Use the profile's pinned model;
do not hardcode model names in skills or override pinned effort in a prompt.
A skill does not change the coordinating chat's model or reasoning setting.
If a suitable observer or writer cannot be spawned, follow the discovery and
fallback rules below and disclose that direct work retains the coordinator's
settings; do not describe that fallback as low reasoning unless verified.

## Discover Codex profiles before falling back

Profiles are custom agents, not skills. Their absence from the skill catalogue
does not establish that they are unavailable.

1. Check the current agent-spawning tool and its supported agent types. Select
   the profile by its declared `name`, using the tool's `agent_type` argument
   when that is the exposed interface. Do not treat an installed filename or
   prefix as the agent name.
2. If availability is unclear, inspect the active user agent directory
   (`${CODEX_HOME:-$HOME/.codex}/agents`) and the selected repository's
   `.codex/agents`. Include symlinked TOML files: plain `rg --files` omits them.
   List top-level `*.toml` paths without a regular-file-only filter, then read
   the relevant file through its link and check its `name`, description and
   access settings. Do not search unrelated repositories or archived profiles.
   If the active configuration registers agents through `config_file`, follow
   the relevant registration instead. Read only the agent settings needed.

   For example, this lists user definitions including symlinked files:

   ```sh
   find "${CODEX_HOME:-$HOME/.codex}/agents" -maxdepth 1 -name '*.toml' -print
   ```

3. When the tool advertises the profile, attempt the actual bounded handoff.
   If spawning rejects it, distinguish that runtime rejection from a missing
   or unreadable profile file. A readable definition does not prove that the
   current session can spawn it. Do not keep retrying an unchanged request,
   guess filename aliases, or edit agent configuration as part of this skill.

In Claude Code, check the available configured subagents and use an equivalent
effort and access boundary. Do not infer availability from the skill list.
In another environment, use an equivalent explicitly supported capability.

If no equivalent can be spawned, perform the bounded responsibility in the
coordinator instead of substituting a broader built-in role. Briefly report
the observed limitation, including a runtime rejection when one occurred.
Disclose when an audit or review could not be independent.

## Keep ownership explicit

Give each delegate its question, selected inputs, constraints, permitted paths
and required evidence or output. Supply a small task packet rather than the
entire conversation when the tool supports that choice. Reuse relevant work;
do not delegate merely to repeat the coordinator's investigation.
Before adding a delegate, state the unanswered question, why existing evidence
and the owner cannot efficiently resolve it, the least sufficient profile,
and the stop condition. Wait for every required result before finalising the
handoff; incomplete work remains a limitation, not a completed assessment.

Keep user questions, scope decisions, commits and external writes with the
coordinator. Read-only delegates return evidence. A permitted local writer
owns only its assigned paths, preserves other people's edits and returns its
diff and check results. Do not run competing writers in one working tree.
Inspect the actual artifacts and results before accepting a completion claim.
