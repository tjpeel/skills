# Claude Code delegation

Use Sonnet 5.5 for ordinary bounded work with an established approach; use
Opus 5.5 when difficult ambiguity, competing designs or synthesis warrants it.
Select model and effort separately. These are starting points, not measured
capability equivalence.

Sonnet profiles are `read_<band>` / `write_<band>`; Opus profiles are
`read_opus_<band>` / `write_opus_<band>`. Both families must be installed to
select between them. Bands are low, medium, high, xhigh and max.
`read_deep` aliases read_max; `read_exceptional` aliases read_xhigh.

Inspect configured subagents, including `~/.claude/agents` and the selected
repository's `.claude/agents`, and verify declared model, effort and tools.
A readable definition does not prove spawning or model access. Use Sonnet low
for factual observation; return routine work to Sonnet after difficult work.
Claude Fast supports selected Opus models and may use paid credits; do not
switch Sonnet to Opus solely for speed.
