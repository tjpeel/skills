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
that file is a relative symlink to the shared guide. The shared installer copies
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

## Validation and functional coverage

Before staging or committing any change, including documentation, run these
checks from the repository root:

```sh
tests/test-install-skills
tests/test-check-public-content
git diff --check
scripts/check-public-content
```

All required checks must pass before staging or committing. Resolve failures;
if a check cannot run, report the blocker and leave the affected changes
uncommitted.

Check Bash syntax with `bash -n` separately for each repository script,
sourced library, test and helper shipped inside a skill package. Passing
several filenames to one `bash -n` invocation checks only the first script.

- Keep meaningful automated coverage for every executable entry point, shared
  library and documented mode, including helpers under skill packages such as
  `pr/manage/scripts/`. When adding, changing or removing functionality,
  identify the tests that cover its observable behaviour and update them with
  the implementation. Exercise libraries through their callers where possible.
- For a functional fix, add a regression case that fails before the fix and
  passes afterward. Assert output, exit status and filesystem effects; a
  successful exit alone is insufficient. Cover both providers and relevant
  invalid input, naming, reference rewriting, resources, ownership, conflicts,
  removal, migration and failed writes.
- Run portable tooling tests with a restricted `PATH` containing only
  documented baseline dependencies. Optional developer tools such as `rg`
  must be absent. Document any new required command and test its absence and
  relevant failure modes. Missing dependencies must produce a clear error
  before dependent writes.
- Preserve failures across pipelines, command substitution and process
  substitution. Test failed discovery, scans and partial output where relevant.
  An incomplete operation must not report success or describe an environment
  failure as invalid content. Test optional fallbacks as well as required
  commands.
- Keep tests in temporary directories with explicit targets. Use fixtures and
  command stubs for Git, GitHub and other external services; do not use the
  user's live skill directories, credentials, network services or external
  writes. Build synthetic sensitive-content fixtures at runtime rather than
  storing credential-shaped strings in the repository.
- Check changed manifests, metadata, references and assets for their intended
  structure as well as successful copying. For instruction changes, walk
  through a representative scenario covering triggers, inputs, outputs,
  authority, fallbacks and handoffs. Use relevant behavioural evaluations
  when actions or permissions change. Packaging tests do not prove an agent
  follows the workflow; record what was exercised and what remains unverified.
- Do not add tests that merely match documentation wording or mirror an
  implementation. Keep the required command list and `docs/maintenance.md`
  current as suites are added. Report any required check that cannot run;
  do not call it a pass.

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
