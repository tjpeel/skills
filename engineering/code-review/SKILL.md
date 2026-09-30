---
name: engineering-code-review
description: Review a local engineering change against its approved ticket or specification and repository standards, reporting only actionable correctness, regression, security, compatibility, concurrency, or test risks. Use after implementation or to review another local change; do not use to make the change or review external pull requests.
---

# Engineering code review

Review a local diff independently of its implementation. Check two distinct
questions without allowing one to hide the other:

- **Requirements:** does the change deliver the approved ticket or
  specification without unsupported scope?
- **Standards and risk:** does the change respect documented repository
  conventions and avoid actionable correctness, regression, security,
  compatibility, concurrency, or test risks?

Use this after `$engineering-implement` has completed focused verification, or
whenever the user needs an evidence-based review of a local change. It is a
review-only skill: it does not edit code, commit, push, publish comments, or
approve a pull request. Use `$pr-review` for a colleague's pull request.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow all
applicable repository instructions: this normally includes `AGENTS.md` in
Codex and `CLAUDE.md` in Claude Code. When this skill names another source
skill with `$`, invoke it where supported; otherwise read that source skill's
`SKILL.md` and apply its workflow directly.

## Pin the review boundary

Require a fixed point: a commit, branch, tag, merge-base, or the `HEAD` commit
recorded before implementation began. Confirm that it resolves before judging
the change. Capture `git diff <fixed-point>...HEAD` and
`git log <fixed-point>..HEAD --oneline` once, then also capture any staged or
unstaged working-tree changes. Record the changed-file list and give the same
commands and evidence to every delegated reviewer.

If the fixed point is unknown, ask for it. Do not infer that the current branch
base represents one ticket when it also contains unrelated work. Stop when the
combined diff is empty. If unrelated changes share the working tree, identify
them and ask the user to narrow the review boundary rather than attributing
them to the ticket.

## Find requirements and standards sources

Prefer the ticket or specification path supplied by the user. Otherwise look
for an unambiguous matching local ticket before choosing a specification.

When the branch starts with the name of a direct child directory of `.tickets/`
followed by `-`, or equals that directory name, treat that directory as the
candidate parent reference. Within it, try to identify the implementation
ticket whose numbered filename and outcome title match the branch suffix. Read
that ticket for its acceptance criteria, decisions, constraints, and link to
the source specification. Use it only when the match is unambiguous; do not
guess from a ticket-looking branch name or borrow guidance from a sibling
ticket. Resolve links from the ticket's own directory and read the approved
source specification in full. The ticket selects the current delivery slice;
the specification constrains its contracts and shared invariants. Do not report
an explicitly deferred feature as missing from this ticket, or excuse a defect
in its current partial behaviour because another ticket will extend it.

Without a ticket, prefer a supplied specification path, then look for a matching
approved file in `.specifications/` using the branch outcome and available
reference. Specifications belong in `.specifications/`; do not treat a
document elsewhere as an approved specification.

Read applicable repository guidance, `CONTEXT.md` or `CONTEXT-MAP.md`, accepted
ADRs, and the relevant existing code and tests. Treat a Markdown
`CODING_STANDARDS.md` at the repository root as the canonical coding-standards
file. If it is absent, look for the same name under `docs/`, then for
`CONTRIBUTING.md`, `STYLEGUIDE.md`, or `STYLE_GUIDE.md` at the root or under
`docs/`. Read only files that actually state applicable coding standards.

If no approved specification can be found, still run the technical review
and report which requirements could not be assessed. A matching ticket can
establish its stated intent, but does not prove approval of a missing source.
If a candidate ticket exists but its source-specification link is missing or
does not resolve beneath `.specifications/`, report that limitation rather than
substituting another source.

## Delegation profiles

For a small, obvious diff, work directly. For a non-trivial diff, use the
least sufficient delegated capability available in the current platform. In
Codex, use the installed custom profiles `read_low`, `read_medium`, or
`read_high`; do not substitute a Codex built-in role. In Claude Code, use an
equivalently bounded read-only subagent only when subagents are available. A
profile or subagent is an effort and access boundary, not a task role: give
every handoff the fixed point, exact diff commands, source paths, constraints,
and required output. If the equivalent is unavailable, perform that bounded
responsibility in the coordinating agent.

- Use `read_low` as a locator. It inventories changed behaviour and tests,
  identifies the specification, matching ticket, standards sources, and maps
  each acceptance criterion to the most relevant changed code or test. It does
  not judge the implementation.
