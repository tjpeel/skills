# Personal Codex skills

Skills live at a nested path ending in `SKILL.md`. This repository is the
source of truth; the installer creates a named manifest for each missing skill
and links its supporting resources back to the source package. Every directory
between the repository root and a skill is included in its source name.

## Public-release gate

This repository may be made public. No sensitive or internal information may be
committed: credentials, tokens, private keys, connection strings, personal or
customer data, private URLs or hostnames, internal repositories or paths,
non-public tickets or incidents, or screenshots containing private data.

Before every commit, review the complete diff and run:

```zsh
scripts/check-public-content
```

The check detects common secret formats; it does not replace a deliberate
human review of every changed skill, supporting file, and example.

## Install missing skills

```zsh
./scripts/install-codex-skills --prefix tjpeel ~/.codex/skills
```

`--prefix` is required and must use lowercase letters, digits, and hyphens. It
is included in every installed skill name. A skill at `pr/review/SKILL.md`
installed with `--prefix tjpeel` becomes:

```text
~/.codex/skills/tjpeel-pr-review/
```

Its generated manifest declares `name: tjpeel-pr-review`, so invoke it as
`$tjpeel-pr-review`. The target defaults to `~/.codex/skills`, so this shorter
command is equivalent:

```zsh
./scripts/install-codex-skills --prefix tjpeel
```

## Check current state

```zsh
./scripts/install-codex-skills --prefix tjpeel --check ~/.codex/skills
```

`--check` exits non-zero for missing or conflicting skills. The default
`--install` mode adds only missing skills. It never replaces, removes, moves, or
otherwise changes an existing path; resolve conflicts and remove obsolete
definitions yourself before running it again. In particular, it leaves old
`personal--*` installs in place. Restart Codex after installation so it reloads
the skill catalogue.

## Refresh installed skills

Run the separate uninstaller followed by the installer whenever an existing
package changes:

```zsh
./scripts/uninstall-codex-skills --prefix tjpeel ~/.codex/skills
./scripts/install-codex-skills --prefix tjpeel ~/.codex/skills
```

The uninstaller removes only this repository's current package names for the
specified prefix; it does not glob-match the shared skill directory, so it
cannot remove another catalogue whose prefix begins the same way. Run it before
renaming or removing a source package, then install the revised catalogue.

## Test the installer

```zsh
tests/test-install-codex-skills
```

This temporary-directory check covers grouped-skill discovery, generated
prefix-qualified names, linked resources, uninstall-then-install refreshes,
repeat installation, and conflicts.

Each package includes `agents/openai.yaml`. During installation, its
`display_name` and default prompt are rendered with the installed
prefix-qualified skill name; the generated `SKILL.md` name uses that same
value. The installer never changes existing installed folders; use the explicit
uninstaller before reinstalling to adopt new metadata.
