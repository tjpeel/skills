# Installation and refresh

Run the commands below from the repository root. The installers discover each
nested package ending in `SKILL.md`; choose an absolute target directory or
use the platform default. See the [workflow catalogue](../README.md#choose-a-workflow)
to select a skill after installation.

## Install in Codex

```zsh
./scripts/install-codex-skills --prefix tjpeel
```

The target defaults to `~/.codex/skills`. `--prefix` is required: start it with
a lowercase letter or digit, then use lowercase letters, digits and hyphens.
To supply a target explicitly:

```zsh
./scripts/install-codex-skills --prefix tjpeel ~/.codex/skills
```

The installer combines the prefix with every directory in the package path.
For example, `pr/review/SKILL.md` becomes
`~/.codex/skills/tjpeel-pr-review/`, with manifest name `tjpeel-pr-review`.
Restart Codex after installation so it reloads the catalogue.

### Check current state

```zsh
./scripts/install-codex-skills --prefix tjpeel --check
```

`--check` exits non-zero for missing or conflicting packages. Default
`--install` mode adds only missing packages. It never replaces, removes or
moves an existing path; resolve conflicts before running it again. Old
`personal--*` installations remain in place.

### Refresh or remove

Uninstall the current package names, then install the revised catalogue:

```zsh
./scripts/uninstall-codex-skills --prefix tjpeel
./scripts/install-codex-skills --prefix tjpeel
```

Use the same prefix and target for both commands. The uninstaller removes
only names derived from this repository's current package paths for that
prefix. It does not glob-match other catalogues. Run it before renaming or
removing a source package, while the old path is still present; otherwise
the obsolete installed name will need separate removal. Run only the
uninstaller when removal is the goal. Its `--check` mode reports installed
and missing names without removing them.

### What gets installed

Each package includes `agents/openai.yaml`. The installer generates a
`SKILL.md` with the installed name, rewrites internal `$source-name`
references in that manifest and metadata, and sets the metadata display name
to the installed name. External and built-in skill references remain unchanged.
Supporting resources are linked to this checkout, so keep it available.
Reinstall after changing a manifest or metadata; existing installations are
never refreshed implicitly.

## Install in Claude Code

```zsh
./scripts/install-claude-skills
```

The target defaults to `~/.claude/skills`. Each package is copied under its
source frontmatter name, with supporting resources and an ownership marker.
The Codex-only `agents/` metadata is omitted. To install into a project's
skill directory, supply an absolute target:

```zsh
./scripts/install-claude-skills "$PWD/.claude/skills"
```

### Check, refresh or remove

```zsh
./scripts/install-claude-skills --check
```

The installer adds missing packages and leaves existing paths untouched.
`--check` exits non-zero for missing or conflicting packages. Refresh with
the separate uninstaller and installer, using the same target:

```zsh
./scripts/uninstall-claude-skills
./scripts/install-claude-skills
```

The uninstaller removes only current source names with matching ownership
markers. Run it before renaming or removing a source package. Its `--check`
mode reports installed and missing packages without removing them.

## Invoke a skill

Group guides and example prompts use source names, such as `$pr-review`.
In Codex, substitute the installed name derived from the chosen prefix:
with `--prefix tjpeel`, invoke `$tjpeel-pr-review`. In Claude Code, invoke
`$pr-review` unchanged. Internal references in installed Codex manifests and
metadata are rewritten automatically; the repository's Markdown guides are
not rewritten.

If a skill is not loaded or the platform lacks direct invocation, ask the
agent to read the selected `SKILL.md` and apply its workflow. The environment
still needs the repository and service access required by that skill.

## Delegation

Codex can use the configured profiles from
[tjpeel/agents](https://github.com/tjpeel/agents). Claude Code can use an
equivalently bounded configured subagent when available. Profiles define
effort and access; each handoff defines its task, inputs and output.
When no equivalent capability is available, the coordinator performs the
bounded responsibility directly. Installing these skills does not install
agent profiles or authenticate external services.

For installer tests and catalogue changes, see
[maintenance](maintenance.md#validate-a-change).
