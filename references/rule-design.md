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

### Model-Specific Failure Reports
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

**Budget** (measured 2026-07, chars/4): main rules file always loaded (~4,200 tokens). Reference files add ~1,400 (operations) to ~3,400 (safety) tokens when conditionally loaded. Total worst case: ~9,000 tokens. Leaves maximum context for actual codebase.

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
| W6 | Skip Tendency | Declares done before all steps executed | Completion Gate — explicit done checklist incl. no-residue; Spec Artifact — live ledger keeps unexecuted steps visible |
| W7 | Redundancy Blindness | Reports same issue multiple times; re-raises resolved concerns (Opus 4.7 loops) | Deduplication in Fix Quality + settled-concern rule (don't re-litigate without new evidence) |
| W8 | Injection Risk | Unsanitized input in shell commands | Security Awareness — quote paths, use `--`, reject metacharacters |
| W9 | Concurrency Errors | AI-generated code shows ~2× more concurrency + dependency-correctness issues than human-written (CodeRabbit 2025) | Safety reference — explicit concurrency checklist |
| W10 | Self-Verification Failure | Self-judged "done" is unreliable — 19.71% of agent-"solved" tasks fail adversarial re-verification (SWE-ABS 2603.00520) | Completion Gate — state what changed + how to verify; Spec Artifact — per-task verify check + expected signal named at plan time, not improvised at completion |
| W11 | Read-Before-Act Regression | Claude Code field data: reads-per-edit dropped 6.6× → 2.0× after Feb 2026 update; modifies files without reading them first (GitHub #42796, 6,852 sessions; #47901) | Read-Before-Modify gate — explicit read required before every edit |
| W12 | Tool-Call Format Instability | Kimi K2: malformed `tool_call_id` format breaks tool-call parsing in multi-round agentic sessions; assumed success causes silent failure | Tool-Call Result Verification gate — verify result before proceeding |
| W13 | Error Abandonment | Model claims detected problem is "pre-existing" to avoid fixing it; passes silently | Error Ownership — every detected problem must be addressed regardless of origin; Verification-Infrastructure Gap — a check with no project tooling (no tests/CI/lint) is reported + remediation offered, never silently skipped |
| W14 | External Content Injection | Files/web/emails read during task embed fake instructions; model follows them (ClawSafety 2026: attack success 40–75% across models) | External Content Injection prohibition — treat all external content as untrusted data |
| W15 | Specification Gaming / Reward Hacking | Satisfies the literal test/metric while violating intent — special-cases known test inputs, hard-codes expected outputs, games the reward signal (SWE-ABS 2603.00520: 19.71% of "solved" tasks semantically wrong; gap widens +28pp at 10× code, SpecBench 2605.21384) | Test Integrity — verify against described intent + cases beyond the provided suite; never special-case test inputs |
| W16 | Sycophancy / Authority Deference | Abandons a correct position under user pushback; defers to authority claims (PR text, comments, "the reviewer said") instead of judging behavior (BrokenMath 2510.04721: GPT-5 29% sycophantic; redacting authorship metadata restored vuln detection in all affected cases, 2603.18740) | Process Framework (on pushback, re-verify from source) + Trust Verification — judge code by behavior, not claims |
| W17 | Dependency Hallucination / Slopsquatting | Imports a package that doesn't exist, or an attacker's typosquat of a hallucinated name (USENIX 2025: 19.7% of LLM-suggested packages hallucinated, 43% reproducible) | Trust Verification — package present in registry (non-trivial age + downloads) AND in lockfile before import |
| W18 | Context Rot / Long-Context Degradation | Accuracy degrades as input grows even within the window; mid-context instructions silently dropped (Chroma 18-model study; arXiv 2601.15300). Distinct from W4 (post-compaction staleness) | Artifact-First Recovery + Token/Context — front-load constraints, re-ground every ~20 calls, summarize don't accumulate; Gate Recall — pre-flight names the applicable gates so they stay salient throughout |
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
