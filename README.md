# dev-rules

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Tool](https://img.shields.io/badge/works_with-Claude_Code_·_Cursor_·_Copilot_·_Windsurf_·_Codex_·_Aider-green)]()

AI coding assistants hallucinate APIs, break dependent files, weaken tests to make them pass, and silently drop data during conversions. These rules prevent that.

> One file. Any AI coding tool. Always active.

## Why rules, not just skills

AI skills run when you invoke them. Rules run **all the time** — during every edit, every refactor, every debugging session. The mistakes they prevent happen in the gaps between structured workflows, when the AI is "just coding."

## What's inside

**15 failure prevention rules** — scope control, test integrity, cross-file consistency, over-engineering prevention, concurrency safety, trust verification, meaningful test data, self-verification, non-functional accountability, migration sweep, format preservation, artifact-first recovery

**Code quality standards** — complexity limits (CC ≤ 15, nesting ≤ 3), readability-over-cleverness, error message quality, function contracts

**Security awareness** — OWASP top 10, CI security scanning (24-30% of AI code has CWE flaws), human-verification gate for auth/payments/crypto, shell command safety

**Operational awareness** — observability baseline, production-grade defaults, database migration safety

**Process discipline** — structured workflow, vibe coding guardrails, external state persistence, scope expansion control, token efficiency

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
cp -r /tmp/dev-rules/references ~/.claude/rules/dev-rules-references
rm -rf /tmp/dev-rules
```

## How it works

```
rules.md                    always loaded (~270 lines)
references/
  safety.md                 loaded when: auth, payments, crypto, multi-tenant, CORS, concurrency
  operations.md             loaded when: deployment, caching, infrastructure, observability
  rule-design.md            contributor reference — never loaded at runtime
```

**Progressive disclosure:** The main file is always in context. Reference files load only when the current task matches their domain — minimal token overhead, maximum coverage when it matters.

## Design philosophy

- **Prevent harm, don't just detect it.** Rules catch mistakes as they happen, not after.
- **Positive framing.** "Verify imports exist before using" instead of "Don't use unverified imports." Hard negatives fail ~5%, soft negatives ~10-15% — positive framing is 2-5× more reliable ([research](references/rule-design.md)).
- **Tool-agnostic.** Works with any AI tool that accepts markdown instructions — no lock-in, no platform dependencies.
- **Token-efficient.** ~2,500 tokens for the main file. References add ~1,000 each, only when needed.

## Using with dev-skills

dev-rules works great on its own. If you also use [dev-skills](https://github.com/sungurerdim/dev-skills), the two complement each other:

| | dev-rules | dev-skills |
|---|---|---|
| **When** | Always on | On demand (`/ds-review`, `/ds-test`, etc.) |
| **What** | How to work (behavioral guardrails) | What to do (execution workflows) |
| **Example** | "Verify imports exist before using" | Full code review with 97 checks across 9 scopes |

Together: always-on guardrails + 21 structured workflows covering scaffold → code → design → test → review → commit → PR → deploy → launch → analytics.

## For contributors

See [references/rule-design.md](references/rule-design.md) for the research, design patterns, and evaluation rubric behind these rules.

## License

MIT
