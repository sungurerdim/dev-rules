# Research Artifacts

Raw, agent-gathered research that grounds the rule set — kept for provenance and re-auditing, **never installed or loaded at runtime**.

⚠️ **Raw data, not canonical claims.** These files contain everything the research agents returned, including single-source, contested, and even quarantined-false claims (each is labeled with a confidence/verification field, and `synthesis.md` records the dispositions — e.g. the "Fable 5/Mythos 5 suspended" claim in `2026-07/models.json` was rejected as contradicted by direct observation). The verified, citable evidence base is `references/rule-design.md` — always cite that, not these files.

## 2026-07 — Rule set overhaul survey

| File | Content |
|------|---------|
| `peers.json` | Peer/competitor rule sets, AGENTS.md ecosystem, vendor rules-file guidance, effectiveness studies |
| `harnesses.json` | 10-behavior × 8-harness system-prompt coverage matrix + common gaps |
| `models.json` | Vendor prompting guides + documented failure modes (DeepSeek V4, GLM-5.x, Kimi K2.7, MiniMax, GPT-5.x, Claude, Qwen) |
| `literature.json` | Instruction-efficacy studies: format effects, false-success rates, failure taxonomies |
| `digest.md` | Condensed human-readable digest of all four artifacts |
| `synthesis.md` | Rule-by-rule disposition matrix (keep/strengthen/compress/delete/new) with evidence |
