---
name: pr-sonar-fix
description: Repair authorised GitHub PR SonarQube or SonarCloud findings and quality gates; test, sign commits, push and monitor each analysis until clean and green. Inspection-only requests stay read-only.
---

# Fix a PR's Sonar gate

Diagnose the PR’s completed Sonar analysis, repair defects, test, sign and
publish, then inspect the next build and analysis. Repeat for further in-scope
issues. Finish only with a passing gate, no outstanding new-code Sonar
findings and passing required build checks for the current published revision.

## Authority and limits

Use this workflow in Codex, Claude Code or another environment with local Git,
GitHub and Sonar access. Follow applicable repository instructions and
platform execution permissions. No tracker or catalogue setup is required.

A request to fix, test, sign, commit, push and monitor authorises those actions
throughout this repair loop; do not request approval again for each cycle.
An inspection-only request authorises no writes. Resolve a missing PR identity
or genuinely ambiguous repair authority before dependent actions, while
continuing read-only diagnosis. This workflow does not authorise merging,
force pushing, amending published commits, PR metadata edits, comments, or
changes to remote Sonar policy or finding dispositions.

Honour supplied limits; otherwise allow at most five repair pushes within 60
elapsed minutes and state these defaults in the opening update. Inspect the
last permitted push’s build before deciding the outcome, within that window.
Stop earlier for a concrete blocker or two attempted repairs of one root
cause without measurable progress. Report unresolved failures, evidence and
next action at the limit. If extended, resume from the actual published
revision.

## Establish the PR and signing

Prefer scoped `gh` commands to GitHub browser automation. Check `gh auth status`
for the target host. In a sandbox, check through scoped elevated access before
reporting authentication unavailable. Limit elevated commands to
`gh auth status`, `gh pr`, `gh api` and `git push`; access Actions through
`gh api` when `gh run` would need elevation. Never print tokens.

Capture the open PR's repository, head repository and branch, base branch and
SHA, published head SHA, and required checks. Check fork ownership and push
access. Verify the checkout and remote match that head; do not trust a branch
name alone. Preserve unrelated edits, staged files and unpublished commits.
Use an isolated checkout at the pinned head when needed, following platform
worktree conventions. Resolve unexpected local or remote divergence before
editing or publishing; do not silently include another owner's changes.

Read the CI workflow and Sonar configuration to identify the Sonar host,
project or projects, PR key, scanner, coverage inputs and gate check identities.
Use configured values and linked check details rather than guessing from the
repository name. Record the target branch used by the analysis. A monorepo can
require several project gates; success must cover every relevant one.

Signing is required for every repair commit even when repository policy makes
it optional. Establish the effective commit identity, signing format and
configured signer before editing. Use the existing GPG, SSH or other configured
signing mechanism; do not read private keys, create keys, change identity or
disable signing to continue. Use `git commit -S` and verify each new commit
with `git verify-commit` using the configured trust mechanism. A missing signer
or unverifiable signature blocks publication. Report local verification and,
if observed after publication, GitHub's verification separately.

For SSH signing without an allowed-signers file, verification may use a
temporary `allowed-signers` file in this run's evidence directory, containing
the expected identity and the already configured signer's public key. Pass
it through `git -c gpg.ssh.allowedSignersFile=<path> verify-commit <sha>`.
Do not change persistent trust configuration, override existing trust rules
or trust a key extracted only from the commit being checked. If the expected
public signer cannot be established from trusted configuration, stop.

## Diagnose and repair

Read [the Sonar evidence procedure](references/sonar-evidence.md) to tie checks,
background processing, gate conditions and issue lists to this PR revision.
Retrieve failed conditions with actual values and thresholds, and all
outstanding PR findings with rule, location and message. A red gate may be a
coverage or duplication failure without any issue entries. A green gate may
still permit findings that this requested clean-up must address.

Map each failure to the code, behaviour and tests before editing. Distinguish
code defects from missing coverage imports, stale target-branch analysis,
scanner errors, absent secrets and provider failures. Use fresh logs and
completed analysis evidence; do not make speculative code changes for an
infrastructure failure. A confirmed report-generation or path defect within
this PR's scope can be repaired without changing the quality policy.

Fix the smallest supported set of defects while preserving intended behaviour:

- For bugs, vulnerabilities or maintainability findings, read the rule's
  rationale, relevant code and existing tests. Verify that the repair addresses
  the reported condition and retains the contract.
- For coverage, exercise the uncovered behaviour and branches with meaningful
  assertions. Verify the generated report contains those source paths and that
  the scanner imports it. Overall local coverage does not prove new-code coverage.
- For duplication or complexity, refactor only where the shared behaviour is
  sound; preserve error handling and boundary cases.
