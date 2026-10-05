# Maintain the catalogue

Follow [AGENTS.md](../AGENTS.md) for the full repository conventions.
Installation and usage are covered in the
[installation guide](installation.md) and the
[group guides](../README.md#choose-a-workflow).

## Package a skill

Put each source package at a nested path ending in `SKILL.md`, such as
`pr/review/SKILL.md`. Every directory in the path contributes to the source
name. Keep frontmatter names and `agents/openai.yaml` metadata prefix-free;
the shared installer derives installed names from the prefix and nested path
for both providers, and sets Codex display names. Internal references use
`$source-name`; leave external and built-in references unchanged.

Keep the workflow self-contained. State its inputs, outputs, permissions and
capability fallbacks without requiring another catalogue's setup, tracker
configuration or naming scheme. If it creates local artifacts, specify their
location, safe names, ownership and overwrite behaviour. Add the skill to its
group README with a useful starting point, example and handoff.

Assess a representative non-trivial task before choosing delegation. Document
only responsibilities that improve the result, using the least sufficient
configured capability. Keep user decisions and external writes with the
coordinator unless the skill explicitly allows a bounded local writer. A
small direct workflow does not need an agent team.

Maintain common profile discovery and ownership rules in
[shared/ownership-and-delegation.md](../shared/ownership-and-delegation.md).
For a delegating skill at a two-level package path, link
`references/ownership-and-delegation.md` to
`../../../shared/ownership-and-delegation.md` and route to that local reference
from `SKILL.md` before delegation. Adjust the relative target for deeper
packages. Keep the skill's bounded responsibilities and write permissions in
its manifest. The installer resolves supporting symlinks into ordinary files;
refresh installed skills after changing the shared guide. When distributing a
source package independently, resolve its reference symlinks into local files.

## Validate a change

Read the edited instructions as a user would follow them. Check that group
examples agree with the actual skill, source references and relative links
resolve, and handoffs preserve inputs and authority. Inspect the full diff,
including new resources and metadata.

Run the installer suite in its temporary directories:

```zsh
tests/test-install-skills
tests/test-check-public-content
git diff --check
scripts/check-public-content
```

The suite covers both providers, discovery, package names, reference rewriting,
resource copies, ownership, conflicts, refresh/removal and forced legacy cleanup.
Packaging checks do not prove an agent follows a workflow.
Both test suites run without ripgrep on `PATH`. The public-content checks cover
credential detection, hidden and binary files, exclusions and scan failures.
For material changes to agent behaviour, use relevant
[evaluation cases](../engineering/verification/references/evaluation-cases.md)
when they add evidence, retaining the actual commands and outputs. Label a
direct walkthrough as unblinded and not independent.

## Public-release gate

Review every changed or added file for credentials, secrets, personal or
customer data, private URLs or hostnames, internal repositories or paths,
non-public ticket or incident details, and screenshots containing private data.
Use generic examples. Run `scripts/check-public-content` before staging or
committing and resolve every finding. The scan detects common credential
formats; a pass does not replace manual review.

Credit public sources that materially informed a skill in the
[root README](../README.md#references). Keep attribution at catalogue level
when retaining another catalogue's references would compromise a skill's
self-contained workflow.

Stage only the requested files and create a focused commit. Leave secrets,
caches and unrelated work out of the commit. Push only when requested. See
[installation and refresh](installation.md) before renaming or removing a
package so the old installed name can be removed safely.
