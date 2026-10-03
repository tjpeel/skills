# Personal agent skills

Reusable workflows for building software, managing pull requests, recovering
architecture decisions, handing off work and editing prose. Start with the
skill that matches the task; each group explains its inputs and handoffs.

## Choose a workflow

| Group | Use it to |
| --- | --- |
| [Engineering](engineering/README.md#using-the-workflow) | Investigate failures, find refactors, simplify code, settle decisions, specify work, implement and verify it. |
| [Pull requests](pr/README.md#using-the-workflow) | Draft, publish, monitor, review or reproduce PRs, and process Dependabot updates. |
| [Architecture](architecture/README.md#using-the-workflow) | Recover retrospective ADRs from code and history. |
| [Productivity](productivity/README.md#using-the-workflow) | Prepare a compact handoff for another session. |
| [Writing](writing/README.md#using-the-workflow) | Make supplied prose direct and specific while preserving its meaning and voice. |

## Install

Run from this repository and select the provider:

```zsh
# Codex
./scripts/install-skills --provider codex --prefix tjpeel

# Claude Code
./scripts/install-skills --provider claude --prefix tjpeel
```

Both providers use the same prefix and packaging rules. The installer adds
missing packages and leaves existing paths untouched. Remove packages with
`./scripts/uninstall-skills --provider codex --prefix tjpeel`, substituting
`claude` for Claude Code.
See [installation and refresh](docs/installation.md) for names, custom
targets, conflict checks and updating an installed catalogue.

The source packages use the open `SKILL.md` format. Workflows require the
repository, command or service access named in their instructions. Bounded
delegation falls back to the coordinating agent when an equivalent configured
capability is unavailable.

## Maintain the catalogue

This repository is the source of truth. Keep source names prefix-free and
follow [the repository conventions](AGENTS.md). The
[maintenance guide](docs/maintenance.md) covers packaging, validation and the
public-release gate. Review every changed file for sensitive information and
run `scripts/check-public-content` before committing.

## References

Inspired by these public repositories:

- [cursor/plugins](https://github.com/cursor/plugins)
- [mattpocock/skills](https://github.com/mattpocock/skills)

Skill packaging and profile discovery also draw on OpenAI's
[skill documentation](https://learn.chatgpt.com/docs/build-skills) and
[custom agent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents).
