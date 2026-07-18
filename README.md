# dev-rules

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Works with](https://img.shields.io/badge/works_with-Claude_Code_·_Cursor_·_Copilot_·_Windsurf_·_Codex_·_Aider-green)

AI coding assistants hallucinate APIs, break dependent files, weaken tests to make them pass, claim work is done when it isn't, claim errors are "pre-existing" to skip fixing them, and silently drop data during conversions. These rules prevent that.

> One file. Any AI coding tool. Always active.

## Why rules, not just skills

AI skills run when you invoke them. Rules run **all the time** — during every edit, every refactor, every debugging session. The mistakes they prevent happen in the gaps between structured workflows, when the AI is "just coding."

And why a file, not ad-hoc prompting: domain knowledge that lives in people's heads (or in one-off chat corrections) is what Claude Code's creator calls a failure of automation — teams should maintain the rules files "that enable agents to productively work in their codebase with zero additional context from the prompter" (Boris Cherny, 2026).

## What the evidence says

This rule set is built from a 2026 survey of harness system prompts, model failure reports, and controlled studies — honestly positioned:

- **A rules file raises the floor and cuts waste; it is not a magic success-rate boost.** Human-written context files gain ~4% task success at ~19% cost (ETH Zurich, arXiv:2602.11988) but cut median agent runtime 28.6% and output tokens 16.6% on real PRs (arXiv:2601.20404). LLM-*generated* rules files actively hurt — every rule here is hand-curated against documented failures.
- **The highest-value rules are the ones no harness enforces.** A survey of 8 harness system prompts (Claude Code, Cursor, Codex CLI, Copilot, Gemini CLI, …) found 0/8 prohibit weakening tests to make them pass, and only 1/8 treats file/web/tool content as untrusted data. Those gaps are exactly what this file supplies.
- **False "done" is the failure to design against.** Agents self-report success falsely in 45–75% of failure cases when unverified — vs 3% when completion is independently verifiable (arXiv:2606.09863). Hence the Operating Loop's core principle: done is an external signal, never a self-assessment.
- **Short beats complete.** Bloated rules files get ignored (documented in Claude Code issue #22022 and Anthropic's own docs) — so every line here passes the test "would removing it cause mistakes?", and anything a linter/CI can enforce is pushed there instead (see the Automation Ladder in [rule-design.md](references/rule-design.md)).

## What's inside

**Operating loop** — every task runs Target → Assess → Gap (minimal-diff) → execute + verify-each → reconcile; "done" is defined by a passing check, never by self-assessment

**Pre-task protocol** — size-based pre-flight gate (Small task: inline, no-wait; Large task: block + confirmation for complex/risky), spec artifact (tracker checklist issue, or `tasks.md` fallback) for multi-phase work, scope expansion stop at 2× estimate

**Failure prevention** — scope boundary, test integrity, error ownership (pre-existing error = not an excuse), cross-file consistency, over-engineering prevention, concurrency safety, trust verification, grounded specifics (no fabricated identifiers in any output form), external content injection guard, read-before-modify, tool-call result verification

**Completion gate** — explicit done criteria, `git diff` verification, CI ownership (pushed work isn't done until checks are green), no silent "done" without stating what changed and how to verify

**Outcome report** — every task closes with a plain-language three-field summary (Task / Done / Gain: the concrete effect, not activity counts), open human-owned actions listed, deferred findings offered to the project's issue tracker instead of vanishing into chat

**Code quality** — complexity limits (CC ≤ 15, nesting ≤ 3), readability-over-cleverness, error message quality, error handling discipline

**Security** — OWASP top 10, human-verification gate for auth/payments/crypto, shell command safety, no hardcoded secrets

**Operational awareness** — observability baseline, production-grade defaults, database migration safety

**Process discipline** — structured workflow, artifact-first recovery after context gaps, code-intelligence-first navigation, subagent capability routing — with adaptive binding: named tools/artifacts are defaults, the host's native equivalent takes precedence

**Reference files** — detailed security and operations rules, loaded on demand when working on auth, payments, deployment, caching, etc.

## Install

### Quick start: one file, ready to go

`rules.md` is fully self-contained — all core rules work without any other file. Copy it to your AI tool's rules directory:

| Tool | Command |
|------|---------|
| **Claude Code** | `cp rules.md ~/.claude/rules/dev-rules.md` |
| **Cursor** | `cp rules.md .cursor/rules/dev-rules.md` |
| **Windsurf** | `cp rules.md .windsurf/rules/dev-rules.md` |
| **GitHub Copilot** | Append to `.github/copilot-instructions.md` |
| **Aider** | `cp rules.md CONVENTIONS.md` |

### Paste into any instruction file

`rules.md` is pure markdown — no YAML frontmatter, no tool-specific APIs, no external dependencies. Paste directly into:

| File | Tool |
|------|------|
| `CLAUDE.md` | Claude Code |
| `AGENTS.md` | OpenAI Codex CLI |
| `codex.md` | OpenAI Codex |
| `.cursor/rules/*.md` | Cursor |
| `.github/copilot-instructions.md` | GitHub Copilot |
| `.windsurfrules` | Windsurf |
| `.clinerules` | Cline |

### With reference files (optional, deeper coverage)

`rules.md` mentions reference files for topics like auth, payments, and deployment. Without these files, the AI skips the extended rules and uses only the core set. To enable extended coverage:

```bash
git clone https://github.com/sungurerdim/dev-rules.git /tmp/dev-rules
cp /tmp/dev-rules/rules.md ~/.claude/rules/dev-rules.md
mkdir -p ~/.claude/dev-rules-references
cp /tmp/dev-rules/references/safety.md /tmp/dev-rules/references/operations.md ~/.claude/dev-rules-references/
rm -rf /tmp/dev-rules
```

> **Keep references out of the auto-load path.** Claude Code loads everything under `~/.claude/rules/` (recursively) into every session. Reference files belong outside it — e.g. `~/.claude/dev-rules-references/` — so they cost tokens only when the AI actually needs them.

## How it works

```
rules.md                    always loaded (< 300 lines)
references/
  safety.md                 loaded when: auth, payments, crypto, multi-tenant, CORS, concurrency
  operations.md             loaded when: deployment, caching, infrastructure, observability
  rule-design.md            contributor reference — never loaded at runtime
CLAUDE.md                   AI contributor guide — never loaded at runtime
```

**Progressive disclosure:** The main file is always in context. Reference files load only when the current task matches their domain — minimal token overhead, maximum coverage when it matters.

## Design philosophy

- **Prevent harm, don't just detect it.** Rules catch mistakes as they happen, not after.
- **Positive framing.** "Verify imports exist before using" instead of "Don't use unverified imports." A constraint not written is a constraint not applied — rules state the action first, name the fallback, and use prohibitions only as reinforcement ([research](references/rule-design.md)).
- **Tool-agnostic.** Works with any AI tool that accepts markdown instructions — no lock-in, no platform dependencies.
- **Token-efficient.** ~4,700 tokens for the main file. References add ~1,400–3,800 each, only when needed.
- **Honest about what it can't do.** A prompt file can't be a mechanical gate — anything a type system, test, linter, CI step, or hook can enforce belongs there (Automation Ladder). The rules push the model to defer to those signals and to propose new mechanical guards when the same issue class recurs.

## Using with dev-skills

dev-rules works great on its own. If you also use [dev-skills](https://github.com/sungurerdim/dev-skills), the two complement each other:

| | dev-rules | dev-skills |
|---|---|---|
| **When** | Always on | On demand (`/ds-review`, `/ds-test`, etc.) |
| **What** | How to work (behavioral guardrails) | What to do (execution workflows) |
| **Example** | "Verify imports exist before using" | A full multi-scope code review workflow |

Together: always-on guardrails + structured workflows covering the full lifecycle — scaffold → code → test → review → commit → PR → deploy → launch.

## For contributors

See [CLAUDE.md](CLAUDE.md) for the project structure, invariants, and rule authoring guide. See [references/rule-design.md](references/rule-design.md) for the research, design patterns, and evaluation rubric.

## License

MIT
