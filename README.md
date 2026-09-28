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

## Install or refresh

```zsh
./scripts/install-codex-skills --prefix personal --sync ~/.codex/skills
```

`--prefix` is required and must be unique per skills repository. A skill at
`example/SKILL.md` installed with `--prefix personal` becomes:

```text
~/.codex/skills/personal--example
```

The target defaults to `~/.codex/skills`, so this shorter command is equivalent:

```zsh
./scripts/install-codex-skills --prefix personal --sync
```

## Check current state

```zsh
./scripts/install-codex-skills --prefix personal --check ~/.codex/skills
```

`--check` exits non-zero for missing, stale, or conflicting links. `--install`
adds only missing links and refuses to overwrite anything. `--sync` removes
only symlinks whose name starts with this repository's prefix, then recreates
the links. It never removes a real file or directory.

## Migrate legacy installed skills safely

If this repository's skills were previously copied directly into the target,
archive their exact declared names before creating the prefixed links:

```zsh
./scripts/install-codex-skills --prefix personal --sync \
  --archive-name dependabot-pr-queue --archive-name draft-pr-description \
  --archive-name github-pr-management --archive-name pr-replication \
  --archive-name review-pr
```

Each named, non-symlink skill folder is moved beneath
`~/.codex/skills/.archived-skill-definitions/`; unrelated skills are left in
place. Restart Codex after installation so it reloads the skill catalogue.
