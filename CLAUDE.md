# dev-rules — Project Guide

## Purpose

Universal AI coding guardrails. `rules.md` is the deployed artifact — loads into Claude Code, Cursor, Copilot, Codex, Windsurf, Kimi, DeepSeek, and similar tools via their config files.

## File Structure

| File | Role | Loaded at runtime? |
|------|------|-------------------|
| `rules.md` | Core rules — always in context | Yes (always) |
| `references/safety.md` | Auth, payments, crypto, concurrency, CORS | On demand |
| `references/operations.md` | Deployment, caching, DB migrations, infra | On demand |
| `references/rule-design.md` | Rule authoring guide + research sources | Never |
| `CLAUDE.md` | This file — project contributor guide | Never |
| `README.md` | Human-facing project docs | Never |

## Invariants

- `rules.md` must be self-contained — all core rules function without reference files
- All rules tool-agnostic — no Claude-specific or tool-specific syntax
- No rule duplicated across files — each rule lives in exactly one location
- Reference files never auto-loaded — only when AI agent is working in their domain
- `rules.md` token budget: target ~240 lines, hard limit 300 lines

## Adding or Modifying Rules

### Pre-checks (all must pass)

1. Map to weakness taxonomy W1–W14 (see `references/rule-design.md`) — unmapped rules may belong in a skill instead
2. Evidence: ≥2 documented real-world failure cases (not hypothetical)
3. Token budget: rule body >10 lines → move detail to reference file, keep summary in `rules.md`
4. Overlap check: search existing rules — reinforce, don't contradict
5. Self-contained check: rule must be actionable without reading other rules or reference files
6. Evaluate with rubric in `rule-design.md` — target ≥15/18

### Rule format

```
**Rule Name [TYPE]:** Primary positive action ("Do X"). Negative reinforcement if needed ("Never Y"). Reference if detail is in a separate file.
```

Types:
- `[PROHIBITION]` — must never happen; failure = critical defect
- `[GATE]` — verify condition before proceeding to next step

### Pre-flight tier thresholds (do not change without updating both files)

| Tier | Trigger | Behavior |
|------|---------|----------|
| Tier 1 | 3–7 files, clear scope, no destructive ops | State plan inline, proceed without waiting |
| Tier 2 | 8+ files, ambiguous, destructive, or multi-phase | Block format, wait for confirmation |
| Exempt | 1–2 file cosmetic, trivial lookup | No pre-flight |

## Weakness Taxonomy (W1–W14)

| ID | Weakness | Mitigated By |
|----|----------|-------------|
| W1 | Hallucination | Trust Verification |
| W2 | Tunnel Vision | Cross-file Consistency, Migration Sweep |
| W3 | Scope Creep | Scope Boundary, Over-engineering |
| W4 | Memory Decay | Artifact-First Recovery |
| W5 | Confidence Bias | Severity levels |
| W6 | Skip Tendency | Completion Gate |
| W7 | Redundancy Blindness | Fix Quality deduplication |
| W8 | Injection Risk | Security — shell command safety |
| W9 | Concurrency Errors | Concurrency Safety, safety.md |
| W10 | Self-Verification Failure | Completion Gate — state what changed |
| W11 | Read-Before-Act Regression | Read-Before-Modify gate |
| W12 | Tool-Call Format Instability | Tool-Call Result Verification gate |
| W13 | Error Abandonment | Error Ownership prohibition |
| W14 | External Content Injection | External Content Injection prohibition |

## Sync Requirement

After editing `rules.md`: sync installed copy at `~/.claude/rules/dev-rules.md` (header line differs; body must be identical).
