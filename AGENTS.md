# Personal skills repository conventions

## Skill packaging

The source package is prefix-free. Set its frontmatter `name`, metadata
`display_name`, and `default_prompt` for the source skill only. The installer
derives the installed name and UI display name from the chosen prefix and the
package's nested path.

For an internal cross-skill reference, use the source name in `$` form, such
as `$architecture-adrs`; never hard-code an installed prefix or use a display
name. The installer must build the complete source-name-to-installed-name map
and rewrite these references in installed `SKILL.md` files and metadata. It
must leave external and built-in skill references unchanged.

## Delegation profile sizing

Before adding a skill, assess a representative non-trivial use case to decide
whether delegation would materially improve the result. This is a design
check, not a blanket requirement to delegate: a small, direct workflow should
remain in the coordinating agent.

Where a skill needs delegation, document its profile choices and their bounded
responsibilities in `SKILL.md`. Use the least sufficient reusable profile from
`~/.codex/agents/`; profiles set effort and access, while the handoff supplies
the task, inputs, constraints, and output shape:

- `read_low` for inventories, repository mapping, and quick evidence checks;
- `read_medium` for bounded analysis, drafting, and evidence or acceptance
  audits;
- `read_high` for material risk analysis, complex planning, or independent
  review;
- `read_exceptional` only for a small, evidence-complete synthesis where its
  higher cost is justified; and
- `write_medium` for one scoped local artifact change, with a single writer.

Do not use a profile merely to restate the coordinator's work. Keep user
questions, decisions, and external writes with the coordinator unless the
skill explicitly authorises a bounded local writer. If a required profile is
unavailable, perform that bounded responsibility directly instead of using a
Codex built-in agent as a substitute.

## Public source references

When a skill is independently adapted from a public source, credit that source
in the skill's `References` section and in the catalogue README. Do not imply
that the source endorses this catalogue or that its content was copied without
adaptation. The engineering decision-discovery and specification skills were
developed from the design workflow in the public
[mattpocock/skills](https://github.com/mattpocock/skills) repository.

## Public-release gate

This repository may become public. Treat the absence of sensitive information
as a hard release gate for every changed or added file, including `SKILL.md`,
scripts, references, assets, metadata, examples, and documentation.

- Never add credentials, tokens, private keys, connection strings, personal
  data, private URLs or hostnames, internal repository names or paths, customer
  information, screenshots containing private data, or non-public ticket and
  incident details.
- Before staging or committing, inspect every changed file and run
  `scripts/check-public-content`. Treat any finding as a blocker until the
  content is removed or replaced with a generic placeholder.
- The automated check is a backstop, not proof that content is safe to publish;
  perform the manual review even when it passes.

- Treat changes to this repository as version-controlled deliverables.
- After modifying a skill or its supporting files, validate the change, inspect
  `git diff` and `git status`, run the public-release gate, stage only files
  relevant to the requested work, and create a focused commit unless the user
  says not to.
- Never commit secrets, generated caches, or unrelated pre-existing changes.