- Use `read_medium` only to check a bounded requirements-to-diff trace or
  verification and coverage evidence when that cheaper audit will make the
  high-capability review more precise. It reports missing evidence and
  contradictions, not final findings.
- Use `read_high` for the review itself. It evaluates the diff in context,
  using the locator's evidence, and reports only actionable risks. For a large
  or materially risky change, run independent `read_high` reviews in parallel:
  one for requirements and test coverage, one for standards and technical
  risks. Its initial evidence packet contains raw code, diff, repository
  standards and runtime wiring, excluding requirements mappings, planning
  artifacts and the implementer's explanation. Then supply intent evidence
  to reconcile its conclusions. Keep the two assessments separate until
  aggregation so shared assumptions do not
  hide a defect.

The coordinator owns the fixed-point decision, final assessment, user
questions, and any repair. Read-only delegates do not alter code, contact
reviewers, or make external writes.

## Review the change

First trace the actual behaviour from public entry points through side effects,
failure handling and recovery using code, tests and runtime configuration.
Do this without relying on the implementer's narrative or treating the planning
artifacts as proof of correctness. For the changed paths, check relevant:

- recovery after a transient error versus permanent give-up, retry budgets,
  cancellation, ownership loss and readiness while work is paused;
- loop pacing after success, empty reads and failures, including the effective
  throughput implied by defaults;
- configuration validation before activation or work consumption, including
  placeholders and disabled modes;
- external API input constraints, offset and precision rules, persistence
  round trips, and immutable-identity comparisons; and
- actual retry, ordering and dead-letter consequences of deferred paths,
  borrowed policy, service identifiers, and misleading comments or docs.

Then check requirements. Compare each in-scope required behaviour, accepted
decision, observable acceptance criterion, and applicable rollout or change
constraint with the diff and its verification. Report missing, partial, or apparently
incorrect behaviour; scope that the source did not ask for; and tests that do
not actually observe the intended behaviour.

Assess test coverage separately from whether tests pass. Map every new or
changed observable behaviour to the added or updated test that exercises it at
the agreed seam. Identify new error paths, branches, integration boundaries,
and changed executable code with no credible regression coverage. Do not ask
for tests of private implementation detail or unrelated pre-existing code.

Where the repository provides a coverage command or report, inspect coverage
for the diff or new code as well as any reported overall project coverage.
Distinguish line, branch, and function coverage when the tooling reports them;
new code can have good line coverage while important branches remain untested.
Report the measured new-code or diff-coverage volume and the overall figure
separately. Do not invent a percentage threshold: apply one only when the
specification or repository standards define it. If no coverage measurement is
available, state that limitation and assess coverage from the test-to-behaviour
mapping instead.

Then check standards and risk. Apply documented repository rules before
general heuristics. Treat any heuristic as a judgement call, not a rule, and
skip matters already enforced by tooling. Look for misleading names, duplicated
logic, awkward data groups, inappropriate primitives for important domain
concepts, repeated branching, unnecessary abstraction, misplaced behaviour,
and avoidable dependency chains when they materially affect the changed code.
Also inspect error paths, data handling, compatibility boundaries, concurrency,
resource ownership, and security-sensitive input or output whenever relevant.

Do not report style preferences, hypothetical redesigns, pre-existing defects
outside the diff, or missing tests with no credible failure scenario. Do not
mark a change safe merely because tests pass; verify that the tests exercise
the claimed behaviour at the agreed seam.

## Report and return repairs to implementation

Report findings under separate `## Requirements` and `## Standards and risk`
headings. Keep those axes separate: a conventionally clean change can implement
the wrong requirement, and a correct feature can still violate a repository
constraint.

For every finding, include:

- priority and the affected file and line or narrow hunk;
- the unmet source requirement or standard, when applicable;
- a concrete failure scenario or reason the behaviour is unsafe; and
- the smallest credible fix or missing verification.

End with the number of findings on each axis, the verification evidence
reviewed, coverage evidence (including any new-code/diff and overall figures),
and any limitation such as an unavailable coverage command, full test suite,
or requirements source. If nothing meets the threshold, say that no actionable
findings were identified; do not claim the change is defect-free.

When this review follows `$engineering-implement`, return in-scope fixes to
that implementation step. After repairs, rerun the affected verification and
repository-required full checks for the repaired revision, and repeat this
review against the same fixed point across the complete ticket diff.
Escalate a finding that requires a new product or design decision to
`$engineering-decision-discovery` or
`$engineering-specification` instead of solving it in the diff.
