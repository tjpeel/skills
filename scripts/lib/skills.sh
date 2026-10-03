# Shared argument handling, packaging and ownership checks for both providers.

usage() {
  cat <<EOF
Usage: $ACTION-skills --provider codex|claude --prefix PREFIX [--check | --$ACTION] [TARGET_DIRECTORY]

--check reports installed, missing and conflicting packages without changes.
Install adds only missing packages; uninstall removes only owned packages.
PREFIX must start with a lowercase letter or digit and contain only lowercase
letters, digits and hyphens. Names combine PREFIX with the nested package path.
The target defaults to ~/.codex/skills or ~/.claude/skills for the provider.
A custom target must be absolute or begin with ~/.
EOF
  if [[ "$ACTION" == uninstall ]]; then
    cat <<'EOF'

Migration options (uninstall only):
  --legacy-unprefixed  Claude: remove old source-name packages with old markers.
                      Supply no prefix with this option.
  --force             Remove exact catalogue names even without matching
                      ownership. Use --check first to inspect the selected paths.
EOF
  fi
}

argument_error() {
  echo "$1" >&2
  exit 2
}

parse_arguments() {
  PROVIDER=""
  PREFIX=""
  TARGET_DIRECTORY=""
  MODE="$ACTION"
  LEGACY=""
  FORCE=false
  local target_given=false prefix_given=false mode_given=false positional_only=false

  while [[ $# -gt 0 ]]; do
    if [[ "$positional_only" == false ]]; then
      case "$1" in
        --provider|--prefix)
          [[ $# -ge 2 && "$2" != --* && -n "$2" ]] || argument_error "$1 requires a value."
          if [[ "$1" == --provider ]]; then
            [[ -z "$PROVIDER" ]] || argument_error "Supply --provider only once."
            PROVIDER="$2"
          else
            [[ "$prefix_given" == false ]] || argument_error "Supply --prefix only once."
            PREFIX="$2"
            prefix_given=true
          fi
          shift 2
          continue
          ;;
        --check|--install|--uninstall)
          [[ "$1" == --check || "$1" == "--$ACTION" ]] || argument_error "Unsupported mode for $ACTION: $1"
          [[ "$mode_given" == false ]] || argument_error "Choose only one mode."
          MODE="${1#--}"
          mode_given=true
          shift
          continue
          ;;
        --legacy-unprefixed)
          [[ "$ACTION" == uninstall ]] || argument_error "Migration options are only available for uninstall."
          [[ -z "$LEGACY" ]] || argument_error "Choose only one migration option."
          LEGACY="${1#--legacy-}"
          shift
          continue
          ;;
        --force)
          [[ "$ACTION" == uninstall ]] || argument_error "--force is only available for uninstall."
          FORCE=true
          shift
          continue
          ;;
        --help|-h) usage; exit 0 ;;
        --) positional_only=true; shift; continue ;;
        -*) argument_error "Unknown option: $1" ;;
      esac
    fi
    [[ "$target_given" == false ]] || argument_error "Only one target directory may be supplied."
    [[ -n "$1" ]] || argument_error "TARGET_DIRECTORY cannot be empty."
    TARGET_DIRECTORY="$1"
    target_given=true
    shift
  done

  case "$PROVIDER" in
    codex|claude) ;;
    *) argument_error "--provider is required and must be codex or claude." ;;
  esac
  if [[ "$LEGACY" == unprefixed ]]; then
    [[ "$PROVIDER" == claude && "$prefix_given" == false ]] || argument_error "--legacy-unprefixed requires --provider claude and no --prefix."
  else
    [[ -n "$PREFIX" ]] || argument_error "--prefix is required."
    [[ "$PREFIX" =~ ^[a-z0-9][a-z0-9-]*$ ]] || argument_error "PREFIX must start with a lowercase letter or digit and use only lowercase letters, digits and hyphens."
  fi
  [[ "$target_given" == true ]] || TARGET_DIRECTORY="$HOME/.$PROVIDER/skills"
  case "$TARGET_DIRECTORY" in
    '~') TARGET_DIRECTORY="$HOME" ;;
    '~/'*) TARGET_DIRECTORY="$HOME/${TARGET_DIRECTORY:2}" ;;
  esac
  [[ "$TARGET_DIRECTORY" == /* ]] || argument_error "TARGET_DIRECTORY must be absolute or begin with ~/."
  # Remove trailing slashes before resolving the target.
  while [[ "$TARGET_DIRECTORY" != / && "$TARGET_DIRECTORY" == */ ]]; do
    TARGET_DIRECTORY="${TARGET_DIRECTORY%/}"
  done
  resolve_target
}

