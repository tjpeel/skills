# Writing skills

| Skill | Overview |
| --- | --- |
| [`unslop`](unslop/SKILL.md) | Revises supplied prose to sound more direct and specific while preserving its facts, voice, and format. |

## Using the workflow

Use `$writing-unslop` with supplied prose, its intended audience and any
format or voice to preserve. The surrounding document and the author's
stated style guide the edit. Facts, quotations, identifiers and certainty
stay intact unless the request says otherwise.

Prompts use source names. In Codex, use the prefixed installed name; in
Claude Code, use the source name. See [invocation guidance](../docs/installation.md#invoke-a-skill)
or ask the agent to read the selected `SKILL.md` directly.

```text
Use $writing-unslop on the passage below for an engineering audience.
Keep its facts, technical terms and Markdown structure. Make the prose
direct and specific, and return the clean revision.
<supplied passage>
```

For a selected file:

```text
Use $writing-unslop to edit <selected-file-path>. Preserve its facts, links,
commands, deliberate informality and existing format. Save the revision
in that file and summarise only material changes.
```

The default output is the clean revised passage. It removes vague claims,
repetition and unnecessary framing without inventing research or adding an
argument. Already concise prose may need little or no change. Specify the
file and write request when the revision should be saved; editing prose does
not authorise publishing it elsewhere.

Use this after an [engineering specification](../engineering/README.md#using-the-workflow)
or [PR draft](../pr/README.md#using-the-workflow) needs a prose edit. Technical
review and verification remain with those workflows; a clearer sentence does
not establish that its claim is true.
