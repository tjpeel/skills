---
name: pr-monitor
description: Monitor an ordinary pull request's checks for its current published revision and complete explicitly requested repair and publishing steps. Use for PR follow-through; not for merging or processing a Dependabot queue.
---

# Monitor PR checks

Establish the current published PR state and follow the requested checks to a
terminal result. When the user requested repairs and publishing, continue that
bounded loop against each new revision. Local tests, a successful push and a
scanner exit are distinct from the final PR check conclusions.

## Platform compatibility

Use this workflow in Codex, Claude Code or another environment with equivalent
GitHub and repository access. Follow applicable `AGENTS.md` or `CLAUDE.md`
guidance and its command or approval restrictions. Prefer scoped GitHub CLI
calls when available; otherwise use equivalent GitHub tools. Invoke source
skills named with `$` where supported, or read their `SKILL.md` directly.
No external tracker, ticket naming scheme or runner setup is required.

## Pin the requested delivery

Resolve the repository and PR from the supplied URL or identity. Capture the
base, current remote head SHA and relevant check identities. Identify which
results the user requested and which the repository requires; do not invent
a quality gate or assume the currently visible rollup is complete. Read the
relevant workflow when necessary to explain an absent or skipped job. Keep
required outcomes distinct from unrelated advisory checks.

Record the authorised scope: monitoring alone, or named repairs, commits,
publishing and metadata changes as requested. A request to monitor does not
authorise any of those writes. A request to fix, test, commit, push and monitor
does not require fresh approval for each repetition within that same scope.
It does not authorise merging, force pushing, changing policy, enabling
missing secrets or weakening a required test. Respect execution permissions
separately from task authorisation.

Before an authorised repair, establish the selected checkout, branch and
review boundary against the PR, preserving unrelated work. A changed remote
head from another owner requires reconciliation before publishing. For a
stack, verify the selected predecessor and PR base; a repair on a parent can
leave descendants stale even when the parent is green.

## Observe checks for the actual head

Bind each result to the current remote head or the run that tested it. An
earlier successful run does not verify a new push. After the head changes,
refresh the check inventory and assess what evidence remains applicable.
Distinguish queued, running and terminal conclusions; cancelled, skipped,
missing or timed-out checks do not establish a required outcome. A skipped
job can be acceptable only when its condition makes it inapplicable to this
change, with evidence for that conclusion.

Inspect the failing step and its meaningful output. Separate a code failure,
test or coverage-reporting defect from an environment or provider-status
problem. A scanner's successful execution does not establish that its final
analysis or quality gate completed for this revision. Apply
`$engineering-verification` to the claimed outcomes and artifact identities.
Do not repeatedly change code to chase a status with no actionable defect.

Use bounded waits and back off when nothing changes. Set a stopping condition
from the requested observation window, the provider's timeout or the point
where user action is needed. Do not treat elapsed time as success or rerun
unchanged jobs indefinitely. For a requested future follow-up, use the
platform's scheduling capability when available, carrying the PR identity,
required checks and authorised scope. Notify on a meaningful change,
completion, failure or required action; stay quiet otherwise.

## Repair within the authorised scope

When a failure has a supported in-scope repair, use the existing implementation
owner and selected inputs. Apply `$engineering-testing`, run the required
repository checks, inspect the actual diff and complete the invoking
implementation workflow's review and commit gates. Do not relax a requirement,
add coverage filler or widen the ticket to obtain a green result.

Where repository policy requires signing, establish the effective repository
identity and signing configuration before committing or publishing. Verify
the resulting signature using the available local or GitHub evidence and
state which was checked. Do not load key material into output or automatically
rewrite unsigned history; a history rewrite requires its own authority.

Use `$pr-manage` for authorised pushes and metadata writes. Verify the new
remote SHA, then observe its checks. If description changes were requested,
use `$pr-draft` to align the delivered slice and verification claims with the
actual content. A branch push alone does not authorise editing PR fields.
For a selected stack, report descendants needing authorised restacking and
verification rather than declaring the series complete from one green PR.

Stop with the precise blocker when required validation cannot run, the
failure needs a new decision or external configuration, scope is exceeded,
remote ownership is unresolved, or the observation window expires. A known
provider inconsistency remains unresolved until evidence establishes the
requested terminal state; it need not cause speculative code changes.

## Ownership and evidence

Read [the ownership and delegation guide](references/ownership-and-delegation.md)
before selecting profiles or declaring delegation unavailable.

Routine monitoring is a direct task. For a non-trivial failure, use
`read_medium` for a bounded log-to-result audit. Use `read_high` only when a
material risk in the proposed repair needs independent judgement.
Give auditors the head, raw run results, required outcomes and exact question;
they do not repair, publish or approve the PR. The coordinator owns external
writes and the final delivery assessment.

Return the PR URL, current published SHA, requested-check conclusions and
supporting run links. Distinguish local verification, published repairs and
remaining gaps, including signing or stack limitations when relevant. Report
the requested loop complete only when its required results are established
for that published content.

Keep progress and final evidence in the current conversation or existing
authorised handoff. If files are needed, create a fresh temporary directory
with `mktemp -d "${TMPDIR:-/tmp}/pr-monitor.XXXXXX"` and store evidence there.
Own only that new directory; preserve its evidence through the handoff and
report its path. Do not create repository tracking files or overwrite another
run by default. Redact credentials and personal data from retained output.
