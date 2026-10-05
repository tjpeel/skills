# Installation and refresh

Run these commands from the repository root. One installer and one uninstaller
serve both providers; `--provider` selects the default target and metadata.
See the [workflow catalogue](../README.md#choose-a-workflow) to select a skill.

Installation and removal use Bash and standard command-line utilities;
ripgrep (`rg`) is not required.

## Install

```zsh
./scripts/install-skills --provider codex --prefix tjpeel
./scripts/install-skills --provider claude --prefix tjpeel
```

The defaults are `~/.codex/skills` and `~/.claude/skills`. Both providers require
`--prefix`: start it with a lowercase letter or digit, then use lowercase
letters, digits and hyphens. The installer combines it with every directory
in the package path. For example, `pr/review/SKILL.md` becomes
`tjpeel-pr-review/`, with manifest name `tjpeel-pr-review`. Installed names must
fit within 64 characters.

To supply an absolute target, including a project's skill directory:

```zsh
./scripts/install-skills --provider claude --prefix tjpeel -- "$PWD/.claude/skills"
```

Literal `~` and `~/` targets resolve against the current user's home directory.
A target cannot be inside a source skill package or contain source packages.
Restart Codex after installation so it reloads the catalogue.

### Check current state

```zsh
./scripts/install-skills --provider codex --prefix tjpeel --check
./scripts/install-skills --provider claude --prefix tjpeel --check
```

`--check` reports installed, missing and conflicting packages without changing
files, and exits non-zero for missing packages or conflicts. Default install
mode adds only missing packages. It leaves every existing path untouched;
resolve conflicts before running it again. Existing owned packages are not
refreshed implicitly.

### What gets installed

Both providers receive a generated `SKILL.md` with the installed name.
Internal `$source-name` references in that manifest are rewritten using the
complete catalogue map. External and built-in skill references stay unchanged.
Supporting resources are copied, including hidden files, with symlinks resolved
into local copies. Installed packages do not depend on this checkout.

Codex also receives `agents/` metadata with internal references rewritten and
the `openai.yaml` display name set to the installed name. Claude omits `agents/`.
Each package has a `.personal-skills-source` ownership marker recording its
provider, prefix, source name, package path and installed name. Both providers
use the same ownership checks for installation and removal.

## Refresh or remove

Uninstall the current package names, then install the revised catalogue:

```zsh
./scripts/uninstall-skills --provider codex --prefix tjpeel
./scripts/install-skills --provider codex --prefix tjpeel
```

Use `--provider claude` for Claude, and the same prefix and target for both
commands. Run only the uninstaller when removal is the goal. Normal uninstall
removes only packages with matching manifest names and ownership markers;
conflicting files, directories and symlinks are preserved and reported.
Missing packages do not prevent removal. Its `--check` mode reports the same
state without removing anything.

Only exact names derived from this repository's current package paths are
selected. Run uninstall before renaming or removing a source package; otherwise
the obsolete installed name will need separate removal.

### Remove installations made by the old scripts

The old provider-specific scripts have been replaced. Old Codex packages have
no ownership marker; old Claude packages use unprefixed source names. To clear
them before reinstalling, `--force` removes the exact selected catalogue names
even when ownership does not match. It can also remove conflicting content at
those names. Preview with `--check` first; missing names make that check exit
non-zero. Other names and prefixes are left alone. A package symlink is removed
without following it.

From each provider's global skills folder, replace `/absolute/path/to/skills`
with the path to this checkout. For Codex, supply the prefix used originally:

```zsh
cd ~/.codex/skills
/absolute/path/to/skills/scripts/uninstall-skills --provider codex --prefix tjpeel --force --check "$PWD"
/absolute/path/to/skills/scripts/uninstall-skills --provider codex --prefix tjpeel --force "$PWD"
/absolute/path/to/skills/scripts/install-skills --provider codex --prefix tjpeel "$PWD"
```

For old unprefixed Claude packages, use `--legacy-unprefixed` without a prefix
for removal, then supply the chosen prefix when installing:

```zsh
cd ~/.claude/skills
/absolute/path/to/skills/scripts/uninstall-skills --provider claude --legacy-unprefixed --force --check "$PWD"
/absolute/path/to/skills/scripts/uninstall-skills --provider claude --legacy-unprefixed --force "$PWD"
/absolute/path/to/skills/scripts/install-skills --provider claude --prefix tjpeel "$PWD"
```

Omit `--force` from legacy Claude removal to require the old source-name marker.
The same current-package-path limitation applies to forced removal: obsolete
names, including old `personal--*` directories, need separate removal.

## Invoke a skill

Group guides and example prompts use source names, such as `$pr-review`.
For either provider, substitute the installed name derived from your prefix:
with `--prefix tjpeel`, invoke `$tjpeel-pr-review`. Internal references in
installed manifests and Codex metadata are rewritten automatically; repository
Markdown guides are not rewritten.

If a skill is not loaded or the platform lacks direct invocation, ask the
agent to read the selected `SKILL.md` and apply its workflow. The environment
still needs the repository and service access required by that skill.

## Delegation

The common instructions live in
[shared/ownership-and-delegation.md](../shared/ownership-and-delegation.md).
Source skills link to that file through a local reference; the installer
materialises it as `references/ownership-and-delegation.md` inside each
installed skill. Edit the shared source once, then refresh installed skills.
The installed guide does not require this checkout or another installed skill.

Codex can use configured profiles such as those from
[tjpeel/agents](https://github.com/tjpeel/agents), whose installer copies
definitions and can refresh its own legacy links. Check the live spawning tool
and include symlinked profile files when inspecting the active agent directory.
Use the declared agent name, which can differ from its installed filename.
Distinguish a missing definition from a definition that the current session
cannot spawn. Claude Code can use an equivalently bounded configured subagent.
The guide defines profile selection and the direct-work fallback. Installing
these skills does not install profiles or change agent configuration.

For installer tests and catalogue changes, see
[maintenance](maintenance.md#validate-a-change).
