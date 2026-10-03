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

Where a skill needs delegation, document its platform-neutral bounded
responsibilities and permitted write scope in `SKILL.md`. Keep common profile
selection, discovery, ownership and fallback rules in
[shared/ownership-and-delegation.md](shared/ownership-and-delegation.md).
Read that guide before choosing a profile or declaring one unavailable.

Each delegating skill must route to its local
`references/ownership-and-delegation.md` before delegation. In source packages,
that file is a relative symlink to the shared guide. Both installers copy
references with symlinks resolved, so installed skills contain the guide and
do not depend on a catalogue-wide file at runtime. Keep task-specific handoffs
in the skill; do not duplicate the shared rules there.

## Catalogue boundaries

Keep each skill self-contained. A skill must not require another catalogue's
setup command, tracker configuration, labels, or naming scheme. When a skill
creates local artifacts in the invoking repository, document the exact
location, safe naming rules, ownership, and overwrite behaviour in its
`SKILL.md`.

## Sources and attribution

Credit public sources that materially informed skills in this catalogue in the
root README. Keep that credit at catalogue level when a skill must remain
self-contained, rather than retaining another catalogue's skill references or
setup assumptions in its `SKILL.md`.

The engineering decision-discovery, specification, and to-tickets skills were
informed by the public [mattpocock/skills](https://github.com/mattpocock/skills)
repository.

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
