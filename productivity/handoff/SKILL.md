---
name: productivity-handoff
description: Compact the current conversation into a redacted handoff document for a fresh agent to continue. Use when work needs to move to another session; do not use for an ordinary status update.
---

# Handoff

Write a compact Markdown handoff document so a fresh agent can continue the
work without reconstructing the conversation. First, resolve the active
repository's root and try to save the document in its `.handoffs/` directory.
Create that directory if it does not exist. If the repository cannot be
resolved, the directory cannot be created, or the document cannot be written
there, save it in the operating system's temporary directory instead.

Use a new filename such as `agent-handoff-YYYYMMDD-HHMMSS.md`. The skill owns
only that file: do not overwrite an existing handoff document or modify other
workspace files. Report the path that was actually written.

## Platform compatibility

This workflow is platform-agnostic. Use it in Codex, Claude Code, or another
agent environment with equivalent filesystem access. Follow all applicable
repository instructions: this normally includes `AGENTS.md` in Codex and
`CLAUDE.md` in Claude Code. If the platform cannot write a file, return the
handoff as Markdown and state that it was not saved.

Capture the selected continuation objective and only the completed work,
decisions, constraints, remaining work and next actions needed to resume it.
Include past work only when it explains the current state or a constraint.
An access problem belongs here only while it blocks a necessary next action;
record the blocker and next step, not its troubleshooting history. Omit
unrelated conversation, obsolete questions and personal circumstances.
Reference existing specifications, plans, ADRs, issues, commits, diffs, and
other artifacts by path or URL instead of copying their content into the
handoff.

Include `Suggested skills` only when the next agent needs to invoke one;
otherwise omit the section. Redact credentials, secrets, personal data, and other sensitive
information.

If the user supplies an argument, treat it as the next session's focus and
tailor the handoff to that work.

## Delegation

Preparing one concise continuation document is a direct task; delegation does
not materially improve it. Do the synthesis in the coordinating agent.
