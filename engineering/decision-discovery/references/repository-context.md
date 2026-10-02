# Repository context

Use this reference for a requested or required domain context record. Do not
generate a glossary by default. A context document preserves domain meaning
or external constraints that cannot be determined from code, tests or
configuration. It should signpost functionality, not explain it in a second
location. Prefer clearer names in code when that resolves the gap; leave those
edits to implementation.

## Find the right context

Respect the repository's existing terminology and document locations first.

The domain glossary may be a `GLOSSARY.md`, the language section of a
`CONTEXT.md`, or another established record. A context document may also
contain domain constraints and relationships beyond terminology. Determine
the record's role from its content and repository guidance, not its filename.
When both files exist, use the relevant content in each and surface conflicting
definitions. Do not rename, duplicate or synchronise them merely to adopt a
preferred naming convention.

- If a root `CONTEXT-MAP.md` exists, use it to find the relevant bounded
  context and follow the linked records, whatever their names.
- If an existing `CONTEXT.md`, `GLOSSARY.md` or equivalent record already
  serves the requested purpose, use it at its established location. A missing
  alternative filename is not a knowledge gap or a reason to create a map.
- If no suitable record exists, create nothing unless a specific knowledge gap
  justifies a saved record. For an authorised record with no existing naming
  convention, propose a root `CONTEXT.md` after its content is settled.
- Propose `CONTEXT-MAP.md` only when a requested or required record needs to
  preserve non-obvious relationships between separately owned bounded
  contexts. Multiple directories alone do not justify a map. Put each context's
  record near that context's source root, preserving existing names; use
  `CONTEXT.md` only when no convention exists.

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
