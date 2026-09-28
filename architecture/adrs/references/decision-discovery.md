# Decision discovery from current code

Use this reference when the retrospective ADR workflow needs to find durable decisions that are not obvious from commit titles or changed-path categories.

## Find decision seams

Start at architecture boundaries and search for code that chooses, translates, constrains, or preserves meaning. Useful anchors include:

- integration response models, mappers, adapters, and source-specific services;
- `switch` or pattern matches on an integration-owned enum, type, status, or registration;
- selectors that choose a record, version, recipient, identity, or representation;
- normalisation, fallback, default, null, date, identifier, and unit conversions;
- validators and endpoint mappers that deliberately narrow a public contract;
- state-transition and concurrency guards;
- schema-version, migration, retry, lease, and delivery-state logic.

Search for these patterns at the boundary first, then follow callers and tests. For example, a method which selects a company name by a registration type received from another service may establish a business-facing integration policy, even if the method is short.

## Assess whether a seam merits a dossier

A seam is a candidate when all or most of the following are true:

1. It maps source data to a domain or public meaning rather than merely copying fields.
2. A different choice would alter a user-visible response, persisted record, notification, control, or operational behaviour.
3. It has callers, tests, documents, or history that show it is retained rather than incidental.
4. Its scope can be stated accurately: for example, a particular integration and workflow, not the whole domain.

Do not promote an ADR merely because code has a conditional. Exclude a candidate when the rule is mechanical, private convenience, demonstrably superseded, or unsupported by enough evidence to state its scope without speculation.

## Trace the evidence

For each candidate, record the current symbol and path, its immediate callers, relevant tests, and observable consequence. Then inspect file and symbol history, adjoining changes, PR descriptions, design documents, and later changes that refine or limit the rule.

Treat a user-supplied source link as an anchor, not proof of a decision. Resolve the linked revision if available, compare it with the checked-out/current implementation, and identify whether the logic is current, changed, or superseded.

Use the evidence dossier to distinguish:

- explicit rationale from PR/design/review material;
- current-code corroboration;
- an inference that the logic is a durable policy;
- counter-evidence, such as a later narrower scope or alternative path.

## Reconcile the lenses

After synthesis, reconcile candidates back to the PR-coverage matrix. A source-anchor ADR should cite its introduction/evolution PRs. A historically indexed PR that is not represented by an ADR needs an exclusion or supporting-evidence classification. This preserves accountability without creating an ADR catalogue out of every change.
