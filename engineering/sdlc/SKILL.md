---
name: engineering-sdlc
description: Select and run all tickets in an SDLC work reference or one ticket from that reference.
---
# Run SDLC implementation

Use this skill from the target project. It helps select and launch SDLC work; repository settings and the SDLC CLI define the run configuration.

## Select and preview work

1. Check the installed CLI and its current run options:

    sdlc --version
    sdlc help run

2. Discover the work reference and inspect the project instructions, ticket files, linked requirements, and .sdlc/project.json:

    sdlc work --reference REF

3. Preview either the whole reference or one numbered ticket:

    sdlc run --reference REF --all --dry-run
    sdlc run --reference REF --ticket 01-ticket.md --dry-run

Review the selected repository, base, branch, tickets and dependencies, inputs, checks, runtime, and configured role settings. For a whole reference, use parallel execution only when the dependency plan permits it. Add an input only when the preview identifies a specific missing project-relative requirement. Do not put secrets in inputs.

Use provider or model overrides only when requested, and confirm the preview reflects them. Resolve routine selection issues from the repository's existing configuration and documented CLI behavior.

## Launch and follow the run

Run the exact previewed selection without --dry-run in a foreground session that can be monitored. Record its run ID and use the dashboard for progress:

    sdlc run --reference REF --all
    sdlc dashboard --json --run RUN_ID

For a single ticket, pass its numbered filename with --ticket instead of --all. If SDLC asks a question, use the existing project requirements to answer it; ask the user when the answer requires a product decision. For a stopped or blocked run, inspect its diagnosis before resuming:

    sdlc diagnose --run RUN_ID --json
    sdlc answer --run RUN_ID --text 'answer'
    sdlc resume --run RUN_ID

Do not start a second controller for a run that is still active.

## Runtime changes

Runtime status checks are read-only. If the selected runtime is missing, unavailable, or incompatible, stop and report the exact finding. Never build, rebuild, replace, migrate, or switch a runtime automatically, including to repair a status check. A runtime change requires the user's explicit authorization for that specific change and the documented procedure. Do not use --force or treat a general request to implement a ticket as permission to change a runtime.
