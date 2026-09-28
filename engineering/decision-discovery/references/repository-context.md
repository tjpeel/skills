# Repository context

Use this reference when decision discovery needs to create or update a domain
glossary. A context document is a living vocabulary artifact, not a design
notebook, implementation plan, or record of every decision made in a session.

## Find the right context

Respect the repository's existing terminology and document locations first.

- If a root `CONTEXT-MAP.md` exists, use it to find the relevant bounded
  context and its `CONTEXT.md`.
- If a root `CONTEXT.md` exists without a map, treat the repository as one
  context unless repository guidance says otherwise.
- If neither exists, propose a root `CONTEXT.md` and create it only after the
  first term is settled and the user authorises repository writes.
- Propose `CONTEXT-MAP.md` only after discovery establishes multiple separately
  owned bounded contexts. Do not infer bounded contexts from directory layout
  alone. Put each context's `CONTEXT.md` near that context's source root.

An agreed map should link each context to its `CONTEXT.md` and state the
domain-level relationships between contexts. Transport choices, shared code
types, and other implementation mechanisms belong in ADRs unless they are
themselves settled domain language.

## Keep the glossary useful

Add a term only after its meaning is settled. Define what it is in one or two
sentences, use the canonical project term, and list genuinely confusing
alternatives under `_Avoid_`. Group terms beneath short topical headings only
when that makes a growing glossary easier to scan.

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
