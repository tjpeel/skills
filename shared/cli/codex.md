# Codex delegation

Use Sol 6.1 profiles `read_<band>` and `write_<band>` with supported low,
medium, high, xhigh or max effort. `read_deep` aliases read_max;
`read_exceptional` aliases read_xhigh. No second Codex model is configured.

Inspect live tool declarations, `${CODEX_HOME:-$HOME/.codex}/agents` and the
selected repository's `.codex/agents`. Include linked TOML files and active
config_file registrations. Verify name, model, model_reasoning_effort and
sandbox_mode. A file alone does not prove spawning or model access.