resolve_target() {
  # Resolve existing links before checking containment, without creating paths.
  local ancestor="$TARGET_DIRECTORY" suffix="" component
  while [[ ! -d "$ancestor" ]]; do
    [[ ! -e "$ancestor" && ! -L "$ancestor" ]] || argument_error "The target or an ancestor is not a directory: $ancestor"
    suffix="${ancestor##*/}/$suffix"
    ancestor="${ancestor%/*}"
    [[ -n "$ancestor" ]] || ancestor=/
  done
  TARGET_DIRECTORY="$(CDPATH= cd -- "$ancestor" && pwd -P)"
  while [[ -n "$suffix" ]]; do
    component="${suffix%%/*}"
    suffix="${suffix#*/}"
    case "$component" in
      ''|.) ;;
      ..) TARGET_DIRECTORY="${TARGET_DIRECTORY%/*}"; [[ -n "$TARGET_DIRECTORY" ]] || TARGET_DIRECTORY=/ ;;
      *)
        TARGET_DIRECTORY="${TARGET_DIRECTORY%/}/$component"
        if [[ -d "$TARGET_DIRECTORY" ]]; then
          TARGET_DIRECTORY="$(CDPATH= cd -- "$TARGET_DIRECTORY" && pwd -P)"
        elif [[ -e "$TARGET_DIRECTORY" || -L "$TARGET_DIRECTORY" ]]; then
          argument_error "The target or an ancestor is not a directory: $TARGET_DIRECTORY"
        fi
        ;;
    esac
  done
}

manifest_name() {
  awk 'NR == 1 { if ($0 != "---") exit; next }
    /^---$/ { exit }
    /^name: / { sub(/^name:[[:space:]]*/, ""); print; exit }' "$1"
}