- For security hotspots, repair unsafe behaviour when supported. A remaining
  review requirement or disputed false positive needs a human decision;
  report it without marking it reviewed, accepted or false positive.

Do not weaken thresholds, change the gate or new-code definition, add
exclusions or suppression markers, skip analysis, fabricate coverage or
delete behaviour merely to obtain a pass. Findings outside the PR's scope
need a scope decision; do not expand into repository-wide cleanup.

## Test, commit and publish each repair

Run focused regression tests and the applicable repository-required checks,
including lint, build and coverage generation where required. Follow CI's
reporting conventions. An available local scanner is useful corroboration,
but publishing is what triggers the authoritative next PR analysis. Do not
start an additional remote analysis or workflow dispatch unless authorised.
Any failed or unavailable required validation blocks commit and push.

Inspect the full repair diff and `git diff --check`, including any generated
files. Complete required review and public-content gates when applicable.
Stage only owned repair paths or hunks, preserving pre-existing staged work.
Use an isolated checkout if unrelated staged changes would enter the commit.
Inspect the staged diff and create a focused signed commit following repository
message conventions. Verify the signature and confirm the commit contains
only the tested repair. If verification fails after committing, leave the
commit local and report the blocker; do not push or rewrite it automatically.

Re-read the PR head and base immediately before pushing. If either moved,
reconcile ownership and refresh the repair's analysis and test boundary before
publication. Push explicitly to the verified PR head repository and branch
with a normal fast-forward push. A rejection needs reconciliation, not a
force push. If push outcome is uncertain, read the remote before retrying.
Never create another repair commit solely to retry a push.

Record the new local commit and confirm the remote PR head matches it. Then
refresh check and analysis identities and wait for that revision's next build.
Use bounded waits of at most 60 seconds, backing off when unchanged and giving
concise progress updates. Do not treat an absent, skipped, cancelled or
timed-out Sonar check as green, or reuse the previous revision's result.

When completed analysis reports further actionable in-scope findings or
failing conditions, return to diagnosis and repeat the test, signed-commit,
push and monitoring cycle within the same authority and limits. Fixes can
expose new findings; compare their evidence rather than repeating an unchanged
patch. If Sonar is clean but another required build check fails, diagnose it
and repair only when it follows from this repair's scope; otherwise report
the blocker. Monitor-only gaps do not justify empty commits or repeated reruns.

## Delegation and handoff

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting a profile or declaring delegation unavailable. A small
single-rule repair can stay with an existing owner whose effort and write
scope fit. For a sustained repair loop, route each phase explicitly:

- `read_low`, low reasoning, observes GitHub checks and Sonar tasks, collects
  logs, conditions and complete finding lists, and maps named source locations
  and coverage paths. Give it the PR, head/base, project and run identities,
  required outcomes and deadline. It returns revision-bound evidence on a
  terminal result, actionable failure, changed head, access gap or deadline;
  it cannot edit files, run report-generating tests, rerun analysis or repair.
- `read_medium`, medium reasoning, diagnoses a non-trivial failed condition
  from that evidence or audits a completed repair independently. Use
  `read_high`, high reasoning, for a difficult root cause or material security,
  behaviour or concurrency risk. Both return evidence and a bounded repair
  recommendation without writes; a clear failure needs no separate analyst.
- `write_low`, low reasoning, owns the assigned implementation and test
  paths as the sole local writer, implements the supported repair and runs
  the required validation. It returns its diff and check results; it cannot
  stage, commit, push or change remote settings. Grade the writer
  separately using the shared guide; difficult implementation can require a
  higher band as well as high-reasoning diagnosis.

The coordinator owns scope decisions, signatures, commits, pushes and final
outcome. After checking the publication boundary, return new head and analysis
identities to the reusable low-reasoning observer; retain the writer for
repairs, not polling. Follow the shared guide’s model reporting and fallback
rules; this skill does not lower the chat’s selected effort.

Return the PR link and current published SHA, repaired findings or conditions,
tests run, signed commit IDs and signature evidence, and links to the final
build and Sonar analysis. State whether each relevant gate passed, the full
outstanding finding count, and required build checks' conclusions. Refresh the
head once more before declaring success; a new head needs new evidence.
Distinguish a passing gate from a verified absence of outstanding PR findings.
If access or a limit prevents either assessment, report the specific gap.

Keep the cycle record in the conversation. If evidence files are needed, use a
fresh directory from `mktemp -d "${TMPDIR:-/tmp}/pr-sonar-fix.XXXXXX"`, with
fixed filenames or numeric cycle subdirectories beneath it. Own only that new
directory, redact credentials and personal data, retain it through handoff
and report its path. Do not create repository tracking files or overwrite
another run's evidence. Schedule a future continuation only when requested,
carrying the PR, revision, limits and repair authority into that handoff.
