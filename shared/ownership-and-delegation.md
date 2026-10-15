# Ownership and delegation

Handle small, clear tasks directly. Delegate when a bounded independent task
would improve the evidence or save time. The invoking skill defines each
delegate's responsibility and write scope; this reference defines how to
discover and select the capability.

## Grade the task and select capability

Choose the bounded responsibility and read/write scope first. Choose effort
separately from the coordinator's model or effort. Ordinary reads and clear local
changes default to **low**. A skill's named profile is a starting point for its
described task, not a requirement to run all implementations at medium or all
audits at high.

| Band | Evidence that warrants it | Native profiles |
| --- | --- | --- |
| `low` | Inventory, mapping, status observation or a clear local change. | `read_low`, `write_low` |
| `medium` | Bounded analysis or implementation with interacting cases. | `read_medium`, `write_medium` |
| `high` | Consequential judgement, substantive review or material failure risks. | `read_high`, `write_high` |
| `xhigh` | Difficult synthesis of a small, complete evidence packet. | `read_xhigh`, `write_xhigh` |
| `max` | Sustained difficult investigation or complete-diff review. | `read_max`, `write_max` |

`read_deep` is the legacy name for `read_max`; `read_exceptional` is the legacy
name for `read_xhigh`. These bands do not claim equal performance across providers.
Use a short task reason for higher effort. Select it upfront when warranted, or
escalate a specific unresolved question after new evidence. No mandatory failed
attempt, approval step, extra agent or repair-cycle gate is needed to change
bands. Preserve the assigned access boundary at every band. A writer profile
does not authorise a write or expand the invoking skill's scope.

Keep roles such as mapper, analyst, reviewer and writer in the handoff. The
common model policy defaults to `gpt-6.1-sol` for Codex and
`claude-sonnet-5-5` for Claude Code at every band. Higher effort does not select
Opus automatically. An explicit Opus choice needs a compatible native profile
such as `read_opus_high`, or a documented runtime override. Model choice stays
separate from responsibility, effort, permissions and speed.

Use named variants where the client requires them. A spawning API may support
explicit model/effort overrides for an equivalent bounded role; inspect its
actual interface. This app requires fresh context for overrides. Do not assume
native clients universally support per-call changes, or that prompt text changes
a pinned model or effort. Report actual settings when exposed; otherwise leave
them unverified. A skill does not change the coordinating chat's settings.

Standard speed is the policy default. Generated profiles do not assert an
unsupported speed field. Codex's official config supports `service_tier`, but
live effective settings may be unknown. Claude Fast uses paid usage credits and
supports selected Opus models; do not silently switch Sonnet to Opus to satisfy
a Fast request. Use the active client's documented controls and report an
incompatible selection before taking a different model route.

## Size observation and repair separately

Use low for sustained status observation and factual log collection. A quick
read can stay with the coordinator. Diagnose a bounded failure at medium when
interpretation is needed; consequential or difficult causes can warrant high
or a higher band. Grade the repair itself: a clear scoped edit stays low,
interacting changes can warrant medium, and difficult implementation can need
higher effort without changing ownership or permitted paths.

An observer returns facts and does not design or implement fixes. Reuse an
existing owner whose effort and write scope fit; do not create competing
writers. Test commands that generate files need the writer's or coordinator's
permitted write scope. Keep commits and external writes with the coordinator,
then return to low observation for the newly published revision.

If a new band profile is unavailable, an existing compatible profile can serve
the same bounded task. For example, `write_medium` can cover a missing
`write_low`; disclose that it retains medium effort. Use discovery below before
declaring a profile unavailable. Direct fallback retains the coordinator's
settings and cannot be described as low unless verified.

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
