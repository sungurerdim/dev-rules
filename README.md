# AI Rules

Universal development guardrails for AI-assisted coding.
Works with any AI coding tool — Claude Code, Cursor, Windsurf, GitHub Copilot, Cline, Aider, and more.

## Install

Copy `rules.md` to your tool's rules directory:

| Tool | Command |
|------|---------|
| Claude Code (global) | `cp rules.md ~/.claude/rules/ai-rules.md` |
| Claude Code (project) | `cp rules.md .claude/rules/ai-rules.md` |
| Cursor | `cp rules.md .cursor/rules/ai-rules.mdc` |
| Windsurf | `cp rules.md .windsurf/rules/ai-rules.md` |
| GitHub Copilot | `cp rules.md .github/copilot-instructions.md` |
| Cline | `cp rules.md .clinerules` |
| Aider | `cp rules.md CONVENTIONS.md` |
| AGENTS.md | `cp rules.md AGENTS.md` |

Or download directly:

```bash
curl -fsSL https://raw.githubusercontent.com/sungurerdim/ai-rules/main/rules.md -o rules.md
```

## What's Included

- **8 failure prevention rules** — scope control, test integrity, cross-file consistency
- **5 verification gates** — change, migration, trust, format, artifact recovery
- **Complexity limits** — method ≤50 lines, nesting ≤3, cyclomatic ≤15
- **Conventional commits** — litmus test + misclassification table
- **Toolchain detection** — auto-detect from package.json, go.mod, etc.
- **14 project types** — with UI category mapping
- **Severity levels** — CRITICAL through LOW
- **Fix quality** — DRY, SSOT, SoC, KISS, Consistency

## Companion: ai-agents

For analysis, fix, and research agent specifications, see [ai-agents](https://github.com/sungurerdim/ai-agents).
