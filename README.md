# Personal Codex skills

Each direct child folder containing `SKILL.md` is a Codex skill. This repository
is the source of truth; the installer exposes skills through named symlinks.

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
./scripts/install-codex-skills --prefix personal ~/.codex/skills
```

`--prefix` is required and must be unique per skills repository. A skill at
`example/SKILL.md` installed with `--prefix personal` becomes:

```text
~/.codex/skills/personal--example
```

The target defaults to `~/.codex/skills`, so this shorter command is equivalent:

```zsh
./scripts/install-codex-skills --prefix personal
```

## Check current state

```zsh
./scripts/install-codex-skills --prefix personal --check ~/.codex/skills
```

`--check` exits non-zero for missing or conflicting links. The default
`--install` mode adds only missing links. It never replaces, removes, moves, or
otherwise changes an existing path; resolve conflicts and remove obsolete
definitions yourself before running it again. Restart Codex after installation
so it reloads the skill catalogue.
