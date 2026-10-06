---
name: engineering-testing
description: Decide whether a change needs new tests and assess test quality against observable behaviour and existing coverage. Use when selecting, writing, or reviewing tests; avoid redundant coverage and tests that restate implementation.
---

# Engineering testing

Every added test must protect a required behaviour or credible failure that
existing checks do not adequately cover. A changed file, new helper, completed
ticket, or higher coverage percentage alone does not justify a new test.

## Platform compatibility

This guidance is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent repository and command access. Follow
applicable repository instructions, including `AGENTS.md` or `CLAUDE.md`, and
explicit user requirements for tests, verification and coverage thresholds.

## Decide whether a test is needed

Start with the production behaviour being changed and read the relevant
existing tests and check commands before proposing additions. Identify what
already protects unchanged boundaries, then establish for each new case:

- the required observable behaviour or realistic failure it protects;
- the gap in existing tests or other checks;
- a stable interface that exercises the behaviour; and
- an independent expected outcome that distinguishes correct behaviour from a
  plausible wrong implementation.

Choose the smallest sufficient response: run existing coverage, update a test
whose expected behaviour has changed, extend an existing scenario, or add a
new case for a distinct gap. Do not broaden a test to combine independent
behaviours merely to avoid adding a case. Existing coverage counts even when
its file is unchanged.

Separate running required suites from authoring new scenarios or fixtures.
Mandatory repository checks still apply to a small change. New test layers,
harnesses and setup need a distinct coverage gap or an applicable explicit
rule; identify that reason rather than treating them as automatic work.

For a calculation-only fix, a focused regression can reproduce the failure
while existing integration and endpoint tests protect unchanged propagation
and serialisation. Extend those tests for an uncovered interaction or contract,
or when repository guidance explicitly requires it. Do not add a combined
end-to-end scenario merely because an acceptance criterion mentions the final
response.

Mechanical edits, behaviour-preserving refactors and throwaway prototypes can
be verified without new permanent tests when relevant existing checks or direct
inspection provide credible evidence. Config, wiring, UI and CRUD changes are
not automatic exemptions: test a changed contract, validation rule, persistence
effect or other material behaviour when it has an uncovered failure scenario.
Do not backfill unrelated coverage or enumerate speculative input combinations.

Property-based or metamorphic tests can be useful when their invariant or
relationship comes from the required contract. Independent evidence does not
always require a fixed literal; the assertion must still detect a plausible
violation rather than repeat the implementation's computation.

Keep this decision brief and in the conversation or invoking workflow's
handoff. No separate plan, coverage inventory or report file is required. If
no new test is needed, state why and what verification supports that decision.
Apply the guidance directly; it does not need an additional delegate. Give any
existing mapper, writer or reviewer the same coverage gap and test boundary.

## Choose a boundary that catches the failure

Use an interface already selected by the task or repository. Otherwise prefer
the lowest-cost existing public boundary that faithfully exercises the
behaviour. A unit test can suit isolated domain logic; integration coverage is
needed when real wiring, persistence, transport or component interactions are
part of the failure. End-to-end tests need a distinct reason that cheaper
coverage cannot satisfy. Do not test every layer by default.

For a bug fix, reproduce the actual triggering inputs and interactions, observe
the test fail on the original bug and pass with the fix. An unrelated setup,
import or syntax failure does not demonstrate that the assertion catches the
bug. Do not force a shallow regression test that cannot reproduce it. If no
credible test boundary is available, verify with the original reproducer and
report the remaining coverage gap rather than claiming regression protection.

Keep real internal collaborators. Substitute genuinely external or
non-deterministic dependencies at system boundaries when needed; prefer a
representative local test database or adapter when the interaction matters.
Do not change production visibility or extract a helper solely to assert its
implementation. Do not replace a required integration check with mocks.

## Named test anti-patterns

Use these names to explain a concrete weakness, not to reject a framework,
test level or technique categorically.

