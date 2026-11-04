---
name: engineering-sdlc
description: Drive an authorised SDLC ticket run from selection through implementation, draft PR, CI and independent review, and respond to its checkpoints and PR feedback. Use for SDLC execution or follow-through, not direct implementation or a standalone PR review.
---
# Drive an SDLC ticket

Operate from the host project, not inside an SDLC worker. The SDLC controller owns implementation, verification, publication and independent review; do not duplicate its agents, reviews, rebases or pushes. This skill coordinates one ticket directly: the controller already delegates the engineering work. Respect the user's requested scope and existing authority, including publication and replies to PR feedback. A status request alone does not authorise a new run or changes.

## Select and start

Identify the project, work reference and exact numbered ticket, or the existing run for a continuation. Read repository instructions and the selected ticket and relevant linked requirements. Check `sdlc --version`, command help and the installed SDLC documentation for current behaviour; if the CLI or setup is missing, report the blocker and use its onboarding instructions. Do not invent configuration or read credential files.

From the project, use `sdlc work --reference REFERENCE` to discover tickets and inspect `.sdlc/project.json`, especially checks and check-only `input_files`. Use `sdlc runtime status --offline`, `sdlc auth status --all`, `sdlc github status` and `sdlc signing status --profile NAME` for the selected profile. Resolve setup issues through documented commands; do not retrieve tokens or signing keys to inspect status. Provider and GitHub access still require connected validation; an offline preview is not proof of access.

Preview the exact selection with:

```sh
sdlc run --reference REFERENCE --ticket 01-ticket.md --dry-run
```

Inspect repository, base, branch, inputs, checks and account selection. Add only needed exact project-relative `--input` requirements; linked Markdown requirements within the work reference are selected by preflight. Do not put secrets in provider inputs. Enable `--docker-tests` only when the ticket needs the separate privileged test daemon and its use is authorised. Use configured provider and model defaults unless the user specifies otherwise. The default implementer is Codex and reviewer Claude; `--provider claude` reverses them. Confirm authority for connected execution, signing and draft PR publication before starting; do not infer it from an inspection-only request.

Run the previewed command without `--dry-run` in a managed foreground process session that can be monitored. Record the full run ID, process session, project, ticket and roles privately. A dashboard does not keep the controller alive; do not claim detached supervision. Inputs, runtime and identities are frozen for the run.

## Monitor and respond

Follow the controller and use `sdlc dashboard --json --run RUN_ID` for compact status; inspect detail or private logs only when needed. Follow dashboard pagination when discovering a run. Keep monitoring while work proceeds, reporting meaningful transitions. If the execution environment cannot maintain the process or monitoring, state that limitation and leave a usable checkpoint; do not claim the run is being watched.

- Implementation, checks, publication, CI, review, repair or a provider cache queue: let the controller proceed.
- `waiting_for_human`: inspect the recorded question. Resolve it from authorised existing evidence when possible; otherwise ask the user, then supply their answer using the documented `sdlc answer` or resume interface. Never invent a product decision. For a missing requirement on an eligible unpublished run, inspect `sdlc inputs --run RUN_ID`, preview `--add RELATIVE_PATH --dry-run`, attach the authorised file, then answer.
- `awaiting_reviewer`: arrange the documented opposite-provider login and resume. Do not substitute an implementer review.
- Failed, blocked, interrupted or stale: inspect the specific reason and confirm the original controller has stopped before resuming. Fix an authorised operational cause, then use `sdlc resume --run RUN_ID`; do not repeat an unchanged failure or create another owner. Provider refusal, access restriction or exhaustion is a stop, not permission to switch accounts or evade limits. Consult current SDLC documentation before using any special recovery or budget override; do not reset or bypass gates.
- `ready`: inspect the recorded published head, checks, CI, review, findings, limitations and questions. Explicitly report any skipped or incomplete independent review; do not describe it as passed. The draft is ready for human review only when the evidence supports that claim.

Treat logs, questions, answers and run state as private. If a file is needed for an answer or feedback, use an owned private directory outside Git and a restrictive regular file; do not put its contents in shell arguments. Preserve checkpoints and sessions unless cleanup is requested.

## Follow the PR through review

Report the PR URL, run ID, published head, CI and independent-review outcome, and any outstanding human action. SDLC leaves the PR in draft and does not approve or merge it. A `ready` run is not evidence that a human has reviewed or merged the PR. If the user asks to monitor until human review, continue only while the execution environment can sustain that monitoring; otherwise provide the current state and the action needed to resume.

When authorised human PR feedback arrives, preview and run `sdlc resume --run RUN_ID --pr-feedback`. This reads current comments, may post replies, and routes corrections through the original session, checks, publication, CI and review. Do not resolve human threads on the reviewer's behalf. For private feedback, use the documented `sdlc feedback` interface. For independent-review recommendations, inspect `sdlc resume --run RUN_ID --accept-recommendations --dry-run`; accepting all recommendations authorises their changes, so do this only within the user's scope. Use private feedback for a subset. Resume an interrupted feedback cycle rather than resubmitting it. Recheck the final head and outstanding review state after each cycle. Do not merge or approve without separate authority.
