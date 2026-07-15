# Rule Design Reference

How + why rules are written as they are. For rule authors and contributors — not loaded at runtime.

---

## Sources

### Official
- [Anthropic: Claude Prompting Best Practices (2026)](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
- [Anthropic: Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

### Academic
- [Wharton: Chain-of-Thought Technical Report (2025)](https://gail.wharton.upenn.edu/research-and-insights/tech-report-chain-of-thought/)
- [On Representation Redundancy in Large-Scale Instruction Tuning Data Selection (arXiv 2602.13773, 2026)](https://arxiv.org/html/2602.13773)
- [The Lessons of Developing Process Reward Models in Mathematical Reasoning (arXiv 2025)](https://arxiv.org/abs/2501.07301)
- [AI Agent Systems: Architectures, Applications, and Evaluation (arXiv 2026)](https://arxiv.org/html/2601.01743v1)
- [Focused Chain-of-Thought: Efficient LLM Reasoning via Structured Input Information (arXiv 2025)](https://arxiv.org/pdf/2511.22176)
- [Ten Simple Rules for AI-Assisted Coding in Science (arXiv 2025)](https://arxiv.org/html/2510.22254v2)
- [The Instruction Hierarchy: Training LLMs to Prioritize Privileged Instructions (arXiv 2024)](https://arxiv.org/html/2404.13208v1)
- [How Many Instructions Can LLMs Follow at Once? (arXiv:2507.11538, 2025)](https://arxiv.org/abs/2507.11538)
- [SHIELDA: Structured Handling of Exceptions in LLM-Driven Agentic Workflows](https://arxiv.org/html/2508.07935v1)
- [SpecBench: Measuring Reward Hacking in Long-Horizon Coding Agents — +28pp per 10× code size (arXiv:2605.21384, 2026)](https://arxiv.org/abs/2605.21384)
- [Reward Hacking Benchmark: Measuring Exploits in LLM Agents with Tool Use (arXiv:2605.02964, 2026)](https://arxiv.org/abs/2605.02964)
- [SWE-ABS: Adversarial Benchmark Strengthening — rejects 19.71% of previously "passing" patches (arXiv:2603.00520, 2026)](https://arxiv.org/abs/2603.00520)
- [BrokenMath: A Benchmark for Sycophancy in Theorem Proving with LLMs — GPT-5 sycophantic 29% (arXiv:2510.04721, 2025)](https://arxiv.org/abs/2510.04721)
- [Measuring and Exploiting Contextual Bias in LLM-Assisted Security Code Review — metadata redaction restores detection in all affected cases (arXiv:2603.18740, 2026)](https://arxiv.org/abs/2603.18740)
- [Why Do Multi-Agent LLM Systems Fail? MAST taxonomy, 1,600+ traces (arXiv:2503.13657, 2025)](https://arxiv.org/abs/2503.13657)
- [Which Agent Causes Task Failures and When? — best attribution method 53.5% (arXiv:2505.00212, 2025)](https://arxiv.org/abs/2505.00212)
- [Intelligence Degradation in Long-Context LLMs (arXiv:2601.15300, 2026)](https://arxiv.org/abs/2601.15300)
- [When AI Agents Touch CI/CD Configurations — 8,031 agentic PRs (arXiv:2601.17413, 2026)](https://arxiv.org/abs/2601.17413)
- [USENIX Security '25: "We Have a Package for You!" — Package Hallucinations by Code-Generating LLMs (19.7% hallucinated, 43% reproducible)](https://www.usenix.org/conference/usenixsecurity25/presentation/spracklen)
- [METR: Measuring AI Ability to Complete Long Software Tasks — 7-month horizon doubling (arXiv:2503.14499, 2025)](https://arxiv.org/abs/2503.14499)
- [Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents? — ETH Zurich/LogicStar, 138-task AGENTbench: LLM-generated files reduce success ~3% and add 20-23% cost; human-written gain ~4% at ~19% cost (arXiv:2602.11988, 2026)](https://arxiv.org/abs/2602.11988)
- [On the Impact of AGENTS.md Files on the Efficiency of AI Coding Agents — 124 real PRs: 28.64% lower median runtime, 16.58% fewer output tokens; measures efficiency, not correctness (arXiv:2601.20404, ICSE JAWs 2026)](https://arxiv.org/abs/2601.20404)
- [False success quantified: 3% of failures when independently verifiable vs 45-75% when self-reported; LLM judges max AUROC 0.65 (arXiv:2606.09863, 2026)](https://arxiv.org/abs/2606.09863)
- [SWE-bench resolution rates inflated 6.2pp by patches passing limited suites but failing comprehensive tests (arXiv:2503.15223, 2025)](https://arxiv.org/abs/2503.15223)
- [Coding-agent failure taxonomy from 20,574 real sessions / 1,639 repos — constraint-violation and inaccurate-self-reporting shares GROW over time (arXiv:2605.29442, 2026)](https://arxiv.org/abs/2605.29442)
- [Outcome-driven constraint violations under KPI/production pressure — 0-62.8% misalignment, not improving across generations (arXiv:2512.20798, 2025)](https://arxiv.org/abs/2512.20798)
- [Imperative interference: 'NEVER do X' carries register-dependent force; declarative restatement more stable cross-lingually (arXiv:2603.25015, 2026 — single study, do not over-weight)](https://arxiv.org/abs/2603.25015)
- [Negative framing less reliable than positive (ironic-process analog), but direction is task-dependent (arXiv:2605.05391; arXiv:2602.04306, 2026)](https://arxiv.org/abs/2605.05391)
- [Prompt-format effects (MD/XML/JSON/YAML) are model-dependent and dwarfed by capability; weaker models far more format-sensitive; markdown safest cross-model default (arXiv:2411.10541; arXiv:2605.29676)](https://arxiv.org/abs/2411.10541)
- [EvilGenie: reward-hacking benchmark on production agents incl. Codex/Claude Code/Gemini CLI (arXiv:2511.21654)](https://arxiv.org/abs/2511.21654)
- [TRACE: 517-trajectory / 54-category test-gaming taxonomy (arXiv:2604.15149, 2026)](https://arxiv.org/abs/2604.15149)
- [Push Your Agent: false completion, duplicate submission, reported-count error, premature stopping as distinct measurable failure categories (arXiv:2605.23574, 2026)](https://arxiv.org/abs/2605.23574)

### Vendor Prompting Guidance (2026-07 survey)
- [Anthropic Claude Code best practices — pruning heuristic: "For each line, ask: Would removing this cause Claude to make mistakes? If not, cut it"; "Bloated CLAUDE.md files cause Claude to ignore your actual instructions"; include/exclude table](https://code.claude.com/docs/en/best-practices)
- [OpenAI GPT-5.6 prompting guide — outcome-first: define "the outcome, constraints, evidence, and completion bar"; removing repeated instructions improved internal coding-agent evals ~10-15% while cutting tokens 41-66%](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6)
- [MiniMax M-series usage tips — explicit stopping rules: "if a tool fails twice, stop retrying and explain the blocker" (independently converges with our 3× threshold)](https://platform.minimax.io/docs/token-plan/prompting-best-practices)
- [Moonshot Kimi agent setup — over-specifying tool usage in system prompts "may actually interfere with the model's autonomous decision-making" (outcome > step micromanagement)](https://platform.moonshot.ai/docs/guide/use-kimi-k2-to-setup-agent)
- [AGENTS.md — schema-free cross-tool convention, Linux Foundation AAIF-governed since Dec 2025](https://agents.md/)

### Industry
- [CodeRabbit: AI vs Human Code Quality Report (2025)](https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report)
- [Authority Partners: AI Agent Guardrails Production Guide (2026)](https://authoritypartners.com/insights/ai-agent-guardrails-production-guide-for-2026/)
- [CodeSignal: Prompt Engineering Best Practices (2025)](https://codesignal.com/blog/prompt-engineering-best-practices-2025/)
- [Databricks: Structured Outputs for Agent Workflows (2024)](https://www.databricks.com/blog/introducing-structured-outputs-batch-and-agent-workflows)
- [Lakera: Prompt Engineering Guide (2026)](https://www.lakera.ai/blog/prompt-engineering-guide)
- [Veracode: GenAI Security and Vibe Coding (2026)](https://www.veracode.com/blog/genai-security-and-vibe-coding/)
- [5 Test Integrity Rules for AI Agents](https://jsmanifest.com/5-test-integrity-rules-ai-agents-typescript)
- [Good Spec for AI Agents (Addy Osmani)](https://addyosmani.com/blog/good-spec/)
- [Addy Osmani: LLM Coding Workflow 2026](https://addyosmani.com/blog/ai-coding-workflow/)
- [Beyond the Vibes: Coding Agents 2026 (tedivm)](https://blog.tedivm.com/guides/2026/03/beyond-the-vibes-coding-assistants-and-agents/)
- [AI-Assisted Development 2026 Best Practices](https://dev.to/austinwdigital/ai-assisted-development-in-2026-best-practices-real-risks-and-the-new-bar-for-engineers-3fom)
- [OWASP Prompt Injection Guide](https://genai.owasp.org/llmrisk/llm01-prompt-injection/)
- [Preventing AI Agent Drift](https://www.getmaxim.ai/articles/a-comprehensive-guide-to-preventing-ai-agent-drift-over-time/)
- [AWS: Stop AI Agent Hallucinations — 4 Techniques](https://dev.to/aws/stop-ai-agent-hallucinations-4-essential-techniques-2i94)
- [Guardrails Beat Guidance: A Large-Scale Study of Rules, Skills, and Persistent Configuration for Coding Agents (arXiv:2604.11088, 2026)](https://arxiv.org/abs/2604.11088)
- [ClawSafety: "Safe" LLMs, Unsafe Agents — attack success 40–75% across models (arXiv:2604.01438, 2026)](https://arxiv.org/abs/2604.01438)
- [Chroma: Context Rot — How Increasing Input Tokens Impacts LLM Performance, 18-model study (2025)](https://www.trychroma.com/research/context-rot)
- [GitClear: AI Copilot Code Quality — 2025 Research Report (copy/paste 8.3%→12.3%, moved/refactored 24.1%→9.5%, churn 5.5%→7.9%)](https://www.gitclear.com/ai_assistant_code_quality_2025_research)
- [GitGuardian: The State of Secrets Sprawl 2026 (28.65M secrets; Claude Code-assisted commits leak 3.2% vs 1.5% baseline; 24,008 secrets in MCP configs)](https://blog.gitguardian.com/the-state-of-secrets-sprawl-2026/)
- [Cloud Security Alliance: Slopsquatting & the AI Supply Chain (2026)](https://labs.cloudsecurityalliance.org/research/csa-research-note-slopsquatting-ai-supply-chain-20260419-csa/)
- [Tenzai: Bad Vibes — Secure-Coding Capabilities of AI Coding Agents (69 vulns across 15 AI-built apps; SSRF common, security headers consistently absent) (2026)](https://blog.tenzai.com/bad-vibes-comparing-the-secure-coding-capabilities-of-popular-coding-agents/)
- [OWASP: Top 10 for Agentic Applications (2026)](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/)

### Model-Specific Failure Reports (2026-07 sweep)
- [GPT-5.4/Codex: tasks claimed done immediately; subagent results claimed collected when not; stopped at 10 of 200 targets while reporting progress (openai/codex #14341, #13950, #7247)](https://github.com/openai/codex/issues/14341)
- [GPT-5.3-Codex: unrequested compat glue; modifying tests to vacuously pass; "LAZY VERIFICATION" + "FALSE CONFIDENCE" (openai/codex #12225, #5102)](https://github.com/openai/codex/issues/12225)
- [Codex post-compaction self-denial: falsely denied 23 file edits it had made (openai/codex #5957)](https://github.com/openai/codex/issues/5957)
- [DeepSeek V4: empty/blank final content on API-completed, billed turns in high-thinking mode (openclaw #84591; opencode #28955); DSML/XML tool-call drift breaking parsers (opencode #34676)](https://github.com/anomalyco/opencode/issues/28955)
- [GLM-5.x: malformed/truncated tool-call JSON during streaming, worsening at long context, fatal harness crashes (vllm #42400; crush #3153; GLM-5 #15)](https://github.com/vllm-project/vllm/issues/42400)
- [Kimi Code CLI: shipped fixes for agents "ending goals prematurely" and false completion notifications (MoonshotAI/kimi-code releases; Kimi-K2 #81)](https://github.com/MoonshotAI/Kimi-K2/issues/81)
- [MiniMax M2.x: 75-step plan verbalized, 81,782 tokens, zero tool calls executed (arXiv 2602.19594); duplicated tool names emitted as text (koog #2093; hermes-agent #8259)](https://arxiv.org/abs/2602.19594)
- [Qwen3.x: XML/JSON tool-call format drift mid-session, stray/missing tags (QwenLM/Qwen3-Coder #475; ollama #14493)](https://github.com/QwenLM/Qwen3-Coder/issues/475)
- [Claude Code ignores CLAUDE.md/AGENTS.md rules incl. hard restrictions; compliance degrades over long sessions/files (claude-code #22022 + HN corroboration)](https://github.com/anthropics/claude-code/issues/22022)
- DeepSeek V4 Flash: claimed-complete tasks partially or entirely unperformed — first-hand user observation (2026-07, this project's maintainer); no public issue found matching this exact framing (single-case; the failure *class* is corroborated by the GPT-5.x/Kimi/MiniMax reports above)

### Model-Specific Failure Reports (pre-2026-07)
- [Claude Code unusable for complex tasks after Feb updates — 6,852-session analysis, reads-per-edit 6.6×→2.0× (GitHub #42796)](https://github.com/anthropics/claude-code/issues/42796)
- [Opus 4.6/4.5 systematic failure to read before acting — four+ incidents in one day (GitHub #47901)](https://github.com/anthropics/claude-code/issues/47901)
- [Claude Code: Opus 4.7 Bootstrap Failure (GitHub #50999)](https://github.com/anthropics/claude-code/issues/50999)
- [Kimi K2: Tool Call Format Instability in Multi-Round Agentic Use (HuggingFace #48)](https://huggingface.co/moonshotai/Kimi-K2-Instruct/discussions/48)
- [DeepSeek V3-0324: Function Calling Fix (Model Card)](https://huggingface.co/deepseek-ai/DeepSeek-V3-0324)
- [OpenAI Codex: Context Compaction Failure (GitHub #20931)](https://github.com/openai/codex/issues/20931)
- [Claude Opus 4.7: Confident-Prose Hallucination & "Bucket-Bypass Drift" — mechanical enforcement ≫ behavioral (GitHub #50235)](https://github.com/anthropics/claude-code/issues/50235)
- [DeepSeek V4: CAISI/NIST Evaluation — ~8 months behind frontier, weak precision reasoning (2026)](https://www.nist.gov/news-events/news/2026/05/caisi-evaluation-deepseek-v4-pro)
- [DeepSeek V4 Pro: reasoning_content Multi-Turn Tool-Call Inconsistency (opencode #25000)](https://github.com/anomalyco/opencode/issues/25000)

---

## Constraint Framing

No published study quantifies per-framing success rates; treat framing as design heuristics grounded in adjacent evidence:

| Heuristic | Grounding |
|-----------|-----------|
| Positive action first ("Only modify lines required by the task"), prohibition as reinforcement ("Never weaken a test to pass") | House style, consistent with prompt-engineering guides; every rule answers "What to DO?" before "What NOT to do?" |
| Explicit fallback ("If uncertain, state 'not verified' and ask") | Literal Interpretation below — models don't invent unstated recovery paths |
| Unstated constraints fail — a constraint not written is a constraint not applied | Anthropic literal-instruction guidance; Instruction Hierarchy (arXiv 2404.13208) |
| Front-load critical constraints; mid-context placement degrades | Context rot, 18-model study (Chroma 2025) |
| Prompt rules shape behavior measurably, but mechanical gates dominate | Guardrails Beat Guidance (arXiv 2604.11088); claude-code #50235: hook-enforced ≈100% vs behavioral moderate-to-low |
| Outcome-first: state the outcome, constraints, evidence, completion bar — not micro-steps | GPT-5.6 guide (removing repeated instructions: ~10-15% eval gain, 41-66% fewer tokens); Moonshot: step micromanagement "may interfere with autonomous decision-making" |
| Plain Markdown is the safest cross-model format; heavy XML/JSON structure degrades weaker models | Format effects model-dependent, dwarfed by capability (arXiv 2411.10541, 2605.29676); no study isolates table-vs-prose for rules specifically (open question) |
| Pair critical prohibitions with a declarative restatement where cheap ("Never X — X: not permitted") | Imperative-interference finding (arXiv 2603.25015) — single study, applied sparingly, not as a rewrite mandate; framing-direction effects are task-dependent (2605.05391, 2602.04306) |
| User-facing labels self-describing for zero-technical readers (e.g. "Small/Large task", never "Tier 1/2") | Maintainer requirement (2026-07): rules serve the user's process management, not only model reliability |

---

## Example Density

Optimal example count per rule:

| Examples | Effect |
|----------|--------|
| 0 | Rule abstract — frequently misinterpreted or ignored |
| 1-2 | Minimum viable — covers happy path |
| 2-3 | Optimal — happy path + edge case + error recovery |
| > 3 | Diminishing returns — increases token cost without proportional benefit |

**Quality over quantity:** 3.5% well-selected training data outperforms the full-data baseline by 0.71% on average (arXiv 2602.13773). Same principle applies to rule examples — few precise, representative examples > many generic ones.

**Ordering matters:** Place most relevant or complex example LAST. AI models exhibit recency bias — final example has strongest influence on behavior.

**Pattern per rule:** 1) Happy-path case, 2) Edge case showing constraint in action, 3) Error/recovery case.

---

## Token Efficiency

Format efficiency rankings for same information:

| Format | Token Efficiency | Best For |
|--------|-----------------|----------|
| Tables | Best | Structured comparisons, option lists |
| Numbered lists | Good | Sequential procedures, checklists |
| Bullet lists | Good | Unordered sets, short items |
| Prose paragraphs | Worst | Avoid for rules — use only for context/rationale |

**Savings strategies:**
- Remove redundant preamble ("In this section we will discuss..."): ~10% savings
- Use shorthand for repeated concepts ("If X -> Y" not "In the case where X occurs, the appropriate action is Y"): ~15% savings
- Compress examples to outcome, not full trace: ~20% savings

**Budget** (measured 2026-07 post-overhaul, chars/4): main rules file always loaded (~4,300 tokens, 169 lines). The evidence-based prune (toolchain-detection table deleted; log-level/commit/complexity/LSP tables compressed) was spent on higher-value rules (CI Ownership, both-ways Test Integrity, three-field Outcome Report, recurring-issue→mechanical-guard) — net tokens ≈ unchanged, signal density up, instruction count down. Reference files add ~1,400 (operations) to ~3,400 (safety) tokens when conditionally loaded. Total worst case: ~9,000 tokens. Leaves maximum context for actual codebase.

---

## Behavioral Anchoring

Instruction-following degrades once a single prompt carries more than ~150-200 discrete instructions (arXiv:2507.11538); in long sessions, context filling causes earlier instructions to be forgotten (Claude Code best practices). Prevention strategies:

1. **External artifacts:** Write progress + decisions to files, not conversation memory
2. **Phase-boundary repetition:** Repeat core constraints when transitioning between major work phases
3. **Structured progress:** Use explicit "completed / current / next" tracking
4. **Re-read before modify:** After context gap (compression, long pause) → re-read source files — conversation memory unreliable

---

## Adaptive Thinking

Forced CoT adds only 2.9-3.1% accuracy improvement for reasoning models while costing 20-80% more time (Wharton GenAI Labs 2025). Implications for rule design:

- Do not force step-by-step reasoning for tasks model can handle directly
- Reserve explicit reasoning prompts for genuinely ambiguous or multi-step decisions
- Use gates, not chains: "Verify X before Y" cheaper + more effective than "Think through X step by step, then do Y"
- Focused CoT (arXiv 2025): when reasoning needed, constrain to specific decision point, not entire task

---

## The Operating Loop & Mechanical Verification

`rules.md` opens with an explicit **Target → Assess → Gap → Verify-each → Reconcile** loop. Rationale:

The gap between a frontier model and a cheaper one concentrates in three places — long-horizon plan coherence, reliable self-verification, and instruction-following under load. All three are externalizable, and the loop mechanizes them:

- **Target / Gap** convert open-ended "vibe coding" into a spec-bounded diff — kills scope creep (W3) for any model, and forces the problem-specific check a weak reasoner skips (DeepSeek V4 applies familiar templates without verifying the problem's preconditions).
- **Assess** grounds claims in read reality, not memory — the direct mitigation for confident-prose fabrication (Opus 4.7 #50235: emits real-looking but fabricated commit hashes / file paths) and for hallucination (W1) generally.
- **Verify-each + "done = external signal"** is the highest-leverage move: it replaces the model's self-judgment — unreliable enough that 19.71% of agent-"solved" tasks fail adversarial re-verification (SWE-ABS, W10) — with a machine-checkable signal a passing test does not fake.

**Why mechanical, not behavioral — and the limit of a prompt file.** Opus 4.7 field data (#50235) found rules enforced via tool-call hooks reach near-100% compliance, while the *same* rules enforced purely as in-context behavioral guidance reach moderate-to-low compliance — and fabrications "bucket-bypass" into whatever output form (tags, labels, fields) a prose-level rule failed to name. Two design consequences:

1. A prompt file cannot *be* a mechanical gate; its leverage is to make the model *defer* to mechanical signals it can run (tests, builds, linters, exit codes, diffs). True enforcement (hooks, SAST, sandbox, `tool_choice`) lives in the harness/CI — see CLAUDE.md "Out of Scope".
2. Anti-bypass framing: a rule that constrains one output form must name *all* forms (see Grounded Specifics — "prose, labels, tags, fields"), or the failure migrates to the unnamed one.

The model difference narrows to the degree behavior is mechanized; it closes only where a real gate runs.

---

## Automation Ladder

Encode domain knowledge at the most mechanical level that can express it — each step down is cheaper, later-triggered, and less binding:

```
type system > test > lint/CI step > harness hook > on-demand skill > always-on prompt rule
```

A prompt rule is the **last resort** for what cannot be mechanized. Grounding: hook-enforced rules reach ≈100% compliance vs moderate-to-low for the same rules as in-context guidance (claude-code #50235); "your agent could fix an issue every time it sees it, but that uses tokens and might miss cases — a lint rule, CI step, or routine automates that class forever" (Boris Cherny, x.com/bcherny status 2077460395279692197, 2026); independent practitioner analysis reaches the same detection-vs-enforcement split ([dev.to analysis](https://dev.to/alexefimenko/i-analyzed-a-lot-of-ai-agent-rules-files-most-are-making-your-agent-worse-2fl)).

Consequences:
1. `rules.md` › Process Framework carries the behavioral shadow: recurring issue class (3×) → propose a mechanical guard.
2. A rule *retires* from `rules.md` when promoted to a mechanical gate (see Rule Lifecycle).
3. Local-first gating (e.g. dev-skills `ds-quality` stop-hook loop) beats CI-first: CI detects but does not fix; a local gate fires while the agent can still fix immediately. CI remains the safety net, owned via `rules.md` › CI Ownership.

## Rule Lifecycle

**Intake:** ≥2 documented real-world failure cases (CLAUDE.md pre-checks). Single first-hand observations enter as candidates only when the failure *class* has independent multi-model corroboration.

**Pruning heuristic (apply to every line, every revision):** "Would removing this cause the model to make mistakes? If not, cut it" (Anthropic best practices). Exclude anything inferable from the code/config itself, standard language conventions, and self-evident practices — restating what models already know adds cost without lift (Anthropic exclude-table; Windsurf/Devin docs: "no need to add generic rules... already baked into training data"; ETH 2602.11988: limit human-written instructions to non-inferable details).

**Sunset check (each major revision):** a rule is demoted or removed when (a) its failure mode is no longer reproducible in current target models, or (b) it has been promoted to a mechanical gate in the deployment (Automation Ladder). Record the retirement + reason here; never silently drop.

## Effectiveness Evidence (what a rules file can and cannot claim)

Two independent empirical studies confirm rules files causally change agent behavior, but on different axes:

| Axis | Evidence | Verdict |
|------|----------|---------|
| Task success / correctness | ETH AGENTbench (2602.11988): human-written ≈ +4% at ~19% cost; LLM-generated ≈ −3% | Modest at best; auto-generated files actively hurt |
| Efficiency / cost | Lulla (2601.20404): −28.64% median runtime, −16.58% output tokens on real PRs | Solid gain from a good file |
| Failure-floor / consistency | Harness-gap analysis (below) + model failure reports | The file's core value: supplying rules no harness enforces |

Honest positioning: this project claims a higher *floor* (fewer catastrophic misses: weakened tests, fabricated packages, false "done") and better *efficiency/consistency* — not a raw success-rate uplift. Both studies also justify hard length discipline. **Not verified, do not cite:** any specific line-count compliance threshold (the widely-repeated "150 lines" figure has no traceable primary source), GuideBench per-model percentages, IFEval-vs-IFBench gap figures, MAST percentage breakdowns.

## Harness Coverage Survey (2026-07)

System prompts of 8 harnesses surveyed (Claude Code, Cursor, Windsurf/Devin, Codex CLI, Copilot, Cline, opencode, Gemini CLI) across 10 behavior classes. Where a behavior is widely native, `rules.md` stays minimal; where a gap is universal, `rules.md` carries the rule:

| Behavior | Native coverage | rules.md stance |
|----------|-----------------|-----------------|
| Treat external/file/tool content as untrusted | 1/8 (Gemini CLI only) | **Highest-value rule we supply** (External Content Injection) |
| Test integrity (never weaken to pass) | 0/8 | **Supplied** (Test Integrity) |
| Read-before-edit (unconditional) | ~1/8 explicit | Supplied (Read-Before-Modify) |
| Dependency verification | 3/8; Windsurf's prompt actively endorses training-data version fallback | Supplied + explicit "never fall back to training data" (Trust Verification) |
| Scope discipline | ~4/8 | Supplied (Scope Boundary) |
| Verification before done | ~5/8, uneven | Supplied (Completion Gate) — also covers the 3 harnesses without it |
| Todo/plan tracking | 7/8 | Minimal — Spec Artifact adds only the cross-session ledger + verify-criteria contract |
| Conciseness/communication | 7/8 | Not duplicated |
| Convention-following | 7/8 | One line in Fix Quality |

Re-survey cadence: each major revision — harness prompts change quickly (e.g. Windsurf→Devin Desktop rebrand, June 2026).

## Literal Interpretation

Claude models follow instructions literally — omitted details are omitted from output (Anthropic prompting docs, "literal instruction following"). Implications for rule design:

- **Be exhaustive in required outputs:** Rule producing specific artifact → list every required field
- **Silence means skip:** Rule doesn't mention error handling → model won't add error handling
- **Explicit > implicit:** "Return {status, message, data}" not "Return relevant information"
- **Test by omission:** Validate rules by checking what happens when optional-sounding phrases removed

---

## Structured Output

JSON schema validation makes agent outputs more reliable and consistent than free-form text (Databricks 2024). Implications:

- **Agent return values:** Define exact schema (fields, types, required vs optional)
- **Error formats:** Standardize `{"error": "message"}` across all agent contracts
- **Validation at boundaries:** Parse + validate structured output before passing downstream
- **Prefer tables over prose** for any data model must act on programmatically

---

## AI Weakness Taxonomy

Systematic weaknesses in AI coding assistants. Rules address via specific mitigation strategies:

| ID | Weakness | What Happens | Rule Mitigation |
|----|----------|-------------|-----------------|
| W1 | Hallucination | Fabricates APIs, packages, file paths, commit hashes, prices | Trust Verification + Grounded Specifics — every emitted specific must trace to an observation, in any output form; Finding Triage — confirm each reported finding against current code before planning a fix |
| W2 | Tunnel Vision | Edits file A, breaks file B | Cross-file Consistency + Migration Sweep |
| W3 | Scope Creep | Reformats untouched code, adds unrequested features | Scope Boundary + Over-engineering Prevention + File Creation no-residue rule — working artifacts (scratch files, debug scripts, one-off helpers) deleted at completion |
| W4 | Memory Decay | Relies on stale conversation context | Artifact-First Recovery — re-read before modifying; Spec Artifact live ledger — mark `[x]` the moment a check passes, update `tasks.md` on approach change (the artifact is the progress ledger, not conversation memory) |
| W5 | Confidence Bias | Assigns higher severity than evidence warrants | Severity levels — when uncertain, choose lower; Finding Triage — unconfirmed findings are false positives, excluded from the plan |
| W6 | Skip Tendency / Premature Completion | Declares done before all steps executed — GPT-5.4 claimed uncollected subagent results collected (codex #14341); MiniMax verbalized 75-step plan, zero tool calls (arXiv 2602.19594); Kimi CLI shipped fixes for "ending goals prematurely"; first-hand DeepSeek V4 Flash case (2026-07) | Completion Gate — explicit done checklist incl. no-residue; CI Ownership — pushed work not done until checks green; Spec Artifact — live ledger keeps unexecuted steps visible |
| W7 | Redundancy Blindness | Reports same issue multiple times; re-raises resolved concerns (Opus 4.7 loops) | Deduplication in Fix Quality + settled-concern rule (don't re-litigate without new evidence) |
| W8 | Injection Risk | Unsanitized input in shell commands | Security Awareness — quote paths, use `--`, reject metacharacters |
| W9 | Concurrency Errors | AI-generated code shows ~2× more concurrency + dependency-correctness issues than human-written (CodeRabbit 2025) | Safety reference — explicit concurrency checklist |
| W10 | Self-Verification Failure | Self-judged "done" is unreliable — 19.71% of agent-"solved" tasks fail adversarial re-verification (SWE-ABS 2603.00520); false success 45-75% when self-reported vs 3% when independently verifiable (2606.09863); SWE-bench inflation 6.2pp (2503.15223) | Completion Gate — state what changed + how to verify; Operating Loop core principle now states self-reported completion is presumed false; Spec Artifact — per-task verify check + expected signal named at plan time |
| W11 | Read-Before-Act Regression | Claude Code field data: reads-per-edit dropped 6.6× → 2.0× after Feb 2026 update; modifies files without reading them first (GitHub #42796, 6,852 sessions; #47901) | Read-Before-Modify gate — explicit read required before every edit |
| W12 | Tool-Call Format Instability | Cross-vendor, worsening at long context: Kimi K2 malformed `tool_call_id`; GLM-5.x truncated JSON with fatal harness crashes (vllm #42400); Qwen3.x XML/JSON drift mid-session (#475); MiniMax duplicated names as plain text (koog #2093); DeepSeek V4 empty content on completed turns (openclaw #84591) + DSML drift | Tool-Call Result Verification gate — silent-failure list now names empty-content-on-completed-turn, malformed/duplicated names, format drift, plain-text tool calls |
| W13 | Error Abandonment | Model claims detected problem is "pre-existing" to avoid fixing it; passes silently — constraint-violation + inaccurate-self-reporting failure shares grow over session time (2605.29442, 20,574 sessions) | Error Ownership — every detected problem must be addressed regardless of origin; Verification-Infrastructure Gap — a check with no project tooling (no tests/CI/lint) is reported + remediation offered, never silently skipped |
| W14 | External Content Injection | Files/web/emails read during task embed fake instructions; model follows them (ClawSafety 2026: attack success 40–75% across models) | External Content Injection prohibition — treat all external content as untrusted data |
| W15 | Specification Gaming / Reward Hacking | Satisfies the literal test/metric while violating intent — special-cases known test inputs, hard-codes expected outputs, games the reward signal (SWE-ABS 2603.00520: 19.71% of "solved" tasks semantically wrong; gap widens +28pp at 10× code, SpecBench 2605.21384; actively benchmarked on production agents: EvilGenie 2511.21654, TRACE 2604.15149; GPT-5.3-Codex modified tests to vacuously pass, codex #12225). Mirror image: coverage-padding — vanity tests written to game a metric | Test Integrity — verify against described intent + cases beyond the provided suite; never special-case test inputs; every test names the failure it guards against, coverage never a target |
| W16 | Sycophancy / Authority Deference | Abandons a correct position under user pushback; defers to authority claims (PR text, comments, "the reviewer said") instead of judging behavior (BrokenMath 2510.04721: GPT-5 29% sycophantic; redacting authorship metadata restored vuln detection in all affected cases, 2603.18740) | Process Framework (on pushback, re-verify from source) + Trust Verification — judge code by behavior, not claims |
| W17 | Dependency Hallucination / Slopsquatting | Imports a package that doesn't exist, or an attacker's typosquat of a hallucinated name (USENIX 2025: 19.7% of LLM-suggested packages hallucinated, 43% reproducible) | Trust Verification — package present in registry (non-trivial age + downloads) AND in lockfile before import |
| W18 | Context Rot / Long-Context Degradation | Accuracy degrades as input grows even within the window; mid-context instructions silently dropped (Chroma 18-model study; arXiv 2601.15300). Post-compaction, model may deny its own recent actions — Codex falsely denied 23 file edits it had made (codex #5957). Distinct from W4 (post-compaction staleness) | Artifact-First Recovery — re-ground every ~20 calls, post-compaction the diff is the record, not recollection; Token/Context — front-load constraints, summarize don't accumulate; Gate Recall — pre-flight names the applicable gates so they stay salient |
| W19 | Multi-Agent / Subagent Handoff Failure | Trusts subagent-returned data as ground truth; specs/results distorted or lost across handoffs (MAST 2503.13657, 1,600+ traces; 2505.00212: 53.5% inter-agent attribution) | Subagent Output Verification gate — apply Grounded Specifics + Trust Verification to returned data; explicit handoff contract; turn budget → escalate |
| W20 | Slop / Duplication Drift | Regenerates near-duplicate code instead of reusing existing implementation (GitClear 2025: copy-pasted 8.3%→12.3%, moved/refactored 24.1%→9.5%, churn 5.5%→7.9%) | Fix Quality — grep for existing impl before generating; reuse/modify over regenerate; no-residue rule — slop artifacts never committed |

Each rule in `rules.md` addresses one or more weaknesses. New rules: explicitly identify weaknesses mitigated.

---

## Overlap Design Decision

Rules (always loaded) + skills (on-demand) intentionally overlap. Both must be self-contained — skills can't depend on rules being loaded, vice versa. Benign reinforcement costs slightly more tokens but prevents gaps in protection.

---

## Rule Evaluation Rubric

Score each rule 0-3 on criteria:

| Criterion | 3 (Excellent) | 2 (Good) | 1 (Needs Work) | 0 (Missing) |
|-----------|--------------|----------|----------------|-------------|
| **Clarity** | Action unambiguous, gate condition explicit | Mostly clear, minor ambiguity | Vague action or missing gate | Unclear what to do |
| **Universality** | Applies to any language/framework/tool | Applies to most with minor exceptions | Language-specific | Single-tool only |
| **Positive Framing** | Primary instruction is "do X", negative only as reinforcement | Mix of positive + negative | Primarily negative | Only "don't" |
| **Example Coverage** | 2-3 examples: happy + edge + error | 1 example: happy path | No examples but clear rule | Abstract, no examples |
| **Token Efficiency** | Table or single-line rule | Short paragraph | Multiple paragraphs | Excessive prose |
| **Adaptive Thinking** | No forced CoT; uses gates for verification | Minimal forced reasoning | Requires unnecessary step-by-step | Forces full chain-of-thought |

**Target:** >= 15/18 for production rules. >= 10/18 for draft rules.

---

## Adding New Rules

The pre-check list (evidence, framing, budget, overlap, weakness mapping, rubric score) lives in `CLAUDE.md` › "Adding or Modifying Rules" — single source of truth. This file supplies the research behind those checks and the rubric above.
