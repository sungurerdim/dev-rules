# Synthesis Matrix — rule × disposition × evidence (Phase 2)

Structure decision: SINGLE lean core file (no weak-model extended tier).
Rationale: ETH 2602.11988 (limit to non-inferable), claude-code#22022 (long files ignored),
Cursor token-tax + Windsurf hard caps, arXiv 2507.11538 (instruction count). No evidence weak
models need MORE ambient rules — they suffer more from long context (2411.10541/2605.29676:
weaker models more format-sensitive; markdown safest). Tiering rejected; deployment stays 1 file.

## Dispositions (KEEP=unchanged, STR=strengthen, EXT=extend, CMP=compress, DEL=delete, NEW)

| Rule | Disp | Reason / evidence |
|---|---|---|
| Operating Loop | KEEP | GPT-5.6 outcome-first guide validates Target-as-spec; false-success 3% vs 45–75% (2606.09863) validates done=external-signal |
| Task Pre-flight | STR | RENAME Tier 1/2 → Small/Large task (user req: plain language) |
| Spec Artifact | KEEP | Codex compaction self-denial (codex#5957); Cline memory-bank pattern |
| Bounded Tasks | KEEP | METR horizon |
| Scope Boundary | EXT | mixed harness coverage; + pointer to durable capture |
| Test Integrity | EXT | 0/8 harnesses cover; + valueless-test prohibition (user req) as positive criterion, floor unchanged |
| Error Ownership | KEEP | 2605.29442: constraint-violation + inaccurate self-reporting grow over session time |
| Cross-file Consistency | KEEP | W2 |
| Over-engineering | KEEP | codex#12225 unrequested compat glue |
| File Creation | KEEP | W3 |
| Backwards-Compat Hacks | KEEP | codex#12225 direct evidence |
| Concurrency Safety | KEEP | W9 CodeRabbit 2× |
| External Content Injection | KEEP | 1/8 harness coverage — highest-value gap (harnesses.json); SC Media rules-file injection |
| Read-Before-Modify | KEEP | harness matrix: no harness has it unconditional |
| Finding Triage | KEEP | W5 |
| Verification-Infrastructure Gap | KEEP | W13 |
| Tool-Call Result Verification | STR | + empty-content-on-completed-turn (DeepSeek openclaw#84591), garbled/duplicated names (MiniMax koog#2093), format drift (Qwen#475, GLM vllm#42400) |
| Change Verification | KEEP | W2 |
| Migration Sweep | KEEP | W2 |
| Trust Verification | KEEP | Windsurf prompt actively anti-pattern (training-data fallback); USENIX slopsquat |
| Grounded Specifics | KEEP | #50235 fabrication |
| Format Preservation | KEEP | data-loss |
| Meaningful Test Data | KEEP | short |
| Non-Functional Accountability | KEEP | Tenzai |
| Artifact-First Recovery | STR | + codex#5957 compaction denial citation (rule-design only) |
| Subagent Output Verification | KEEP | proved in-session (Fable-suspension quarantine); MAST |
| Completion Gate | EXT | + CI Ownership (user req; 3× guard per MiniMax vendor guide "fails twice → stop" convergence) |
| Outcome Report | EXT | REWRITE to 3-field Task/Done/Gain (user req); + tracker durable-capture offer (user req, guarded) |
| Process Framework | EXT | + recurring-issue-class row → propose mechanical guard (Cherny automation ladder) |
| Complexity Limits table | CMP | one line; linter territory (detection-vs-enforcement) |
| Code Standards | KEEP | short |
| Error Messages table | CMP | 1 example pair (rule-design example density: 1–2 viable) |
| Error Handling | KEEP | short |
| Security | KEEP | Tenzai 69 vulns |
| i18n & a11y | KEEP | short |
| Observability tables | CMP | log levels = standard knowledge (Anthropic exclude table); keep structured+correlation-ID |
| Production Defaults table | CMP | keep fail-fast + no-hardcode + explicit timeouts as prose line; KPI-pressure 2512.20798 justifies keeping explicit |
| Database Changes | KEEP | pointer |
| Idempotency | KEEP | |
| Conventional Commits table | CMP | standard knowledge; keep 2-question decision in 2 lines |
| Toolchain Detection table | DEL | fully inferable (Anthropic exclude: "anything inferable from code") |
| Token & Context Efficiency | KEEP | context rot |
| LSP-First table | CMP | conditional 2 lines ("when language-server tools available") — tool-agnostic fix |
| Subagent Capability Routing table | CMP | 1 line |
| Commit History | KEEP | short |
| Tool Prerequisites table | CMP | 3 lines |
| Skip Patterns | KEEP | 1 line |
| Severity Levels table | CMP | 1 line |
| Fix Quality | KEEP | W20 GitClear |
| NEW: valueless-test prohibition | NEW | inside Test Integrity (user req + guard) |
| NEW: CI Ownership | NEW | inside Completion Gate (user req + guard) |
| NEW: durable capture | NEW | inside Outcome Report + Scope Boundary pointer (user req + guard) |
| NEW: recurring→mechanical | NEW | Process Framework row (Cherny; detection-vs-enforcement) |

Docs plan: rule-design.md += new sources (2602.11988, 2601.20404, 2606.09863, 2503.15223,
2605.29442, 2512.20798, 2603.25015, 2605.05391, 2602.04306, 2411.10541, 2605.29676, EvilGenie
2511.21654, TRACE 2604.15149, Push-Your-Agent 2605.23574, model issues URLs, vendor guides,
Cherny thread, Anthropic pruning heuristic) + Automation Ladder section + Rule Lifecycle
(intake ≥2 cases / sunset) + format-efficacy update + harness coverage matrix summary.
CLAUDE.md += two-customer criterion, lifecycle, pruning heuristic in pre-checks, Ruler note,
Small/Large rename. README += positioning w/ ETH + efficiency + harness gaps + Cherny.
DO NOT cite (unverified): 150-line threshold, GuideBench per-model %, IFEval/IFBench gap
figures, MAST % breakdown, AgentRx category names, Fable-suspension claim (quarantined).
