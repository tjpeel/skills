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