discover_skills() {
  skills=()
  source_names=()
  installed_names=()
  package_paths=()
  local manifest skill_directory source_name relative_path installed_name known_name

  while IFS= read -r -d '' manifest; do
    skill_directory="${manifest%/SKILL.md}"
    relative_path="${skill_directory#"$REPOSITORY_DIRECTORY"/}"
    [[ "$relative_path" == */* ]] || continue
    # Generated installations in custom repository targets are not sources.
    [[ ! -e "$skill_directory/.personal-skills-source" && ! -L "$skill_directory/.personal-skills-source" ]] || continue
    skills+=("$skill_directory")
  done < <(find "$REPOSITORY_DIRECTORY" \
    -type d \( -name .git -o -name .codex -o -name .claude \) -prune -o \
    -type f -name SKILL.md -print0 | LC_ALL=C sort -z)
  [[ ${#skills[@]} -gt 0 ]] || { echo "No nested skill packages found." >&2; exit 1; }

  for skill_directory in "${skills[@]}"; do
    source_name="$(manifest_name "$skill_directory/SKILL.md")"
    relative_path="${skill_directory#"$REPOSITORY_DIRECTORY"/}"
    [[ "$source_name" =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "Missing or invalid source name: $relative_path" >&2; exit 1; }
    [[ "$relative_path" =~ ^[a-z0-9][a-z0-9/-]*$ ]] || { echo "Invalid package path: $relative_path" >&2; exit 1; }
    if [[ "$LEGACY" == unprefixed ]]; then
      installed_name="$source_name"
    else
      installed_name="$PREFIX-${relative_path//\//-}"
    fi
    [[ ${#installed_name} -le 64 ]] || { echo "Installed name exceeds 64 characters: $installed_name" >&2; exit 1; }
    if [[ ${#source_names[@]} -gt 0 ]]; then
      for known_name in "${source_names[@]}"; do
        [[ "$known_name" != "$source_name" ]] || { echo "Duplicate source name: $source_name" >&2; exit 1; }
      done
      for known_name in "${installed_names[@]}"; do
        [[ "$known_name" != "$installed_name" ]] || { echo "Duplicate installed name: $installed_name" >&2; exit 1; }
      done
    fi
    case "$TARGET_DIRECTORY/" in
      "$skill_directory/"*) argument_error "The target cannot be inside a source skill package." ;;
    esac
    case "$skill_directory/" in
      "$TARGET_DIRECTORY/"*) argument_error "The target cannot contain source skill packages." ;;
    esac
    source_names+=("$source_name")
    installed_names+=("$installed_name")
    package_paths+=("$relative_path")
  done
}

rewrite_references() {
  # Replace each original token once, even when an installed name is another
  # package's source name. External references and longer tokens stay intact.
  awk -v sources="${source_names[*]}" -v names="${installed_names[*]}" '
    BEGIN {
      count = split(sources, source, " "); split(names, installed, " ")
      for (i = 1; i <= count; i++) mapping[source[i]] = installed[i]
    }
    {
      rest = $0; output = ""
      while (match(rest, /\$[[:alnum:]_-]+/)) {
        token = substr(rest, RSTART + 1, RLENGTH - 1)
        replacement = token in mapping ? "$" mapping[token] : "$" token
        output = output substr(rest, 1, RSTART - 1) replacement
        rest = substr(rest, RSTART + RLENGTH)
      }
      print output rest
    }' "$1"
}

render_manifest() {
  local index="$1"
  rewrite_references "${skills[$index]}/SKILL.md" | sed "1,/^---$/s/^name: .*/name: ${installed_names[$index]}/"
}

render_metadata() {
  local metadata="$1" index="$2"
  if [[ "$(basename -- "$metadata")" == openai.yaml ]]; then
    rewrite_references "$metadata" | sed "s/^\([[:space:]]*display_name:[[:space:]]*\).*/\1\"${installed_names[$index]}\"/"
  else
    rewrite_references "$metadata"
  fi
}

ownership_marker() {
  local index="$1"
  printf 'provider: %s\nprefix: %s\nsource: %s\npackage: %s\ninstalled: %s\n' \
    "$PROVIDER" "$PREFIX" "${source_names[$index]}" "${package_paths[$index]}" "${installed_names[$index]}"
}

is_owned_skill() {
  local destination="$1" index="$2"
  [[ -d "$destination" && ! -L "$destination" && -f "$destination/SKILL.md" && ! -L "$destination/SKILL.md" ]] || return 1
  [[ "$(manifest_name "$destination/SKILL.md")" == "${installed_names[$index]}" ]] || return 1
  if [[ -f "$destination/.personal-skills-source" && ! -L "$destination/.personal-skills-source" ]]; then
    if [[ "$LEGACY" == unprefixed ]]; then
      [[ "$(<"$destination/.personal-skills-source")" == "${source_names[$index]}" ]]
    else
      cmp -s -- <(ownership_marker "$index") "$destination/.personal-skills-source"
    fi
    return
  fi
  return 1
}

install_skill() {
  local destination="$1" index="$2" entry metadata relative_metadata
  mkdir -- "$destination"
  render_manifest "$index" > "$destination/SKILL.md"
  # Copy hidden resources too, and resolve links so both providers are portable.
  while IFS= read -r -d '' entry; do
    case "$(basename -- "$entry")" in
      SKILL.md|.personal-skills-source) continue ;;
      agents)
        [[ "$PROVIDER" == codex ]] || continue
        cp -RL -- "$entry" "$destination/"
        while IFS= read -r -d '' metadata; do
          relative_metadata="${metadata#"$entry/"}"
          render_metadata "$metadata" "$index" > "$destination/agents/$relative_metadata"
        done < <(find -L "$entry" -type f -print0)
        ;;
      *) cp -RL -- "$entry" "$destination/" ;;
    esac
  done < <(find "${skills[$index]}" -mindepth 1 -maxdepth 1 -print0)
  ownership_marker "$index" > "$destination/.personal-skills-source"
}

skills_main() {
  parse_arguments "$@"
  REPOSITORY_DIRECTORY="$(CDPATH= cd -- "$SCRIPT_DIRECTORY/.." && pwd -P)"
  discover_skills
  local index destination status=0

  if [[ "$MODE" == install ]]; then
    mkdir -p -- "$TARGET_DIRECTORY"
  fi
  echo "Provider: $PROVIDER"
  echo "Target:   $TARGET_DIRECTORY"
  echo "Prefix:   ${PREFIX:-(legacy source names)}"
  for index in "${!skills[@]}"; do
    destination="$TARGET_DIRECTORY/${installed_names[$index]}"
    if is_owned_skill "$destination" "$index" || { [[ "$FORCE" == true ]] && [[ -e "$destination" || -L "$destination" ]]; }; then
      if [[ "$MODE" == uninstall ]]; then
        rm -rf -- "$destination"
        echo "uninstalled  ${installed_names[$index]}"
      else
        echo "installed  ${installed_names[$index]}"
      fi
    elif [[ -e "$destination" || -L "$destination" ]]; then
      echo "conflict   ${installed_names[$index]} -> $destination" >&2
      status=1
    elif [[ "$MODE" == install ]]; then
      install_skill "$destination" "$index"
      echo "installed  ${installed_names[$index]}"
    else
      echo "missing    ${installed_names[$index]}"
      [[ "$MODE" != check ]] || status=1
    fi
  done
  return "$status"
}
