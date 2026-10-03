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

Run from this repository. Choose the command for your platform:

```zsh
# Codex
./scripts/install-codex-skills --prefix tjpeel

# Claude Code
./scripts/install-claude-skills
```

The installers add missing packages and leave existing paths untouched.
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

- The public [Cursor plugins repository](https://github.com/cursor/plugins) is
  a source of inspiration for selected skills in this catalogue.
- The engineering verification skill and its evaluation cases were informed
  by pstack's [Prove It Works](https://github.com/cursor/plugins/blob/main/pstack/skills/principle-prove-it-works/SKILL.md),
  [Blast Radius](https://github.com/cursor/plugins/blob/main/pstack/skills/blast-radius/SKILL.md)
  and [Eval playbook](https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/eval.md).
- The engineering simplification skill was informed by pstack's
  [Refactoring playbook](https://github.com/cursor/plugins/blob/main/pstack/skills/poteto-mode/playbooks/refactoring.md),
  [Laziness Protocol](https://github.com/cursor/plugins/blob/main/pstack/skills/principle-laziness-protocol/SKILL.md),
  [Subtract Before You Add](https://github.com/cursor/plugins/blob/main/pstack/skills/principle-subtract-before-you-add/SKILL.md),
  [Minimize Reader Load](https://github.com/cursor/plugins/blob/main/pstack/skills/principle-minimize-reader-load/SKILL.md)
  and [Migrate Callers Then Delete Legacy APIs](https://github.com/cursor/plugins/blob/main/pstack/skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md).
- The productivity handoff skill was adapted from the public
  [mattpocock/skills handoff skill](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md).
- The engineering decision-discovery, specification, to-tickets,
  implementation, code-review, and testing skills were informed by the public
  [mattpocock/skills](https://github.com/mattpocock/skills) repository.
- The engineering architecture survey was informed by its
  [improve-codebase-architecture](https://github.com/mattpocock/skills/blob/main/skills/engineering/improve-codebase-architecture/SKILL.md)
  and [codebase-design](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/SKILL.md)
  skills.
- The testing guidance also draws on Google's
  [Change-Detector Tests Considered Harmful](https://testing.googleblog.com/2015/01/testing-on-toilet-change-detector-tests.html)
  and the [Unit Testing chapter of Software Engineering at Google](https://abseil.io/resources/swe-book/html/ch12.html)
  for brittle interaction tests, behaviour-focused assertions and expectations
  independent of production logic. Duplicate coverage, coverage-only tests,
  speculative cases and vacuous assertions are practical categories used here
  to guide test selection, rather than a formal taxonomy from those sources.