| Anti-pattern | What to avoid | Useful alternative or qualification |
| --- | --- | --- |
| **Tautological / self-referential tests** | Expected results come from the function under test, a shared production helper, or a copy of its algorithm, repeating the same mistakes. | Use a worked example, specification, independently reviewed fixture or separate oracle. A literal copied blindly from today's output is not independent evidence. |
| **Implementation-coupled / overspecified tests** | Private methods, internal state, helper names or incidental call order become requirements. Harmless refactors break the test. | Assert the caller's contract through the public interface. |
| **Change-detector tests** | Source-text checks or structural snapshots merely confirm that code, config or markup was edited. | Exercise the resulting behaviour. A static check is justified for an explicit structural rule; prefer an existing linter or schema validator. A reviewed snapshot can protect a stable output contract. |
| **Mock-only interaction tests** | Internal collaborators are mocked and the assertions only repeat their expected calls, leaving the actual result untested. | Use real internal code and check the observable outcome. Boundary interactions are worth asserting when they are the contract, such as at most one payment charge. |
| **Vacuous tests / assertions** | A test runs code without a meaningful assertion, swallows a failure, or checks only truthiness, existence or no exception when the requirement is a specific result. | Assert the required outcome and relevant effects. A smoke check can be useful when successful startup is itself the stated requirement. |
| **Duplicate coverage** | Multiple cases or test levels exercise the same scenario and failure without adding independent protection. | Extend or retain the clearest coverage. Multiple levels are justified when they catch distinct risks, such as calculation versus transport wiring. |
| **Coverage-only tests** | Tests are added to increase a metric, exercise trivial accessors, or recheck language and library behaviour without a project contract. | Choose meaningful scenarios for required behaviour; satisfy explicit coverage thresholds without filler assertions. |
| **Speculative edge-case tests** | Invented requirements, unreachable internal states or arbitrary permutations expand the task. | Cover specified boundaries and credible failures. Invalid runtime input can be important at an untrusted boundary even when its type is excluded by static annotations. |

For example, given the requirement that line-item prices are summed:

```typescript
// Tautological: duplicates the production summation algorithm.
expect(calculateTotal(items)).toBe(items.reduce((sum, item) => sum + item.price, 0));

// Independent worked example: 10 + 5 must produce 15.
expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
```

Avoid **horizontal slicing** as a workflow: generating all imagined tests
before implementation. When test-first work is useful, take one behaviour
through failing test and minimal implementation before choosing the next case.
Do not force a red-green loop for a change with no useful behavioural assertion.
Keep one logical outcome per test; related assertions may establish that outcome.

## Edit, verify and review

This guidance does not authorise implementation or unrelated test cleanup.
Within an authorised writing task, identify the exact test and fixture paths
in the invoking repository before editing. Use its existing test directories,
filename suffixes and naming conventions; do not create a new harness or report
location just to apply this skill. Update only tests and fixtures owned by the
selected change, preserve unrelated edits, and never blindly overwrite or
regenerate snapshots. Review each changed expectation against the contract.

After consolidating modules, replace overlapping shallow tests only when the
replacement preserves their distinct behavioural guarantees. Do not delete,
weaken or skip an existing test merely to make the suite pass. Leave unrelated
cleanup as a separate recommendation.

Run the narrowest relevant checks while working, then the full checks required
by the repository or invoking workflow. Passing tests, test count and coverage
percentages are evidence to assess, not proof of correctness. Check that tests
ran rather than silently skipped. Stop adding tests when the identified gaps
and required risks are covered; no minimum number of new tests is implied.

Reviewers should request a missing test only with a concrete uncovered failure
and a boundary that can observe it. Assess existing coverage and verification
without new tests as valid outcomes. Report an anti-pattern only when it hides
a defect, misses required behaviour, or creates a concrete maintenance problem;
do not turn the names above into style-only review findings.
