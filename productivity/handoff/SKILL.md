---
name: productivity-handoff
description: Compact the current conversation into a redacted handoff document for a fresh agent to continue. Use when work needs to move to another session; do not use for an ordinary status update.
---

# Handoff

Write a compact Markdown handoff document so a fresh agent can continue the
work without reconstructing the conversation. Save it in the operating
system's temporary directory, never in the current workspace.

Use a new filename such as `codex-handoff-YYYYMMDD-HHMMSS.md`. The skill owns
only that file: do not overwrite an existing handoff document or change the
workspace while preparing it.

Capture the current objective, completed work, decisions and constraints,
remaining work, known risks or blockers, and the most useful next actions.
Reference existing specifications, plans, ADRs, issues, commits, diffs, and
other artifacts by path or URL instead of copying their content into the
handoff.

Include a `Suggested skills` section that names any skills the next agent
should invoke before continuing. Omit the section's entries when no skill is
needed. Redact credentials, secrets, personal data, and other sensitive
information.

If the user supplies an argument, treat it as the next session's focus and
tailor the handoff to that work.

## Delegation

Preparing one concise continuation document is a direct task; delegation does
not materially improve it. Do the synthesis in the coordinating agent.

## Source

Adapted from the public
[mattpocock/skills handoff skill](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md).
