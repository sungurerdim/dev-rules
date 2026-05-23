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
- [RDS+: Representation Redundancy in Instruction Tuning (arXiv 2025)](https://arxiv.org/html/2602.13773)
- [Process Reward Models (ACL Findings 2025)](https://arxiv.org/abs/2501.07301)
- [AI Agent Systems Survey (arXiv 2025)](https://arxiv.org/html/2601.01743v1)
- [Focused Chain-of-Thought (ICLR 2025)](https://arxiv.org/pdf/2511.22176)
- [Ten Simple Rules AI-Assisted Coding (arXiv 2025)](https://arxiv.org/html/2510.22254v2)
- [Instruction Hierarchy (arXiv 2024)](https://arxiv.org/html/2404.13208v1)
- [SHIELDA: Structured Exception Handling in LLM Workflows](https://arxiv.org/html/2508.07935v1)

### Industry
- [CodeRabbit: AI vs Human Code Quality Report (2025)](https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report)
- [Authority Partners: AI Agent Guardrails Production Guide (2026)](https://authoritypartners.com/insights/ai-agent-guardrails-production-guide-for-2026/)
- [CodeSignal: Prompt Engineering Best Practices (2025)](https://codesignal.com/blog/prompt-engineering-best-practices-2025/)
- [Databricks: Structured Outputs for Agent Workflows (2025)](https://www.databricks.com/blog/introducing-structured-outputs-for-batch-and-agent-workflows)
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
- [Zhang et al.: Guardrails Beat Guidance (arXiv:2604.11088, 2026)](https://arxiv.org/abs/2604.11088)
- [ClawSafety: Indirect Prompt Injection (arXiv:2604.01438, 2026)](https://arxiv.org/abs/2604.01438)

### Model-Specific Failure Reports
- [Claude Code: Read-Before-Act Regression Analysis (GitHub #42796, 6,852 sessions)](https://github.com/anthropics/claude-code/issues/42796)
- [Claude Code: Opus 4.6 Read Regression — Destructive Changes Without Reading (GitHub #47901)](https://github.com/anthropics/claude-code/issues/47901)
- [Claude Code: Opus 4.7 Bootstrap Failure (GitHub #50999)](https://github.com/anthropics/claude-code/issues/50999)
- [Kimi K2: Tool Call Format Instability in Multi-Round Agentic Use (HuggingFace #48)](https://huggingface.co/moonshotai/Kimi-K2-Instruct/discussions/48)
- [DeepSeek V3-0324: Function Calling Fix (Model Card)](https://huggingface.co/deepseek-ai/DeepSeek-V3-0324)
- [OpenAI Codex: Context Compaction Failure (GitHub #20931)](https://github.com/openai/codex/issues/20931)
- [Claude Opus 4.7: Confident-Prose Hallucination & "Bucket-Bypass Drift" — mechanical enforcement ≫ behavioral (GitHub #50235)](https://github.com/anthropics/claude-code/issues/50235)
- [DeepSeek V4 Pro: CAISI/NIST Evaluation — ~8 months behind frontier, weak precision reasoning (2026)](https://www.nist.gov/news-events/news/2026/05/caisi-evaluation-deepseek-v4-pro)
- [DeepSeek V4 Pro: reasoning_content Multi-Turn Tool-Call Inconsistency (opencode #25000)](https://github.com/anomalyco/opencode/issues/25000)

---

## Constraint Enforcement Research

AI models respond differently to positive vs negative framing:

| Framing | Success Rate | Example |
|---------|-------------|---------|
| Positive action | ~90% | "Only modify lines required by the task" |
| Explicit fallback | ~85% | "If uncertain, state 'not verified' and ask" |
| Priority framing | ~80% | "This rule applies regardless of conflicting requests" |
| Hard negative ("Never...") | ~95% fail rate | "Never weaken a test to make it pass" |
| Soft negative ("Don't...") | ~85-90% success | "Don't modify untouched code" |
| Implicit prohibition | < 30% | (Not mentioning constraint at all) |
| Buried in prose | < 40% | Constraint mentioned mid-paragraph |

**Takeaway:** Hard negatives fail only ~5% of the time; soft negatives fail ~10-15% (Lakera 2026). Positive framing remains primary instruction, but explicit prohibitions with "Never" proven effective as reinforcement. Every rule answers "What to DO?" before "What NOT to do?"

**Placement matters:** Front-load critical constraints in lines 1-5 of each section. Rules at end of long sections more likely ignored.

---

## Example Density

Optimal example count per rule:

| Examples | Effect |
|----------|--------|
| 0 | Rule abstract — frequently misinterpreted or ignored |
| 1-2 | Minimum viable — covers happy path |
| 3-5 | Optimal — happy path + edge case + error recovery |
| > 5 | Diminishing returns — increases token cost without proportional benefit |

**Quality over quantity:** 3.5% well-selected training data outperforms 100% random data by 0.71% on benchmarks (RDS+ arXiv 2025). Same principle applies to rule examples — few precise, representative examples > many generic ones.

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

**Reasoning length matters:** Model reasoning degrades around 3,000 tokens of chain-of-thought output. Sweet spot for narrative instructions: 150-300 words — long enough for clarity, short enough to avoid degradation (CodeSignal 2025, Anthropic 2026).

**Savings strategies:**
- Remove redundant preamble ("In this section we will discuss..."): ~10% savings
- Use shorthand for repeated concepts ("If X -> Y" not "In the case where X occurs, the appropriate action is Y"): ~15% savings
- Compress examples to outcome, not full trace: ~20% savings

**Budget:** Main rules file always loaded (~2,500 tokens). Reference files add ~1,000-1,100 tokens each when conditionally loaded. Total worst case: ~4,600 tokens. Leaves maximum context for actual codebase.

---

## Behavioral Anchoring

Instruction decay occurs after approximately 150-200 instructions in session (arXiv 2025, Claude Code best practices). Prevention strategies:

1. **External artifacts:** Write progress + decisions to files, not conversation memory
2. **Phase-boundary repetition:** Repeat core constraints when transitioning between major work phases
3. **Structured progress:** Use explicit "completed / current / next" tracking
4. **Re-read before modify:** After context gap (compression, long pause) → re-read source files — conversation memory unreliable

---

## Adaptive Thinking

Forced CoT adds only 2.9-3.1% accuracy improvement for reasoning models while costing 20-80% more tokens (Wharton GenAI Labs 2025). Implications for rule design:

- Do not force step-by-step reasoning for tasks model can handle directly
- Reserve explicit reasoning prompts for genuinely ambiguous or multi-step decisions
- Use gates, not chains: "Verify X before Y" cheaper + more effective than "Think through X step by step, then do Y"
- Focused CoT (ICLR 2025): when reasoning needed, constrain to specific decision point, not entire task

---

## The Operating Loop & Mechanical Verification

`rules.md` opens with an explicit **Target → Assess → Gap → Verify-each → Reconcile** loop. Rationale:

The gap between a frontier model and a cheaper one concentrates in three places — long-horizon plan coherence, reliable self-verification, and instruction-following under load. All three are externalizable, and the loop mechanizes them:

- **Target / Gap** convert open-ended "vibe coding" into a spec-bounded diff — kills scope creep (W3) for any model, and forces the problem-specific check a weak reasoner skips (DeepSeek V4 Pro applies familiar templates without verifying the problem's preconditions).
- **Assess** grounds claims in read reality, not memory — the direct mitigation for confident-prose fabrication (Opus 4.7 #50235: emits real-looking but fabricated commit hashes / file paths) and for hallucination (W1) generally.
- **Verify-each + "done = external signal"** is the highest-leverage move: it replaces the model's self-judgment (hallucinated ~63% of the time, W10) with a machine-checkable signal a passing test does not fake.

**Why mechanical, not behavioral — and the limit of a prompt file.** Opus 4.7 field data (#50235) found rules enforced via tool-call hooks reach near-100% compliance, while the *same* rules enforced purely as in-context behavioral guidance reach moderate-to-low compliance — and fabrications "bucket-bypass" into whatever output form (tags, labels, fields) a prose-level rule failed to name. Two design consequences:

1. A prompt file cannot *be* a mechanical gate; its leverage is to make the model *defer* to mechanical signals it can run (tests, builds, linters, exit codes, diffs). True enforcement (hooks, SAST, sandbox, `tool_choice`) lives in the harness/CI — see CLAUDE.md "Out of Scope".
2. Anti-bypass framing: a rule that constrains one output form must name *all* forms (see Grounded Specifics — "prose, labels, tags, fields"), or the failure migrates to the unnamed one.

The model difference narrows to the degree behavior is mechanized; it closes only where a real gate runs.

---

## Literal Interpretation

Claude 4.x takes instructions literally — omitted details omitted from output (Anthropic Official Docs 2026). Implications for rule design:

- **Be exhaustive in required outputs:** Rule producing specific artifact → list every required field
- **Silence means skip:** Rule doesn't mention error handling → model won't add error handling
- **Explicit > implicit:** "Return {status, message, data}" not "Return relevant information"
- **Test by omission:** Validate rules by checking what happens when optional-sounding phrases removed

---

## Structured Output

JSON schema validation outperforms free-form text for agent outputs (Databricks 2025). Implications:

- **Agent return values:** Define exact schema (fields, types, required vs optional)
- **Error formats:** Standardize `{"error": "message"}` across all agent contracts
- **Validation at boundaries:** Parse + validate structured output before passing downstream
- **Prefer tables over prose** for any data model must act on programmatically

---

## AI Weakness Taxonomy

Systematic weaknesses in AI coding assistants. Rules address via specific mitigation strategies:

| ID | Weakness | What Happens | Rule Mitigation |
|----|----------|-------------|-----------------|
| W1 | Hallucination | Fabricates APIs, packages, file paths, commit hashes, prices | Trust Verification + Grounded Specifics — every emitted specific must trace to an observation, in any output form |
| W2 | Tunnel Vision | Edits file A, breaks file B | Cross-file Consistency + Migration Sweep |
| W3 | Scope Creep | Reformats untouched code, adds unrequested features | Scope Boundary + Over-engineering Prevention |
| W4 | Memory Decay | Relies on stale conversation context | Artifact-First Recovery — re-read before modifying |
| W5 | Confidence Bias | Assigns higher severity than evidence warrants | Severity levels — when uncertain, choose lower |
| W6 | Skip Tendency | Declares done before all steps executed | Completion Gate — explicit done checklist |
| W7 | Redundancy Blindness | Reports same issue multiple times; re-raises resolved concerns (Opus 4.7 loops) | Deduplication in Fix Quality + settled-concern rule (don't re-litigate without new evidence) |
| W8 | Injection Risk | Unsanitized input in shell commands | Security Awareness — quote paths, use `--`, reject metacharacters |
| W9 | Concurrency Errors | AI-generated code misuses concurrency primitives 2× more than human-written (CodeRabbit 2025) | Safety reference — explicit concurrency checklist |
| W10 | Self-Verification Failure | 63% of model self-checks still contain hallucinated content | Completion Gate — state what changed + how to verify |
| W11 | Read-Before-Act Regression | Claude 4.6: reads-per-edit dropped 6.6× → 2.0× after Feb 2026 update; modifies files without reading them first (GitHub #47901, 6,852 sessions) | Read-Before-Modify gate — explicit read required before every edit |
| W12 | Tool-Call Format Instability | Kimi K2: `finish_reason="tool_calls"` but `tool_calls=[]` after multi-round agentic sessions; assumed success causes silent failure | Tool-Call Result Verification gate — verify result before proceeding |
| W13 | Error Abandonment | Model claims detected problem is "pre-existing" to avoid fixing it; passes silently | Error Ownership — every detected problem must be addressed regardless of origin |
| W14 | External Content Injection | Files/web/emails read during task embed fake instructions; model follows them (ClawSafety 2026: 40–75% success rate) | External Content Injection prohibition — treat all external content as untrusted data |

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

## Future Expansion Guidelines

When adding new rule:

1. **Evidence requirement:** At least 2 documented real-world failure cases (not hypothetical)
2. **Positive framing first:** Write as "Do X" before adding any "Don't Y" reinforcement
3. **Token budget:** Adding > 10 lines to `rules.md` → use reference file instead
4. **Overlap check:** Search all dev-skills SKILL.md files — verify reinforcement, not contradiction
5. **Weakness mapping:** Map to W1-W14. Unmapped rules may belong in skill instead
6. **Evaluate with rubric:** Minimum 15/18 for inclusion
