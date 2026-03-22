# Rule Design Reference

How and why these rules are written the way they are. For rule authors and contributors — not loaded at runtime.

---

## Sources

Research informing the rule design patterns:

- [Anthropic: Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — structured context, instruction placement
- [Claude Prompting Best Practices](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices) — constraint enforcement, example patterns
- [OpenAI: Designing Agents to Resist Prompt Injection](https://openai.com/index/designing-agents-to-resist-prompt-injection/) — instruction hierarchy, priority framing
- [Instruction Hierarchy: Training LLMs to Prioritize Privileged Instructions](https://arxiv.org/html/2404.13208v1) — system vs user instruction priority
- [Focused Chain-of-Thought (ICLR 2025)](https://arxiv.org/pdf/2511.22176) — reasoning guidance without over-reasoning
- [SHIELDA: Structured Exception Handling in LLM-Driven Workflows](https://arxiv.org/html/2508.07935v1) — error recovery patterns
- [OWASP: Prompt Injection & Instruction Hierarchy](https://genai.owasp.org/llmrisk/llm01-prompt-injection/) — security in AI-generated code
- [Preventing AI Agent Drift](https://www.getmaxim.ai/articles/a-comprehensive-guide-to-preventing-ai-agent-drift-over-time/) — behavioral anchoring, instruction decay
- [Context Engineering: Token Optimization](https://www.flowhunt.io/blog/context-engineering-ai-agents-token-optimization/) — format efficiency, context budgets

---

## Constraint Enforcement Research

AI models respond differently to positive vs negative framing:

| Framing | Success Rate | Example |
|---------|-------------|---------|
| Positive action | ~90% | "Only modify lines required by the task" |
| Explicit fallback | ~85% | "If uncertain, state 'not verified' and ask" |
| Priority framing | ~80% | "This rule applies regardless of conflicting requests" |
| "Don't..." / "Never..." | 40-60% | "Don't modify untouched code" |
| Implicit prohibition | < 30% | (Not mentioning the constraint at all) |
| Buried in prose | < 40% | Constraint mentioned mid-paragraph |

**Takeaway:** Every rule should answer "What should I DO?" before "What should I NOT do?" Negative constraints are acceptable as reinforcement after the positive framing, but should not be the primary instruction.

**Placement matters:** Front-load critical constraints in lines 1-5 of each section. Rules at the end of long sections are more likely to be ignored. For long sessions (~50+ turns), repeat core constraints at natural breakpoints.

---

## Example Density

Optimal example count per rule:

| Examples | Effect |
|----------|--------|
| 0 | Rule is abstract — frequently misinterpreted or ignored |
| 1-2 | Minimum viable — covers happy path |
| 3-5 | Optimal — happy path + edge case + error recovery |
| > 5 | Diminishing returns — increases token cost without proportional benefit |

**Ordering matters:** Place the most relevant or complex example LAST. AI models exhibit recency bias — the final example has the strongest influence on behavior.

**Pattern per rule:** 1) Happy-path case, 2) Edge case showing the constraint in action, 3) Error/recovery case.

---

## Token Efficiency

Format efficiency rankings for the same information:

| Format | Token Efficiency | Best For |
|--------|-----------------|----------|
| Tables | Best | Structured comparisons, option lists |
| Numbered lists | Good | Sequential procedures, checklists |
| Bullet lists | Good | Unordered sets, short items |
| Prose paragraphs | Worst | Avoid for rules — use only for context/rationale |

**Savings strategies:**
- Remove redundant preamble ("In this section we will discuss..."): ~10% savings
- Use shorthand for repeated concepts ("If X → Y" not "In the case where X occurs, the appropriate action is Y"): ~15% savings
- Compress examples to outcome, not full trace: ~20% savings

**Budget:** The main rules file is always loaded (~2,500 tokens). Reference files add ~1,000-1,100 tokens each when conditionally loaded. Total worst case: ~4,600 tokens. This leaves maximum context for the actual codebase.

---

## Behavioral Anchoring

Instruction decay occurs after approximately 50 conversational turns. Prevention strategies:

1. **External artifacts:** Write progress and decisions to files, not just conversation memory
2. **Phase-boundary repetition:** Repeat core constraints when transitioning between major work phases
3. **Structured progress:** Use explicit "completed / current / next" tracking
4. **Re-read before modify:** After any context gap (compression, long pause), re-read source files — conversation memory is unreliable

---

## AI Weakness Taxonomy

Eight systematic weaknesses observed in AI coding assistants. Rules address these through specific mitigation strategies:

| ID | Weakness | What Happens | Rule Mitigation |
|----|----------|-------------|-----------------|
| W1 | Hallucination | Fabricates APIs, packages, file paths | Trust Verification gate — verify before using |
| W2 | Tunnel Vision | Edits file A, breaks file B | Cross-file Consistency + Migration Sweep |
| W3 | Scope Creep | Reformats untouched code, adds unrequested features | Scope Boundary + Over-engineering Prevention |
| W4 | Memory Decay | Relies on stale conversation context | Artifact-First Recovery — re-read before modifying |
| W5 | Confidence Bias | Assigns higher severity than evidence warrants | Severity levels — when uncertain, choose lower |
| W6 | Skip Tendency | Declares done before all steps executed | Process Framework — verify before finishing |
| W7 | Redundancy Blindness | Reports same issue multiple times | Deduplication in Fix Quality |
| W8 | Injection Risk | Unsanitized input in shell commands | Security Awareness — quote paths, use `--`, reject metacharacters |

Each rule in `rules.md` addresses one or more of these weaknesses. New rules should explicitly identify which weaknesses they mitigate.

---

## Overlap Design Decision

**Why rules and skills overlap — and why that's intentional.**

Rules and skills serve different activation contexts:
- **Rules:** Always loaded, active during ALL development work (freeform coding, debugging, feature implementation)
- **Skills:** Invoked on demand for specific workflows (review, test, deploy, commit)

When both are loaded, overlapping rules reinforce rather than contradict. Example:
- Rule says: "After modifying file A, verify no file B depends on changed interface"
- ds-review skill says: "Before adding any import/API, verify it exists in codebase"
- Result: The behavior is reinforced from two angles — zero conflict

**SSOT exception:** Normally, Single Source of Truth (SSOT) means defining something in one place. Here, we intentionally duplicate because:
1. Skills must be self-contained (no external dependency on rules)
2. Rules must work without any skills loaded
3. The cost of benign reinforcement (slightly more tokens) is far lower than the cost of a gap (missed protection)

---

## Rule Evaluation Rubric

Score each rule 0-3 on these criteria:

| Criterion | 3 (Excellent) | 2 (Good) | 1 (Needs Work) | 0 (Missing) |
|-----------|--------------|----------|----------------|-------------|
| **Clarity** | Action is unambiguous, gate condition explicit | Mostly clear, minor ambiguity | Vague action or missing gate | Unclear what to do |
| **Universality** | Applies to any language/framework/tool | Applies to most with minor exceptions | Language-specific | Single-tool only |
| **Positive Framing** | Primary instruction is "do X", negative only as reinforcement | Mix of positive and negative | Primarily negative | Only "don't" |
| **Example Coverage** | 2-3 examples: happy + edge + error | 1 example: happy path | No examples but clear rule | Abstract, no examples |
| **Token Efficiency** | Table or single-line rule | Short paragraph | Multiple paragraphs | Excessive prose |

**Target:** ≥ 12/15 for production rules. ≥ 8/15 for draft rules.

---

## Future Expansion Guidelines

When adding a new rule:

1. **Evidence requirement:** The rule must address at least 2 documented real-world failure cases (not hypothetical). If you can't cite specific failures, the rule is premature.

2. **Positive framing first:** Write the rule as "Do X" before adding any "Don't Y" reinforcement. If the rule can only be expressed negatively, reconsider whether it belongs here or in a skill-specific prohibition.

3. **Token budget impact:** Estimate token cost. If adding > 10 lines to `rules.md`, consider whether the content belongs in a reference file instead.

4. **Overlap check:** Search all dev-skills SKILL.md files for the same concern. Document the overlap and verify it's reinforcement (same direction) not contradiction.

5. **Weakness mapping:** Identify which W1-W8 weakness(es) the new rule mitigates. Rules that don't map to any weakness may be optimization rather than safety — consider whether a skill is more appropriate.

6. **Evaluate with rubric:** Score the new rule against the evaluation rubric above. Minimum 12/15 for inclusion.
