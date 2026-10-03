# Productivity skills

| Skill | Overview |
| --- | --- |
| [`handoff`](handoff/SKILL.md) | Saves a compact, redacted continuation document for a fresh agent. |

## Using the workflow

Use `$productivity-handoff` when work needs to continue in another session.
The current conversation supplies the objective, completed work, decisions,
constraints and remaining actions. Give the next session's focus when it
differs from the current one.

Prompts use source names. In either provider, use the prefixed installed name.
See [invocation guidance](../docs/installation.md#invoke-a-skill)
or ask the agent to read the selected `SKILL.md` directly.

```text
Use $productivity-handoff to prepare a fresh session to finish this change.
Include the current objective, selected inputs, decisions, commits, actual
verification results, remaining blockers and the smallest useful next steps.
The next session should focus on resolving the outstanding check.
```

The skill creates a new `agent-handoff-YYYYMMDD-HHMMSS.md` file in the active
repository's `.handoffs/` directory. It owns only that file and does not
overwrite an existing handoff. If it cannot resolve or write to that location,
it uses the operating system's temporary directory and reports the actual
path. If file writes are unavailable, it returns unsaved Markdown.

The document points to existing specifications, issues, commits and other
artifacts rather than copying them. It includes suggested skills where useful
and redacts secrets, personal data and other sensitive information. Creating
the handoff does not send it to another session or publish its contents.

Start the next session with the exact returned path:

```text
Read <exact-handoff-path> and continue the stated objective. Verify the
selected checkout, revision and input paths before resuming the next action.
```

Make referenced local artifacts available in that checkout. A saved handoff
does not transfer ignored process inputs or establish that linked files still
exist. For engineering work in another checkout, use the
[selected-input handoff](../engineering/README.md#local-work-folders).
