# dev-rules — Project Guide

## Purpose

Universal AI coding guardrails. `rules.md` is the deployed artifact — loads into Claude Code, Cursor, Copilot, Codex, Windsurf, Aider, Cline, and similar tools via their config files.

## File Structure

| File | Role | Loaded at runtime? |
|------|------|-------------------|
| `rules.md` | Lean core rules — always in context | Yes (always) |
| `references/portable-supplement.md` | Delta for hosts without a strong system prompt | Yes, on weak-host profile only |
| `references/safety.md` | Auth, payments, crypto, concurrency, CORS | On demand |
| `references/operations.md` | Deployment, caching, DB migrations, infra | On demand |
| `references/rule-design.md` | Rule authoring guide + research sources | Never |
| `CLAUDE.md` | This file — project contributor guide | Never |
| `README.md` | Human-facing project docs | Never |
| `research/` | Raw research artifacts (provenance for rule evidence) | Never |

## Two Profiles

Since 2026-07-25 the rule set ships in two profiles, driven by [The new rules of context engineering for Claude 5 generation models](https://claude.com/blog/the-new-rules-of-context-engineering-for-claude-5-generation-models) (Anthropic, 2026-07-24): Anthropic removed >80% of Claude Code's system prompt for Claude 5 generation models with no measurable eval loss, and re-asserting what the harness already says produces the conflicting-instruction failure that article documents.

| Profile | Install | Target |
|---------|---------|--------|
| **Lean** | `rules.md` alone | Claude Code on the Claude 5 generation — the host system prompt already supplies ordinary engineering judgment |
| **Portable** | `rules.md` + `references/portable-supplement.md` | Cursor, Copilot, Aider, Cline, or any weaker model |

The supplement is a **delta, never a copy** — it holds only what a strong host layer would have supplied, plus the hard thresholds a capable model handles by judgment. A clause belongs in exactly one of the two files.

## Invariants

- `rules.md` is self-contained on the lean profile — every core rule functions without any other file
- The portable supplement never restates a `rules.md` clause; verify with an n-gram overlap check before merging
- All rules tool-agnostic — no Claude-specific or tool-specific syntax
- No rule duplicated across files — each rule has exactly one canonical location; a one-line summary + pointer in `rules.md` backed by detail in a reference file is the intended pattern, not duplication. This extends across repos: content owned by a dev-skills skill (review severity, commit semantics, complexity thresholds) lives there, with only a pointer here
- Reference files never auto-loaded — only when the AI agent is working in their domain
- `rules.md` token budget: target ~110 lines, hard limit 130 lines

## Out of Scope for `rules.md` (Harness / CI / Orchestration)

`rules.md` is a prompt artifact: it can instruct the model to *lean on* mechanical checks, but it cannot *be* the mechanical gate. These belong in the harness config, CI pipeline, or skills — never in `rules.md`:

| Concern | Belongs in |
|---------|-----------|
| Tool-call fallback parse, `tool_choice="required"`, temperature/endpoint pinning | Harness config (`settings.json`, model adapter) |
| Second-model / human plan review, orchestrator–critic two-pass | Multi-agent skill or orchestration layer |
| SAST, mandatory signing, security checklist as pre-merge gate | CI pipeline |
| Least-privilege sandbox, network-egress restriction, destructive-op approval | Runtime / container config |
| Prompt + settings + model provenance, reproducibility logging | Harness telemetry |

Each has a prompt-expressible shadow that *does* live in `rules.md` (e.g. "verify by observed effect", Large-task "wait for confirmation"). The rule points the model at the gate; the gate's mechanical enforcement lives outside. This is the model-agnostic split: prompt rules narrow the model-skill gap, mechanical gates close it.

Harness-shaped failure modes that a weak host still surfaces to the model — empty tool-call results, format drift mid-session — live in `references/portable-supplement.md`, not `rules.md`, precisely because a strong harness owns them.

## Design Criterion — Two Customers

Every rule serves at least one of two customers, named explicitly at intake:

1. **Model reliability** — quality floor: verification, honest "done", consistency (most gates/prohibitions)
2. **The user's process management** — the agent owns follow-up (CI Ownership), nothing gets lost (tracker capture, human-action list), impact visible at a glance (three-field Outcome Report), zero-jargon surface (self-describing labels — "Small/Large task", never "Tier 1/2")

User-facing friction (manual tracking, opaque labels, activity-only reports) is a defect the rule set must eliminate, same as a model failure mode.

## Adding or Modifying Rules

### Pre-checks (all must pass)

1. Map to weakness taxonomy W1–W24 (see `references/rule-design.md`) — unmapped rules may belong in a skill instead
2. Evidence: ≥2 documented real-world failure cases (not hypothetical); single first-hand cases only when the failure class has independent multi-model corroboration
3. Automation Ladder check (`rule-design.md`): can a type/test/lint/CI/hook express this instead? Then it belongs there — a prompt rule is the last resort
4. Pruning heuristic per line: "Would removing this cause the model to make mistakes? If not, cut it" — never restate what models infer from code/config or standard conventions
5. Token budget: rule body >10 lines → move detail to reference file, keep summary in `rules.md`
6. Overlap check: search existing rules and dev-skills SKILL.md files — reinforce, don't contradict
7. Self-contained check: rule must be actionable without reading other rules or reference files
8. Naming check: user-facing labels self-describing for zero-technical readers; tool/artifact references follow adaptive binding — capability with a named default, never a hard mandate on one host's convention
9. Profile check: read the target host's system prompt (or its published equivalent) — already stated there → the rule goes in `references/portable-supplement.md`, never in `rules.md`. Two layers asserting the same thing is the documented conflicting-instruction failure, not redundant safety
10. Judgment check: would a Claude 5 generation model get this right unprompted from surrounding context? Then it is a portable-profile rule at most. Hard thresholds and absolute negatives need a documented case where judgment alone failed
11. Evaluate with rubric in `rule-design.md` — target ≥15/18

### Rule Lifecycle

Rules retire as well as enter: on each major revision run the sunset check (`rule-design.md` › Rule Lifecycle) — failure mode gone in current models, or promoted to a mechanical gate → demote/remove, with the retirement recorded.

### Rule format

```
**Rule Name [TYPE]:** Primary positive action ("Do X"). Negative reinforcement if needed ("Never Y"). Reference if detail is in a separate file.
```

Types:
- `[PROHIBITION]` — must never happen; failure = critical defect
- `[GATE]` — verify condition before proceeding to next step

### Pre-flight size thresholds (Small task / Large task)

Defined once in `rules.md` › Task Pre-flight — that is the single source of truth; this guide intentionally holds no copy.

## Weakness Taxonomy (W1–W24)

Single source of truth: `references/rule-design.md` › "AI Weakness Taxonomy" — full table with failure descriptions, evidence, and the rule mitigating each. Map every new or modified rule to a W-ID there.

## Sync Requirement

Installed layout — everything under `~/.claude/rules/` auto-loads into every session (recursively), so only `rules.md` lives there:

| Repo path | Installed path | Auto-loaded? |
|-----------|----------------|--------------|
| `rules.md` | `~/.claude/rules/dev-rules.md` (exact copy) | Yes |
| `references/` | `~/.claude/dev-rules-references/` | No — on demand only |

`portable-supplement.md` installs into `~/.claude/rules/` **only on the portable profile**; on Claude Code it stays under `dev-rules-references/` so it never auto-loads.

After editing `rules.md` or `references/`, re-sync and verify:

```bash
cp rules.md ~/.claude/rules/dev-rules.md
cp references/safety.md references/operations.md references/portable-supplement.md ~/.claude/dev-rules-references/
diff rules.md ~/.claude/rules/dev-rules.md \
  && diff references/safety.md ~/.claude/dev-rules-references/safety.md \
  && diff references/operations.md ~/.claude/dev-rules-references/operations.md \
  && diff references/portable-supplement.md ~/.claude/dev-rules-references/portable-supplement.md
```

`rule-design.md` is contributor-only — never installed.

Prior art for one-source→many-tools sync at scale: [Ruler](https://github.com/intellectronica/ruler) (30+ tool formats, CI drift check). The manual `cp` + `diff` above stays deliberate while only one target exists; adopt a sync tool if targets multiply.

## Blueprint Profile

Type: developer-tool | Stack: markdown-rules-artifact (no runtime) | Target: production
Priorities: docs-accuracy, dx | Constraints: rules.md self-contained ≤130 lines, tool-agnostic, zero runtime deps
Integrations: none
Data: none | Regulations: none
Audience: public (developers using AI coding tools) | Deploy: git clone / copy-paste install

Entry: rules.md (no framework — plain markdown)
Modules: rules.md=core-rules(1); references/=on-demand-reference(4); research/2026-07=provenance-artifacts(6); .github/workflows=ci(1)
Data Flow: contributor-edit→CI(markdownlint+line-budget+lychee)→merge→copy/paste-install(consumer AI tool)
External: none (zero runtime dependencies)
Toolchain: markdownlint-cli2, lychee | CI: GitHub Actions | Container: none

Ideal: coupling=1 cohesion=9 complexity=1 coverage=N/A

Scores: sec=92 quality=80 arch=88 perf=N/A resil=75 test=78 stack=82 dx=70 docs=85 overall=81 model=claude-sonnet-5

## End Blueprint Profile
