# Repository context

Use this reference for a requested or required domain context record. Do not
generate a glossary by default. A context document preserves domain meaning
or external constraints that cannot be determined from code, tests or
configuration. It should signpost functionality, not explain it in a second
location. Prefer clearer names in code when that resolves the gap; leave those
edits to implementation.

## Find the right context

Respect the repository's existing terminology and document locations first.

- If a root `CONTEXT-MAP.md` exists, use it to find the relevant bounded
  context and its `CONTEXT.md`.
- If a root `CONTEXT.md` exists without a map, treat the repository as one
  context unless repository guidance says otherwise.
- If neither exists, create nothing unless a specific knowledge gap justifies
  a saved record. For an authorised record, propose a root `CONTEXT.md` after
  its content is settled.
- Propose `CONTEXT-MAP.md` only when a requested or required record needs to
  preserve non-obvious relationships between separately owned bounded
  contexts. Multiple directories alone do not justify a map. Put each context's
  `CONTEXT.md` near that context's source root.

An agreed map should link to the relevant source roots and any existing context
records, stating only relationships the code cannot convey. Do not create a
context file for every map entry. Transport choices, shared types and other
mechanisms remain documented by code; record their rationale in an ADR only
when it meets the ADR qualification criteria.

## Keep the glossary useful

Add a term only after its meaning is settled and the missing context matters
to future work. Define that missing meaning in one or two sentences, use the
canonical project term, link to relevant code, and list genuinely confusing
alternatives under `_Avoid_`. Do not inventory names already clear in code.
Group terms beneath short topical headings only when that makes a growing
glossary easier to scan.

Keep out general programming terms, implementation details, API or schema
instructions, open questions, and a session narrative. If code and a settled
term disagree, surface the contradiction for the user to resolve rather than
silently changing either.

## Safe updates

Keep terms in the conversation until the user authorises repository writes.
After that, write only agreed terms to the applicable context file. Preserve
unrelated entries and the repository's existing format. If the target context
file changes during the session, stop and ask how to reconcile it rather than
overwriting it.
