---
name: writing-unslop
description: Edit prose to remove generic AI-sounding language while preserving the author's facts, voice, and intended format. Use when asked to "unslop," humanise, tighten, or make supplied writing sound less AI-generated; do not use to change a deliberately stylised voice.
---

# Unslop writing

Make the supplied writing sound like it was written with intent. Keep its
meaning, evidence, audience, and requested format intact. Edit the text rather
than adding a new argument, research, or unsupported detail.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment. If a platform does not support direct skill invocation,
read and apply this `SKILL.md` directly; the editing standard does not change.

## First, establish the target

- Treat the surrounding document, examples, and the user's stated voice as the
  style authority. Do not flatten deliberate informality, technical language,
  humour, regional spelling, or a house style.
- Preserve quoted material, code, identifiers, commands, citations, and facts
  unless the user asks to change them. Never invent a source, statistic,
  customer, or outcome to make a sentence sound more concrete.
- If the text is already concise and specific, say so and make only edits that
  materially improve it.

## Edit for substance before surface

Read the whole passage, then revise the places where the language hides the
point or makes a claim feel unearned.

- Replace broad praise and abstract promises with the actual behaviour,
  constraint, example, measurement, or decision when the text supplies one.
  If it does not, make a narrower claim or remove it.
- Remove scene-setting, summary sentences, and conclusions that merely repeat
  what the surrounding text already establishes.
- Name a source when the text relies on an attribution; otherwise avoid
  anonymous appeals to experts, users, or the industry.
- Prefer a direct subject and verb. Split a sentence when several qualifications
  compete for attention. Use passive voice only when the actor is unknown or
  irrelevant.
- Choose ordinary, precise words over inflated synonyms, consultant metaphors,
  and vague verbs such as "leverages", "showcases", or "serves as" when a
  concrete verb is available.

## Remove common generated-writing signals when they are not intentional

Look for patterns rather than running a mechanical word blacklist:

- rehearsed transitions and framing, such as announcing that a point is
  important before making it;
- empty intensifiers, excessive qualifiers, and stacked adverbs;
- forced contrasts, false ranges, or neat lists that obscure a simpler point;
- repeated synonyms for the same thing instead of one stable term;
- generic claims that could describe any product, project, or person;
- over-explained headings, bold-label lists, decorative emojis, and punctuation
  used as a substitute for sentence structure; and
- chatbot greetings, reassurance, praise, or invitations to continue when a
  direct response is more useful.

These are prompts to inspect the writing, not bans. Keep a phrase or device
when it carries the author's voice or helps the reader understand the point.

## Check the result

Read the revision as its intended audience would. It should state something
specific, use the natural number of examples or steps, and make its important
claim without rhetorical scaffolding. Check that no edit changed a fact,
certainty level, technical term, quotation, or instruction.

When returning an edited passage, provide the clean revision by default. Add a
short explanation of the main changes only if the user asks for one or if an
ambiguity required a conservative choice.

## References

- [Repository README](../../README.md) explains how this skill is installed and
  maintained with the rest of the catalogue.
- This independently written skill was informed by the public
  [Cursor plugins repository](https://github.com/cursor/plugins).
