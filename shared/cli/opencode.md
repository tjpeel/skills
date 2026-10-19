# OpenCode with Synthetic delegation

The Synthetic profiles use `synthetic/hf:moonshotai/Kimi-K3`. Select
`<prefix>-read-<band>` or `<prefix>-write-<band>` by installed filename.
Bands describe workload only: Kimi profiles do not set reasoning effort or
claim that band names change inference settings. A request for another model
or an unsupported effort control must be reported to the coordinator.

Inspect the live task tool and agent definitions in
`${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents` and the selected project's
`.opencode/agents`. Read model, mode and permission settings. Read profiles
allow only read, glob and grep tools; write profiles also permit edit and bash.
Neither profile permits task delegation. Permissions are a runtime boundary,
not proof of model access or live spawning. Use skill discovery to load a
referenced installed skill by its declared name; `$name` is a source reference,
not assumed OpenCode invocation syntax.
