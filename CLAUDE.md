# dev-rules — Project Guide

## Purpose

Universal AI coding guardrails. `rules.md` is the deployed artifact — loads into Claude Code, Cursor, Copilot, Codex, Windsurf, Aider, Cline, and similar tools via their config files.

## File Structure

| File | Role | Loaded at runtime? |
|------|------|-------------------|
| `rules.md` | Lean core rules — always in context | Yes (always) |
| `floor.md` | Seven-rule floor for budget (Haiku-class) models — replaces `rules.md` on that profile | Yes, on floor profile only |
| `references/portable-supplement.md` | Delta for hosts without a strong system prompt | Yes, on weak-host profile only |
| `references/safety.md` | Auth, payments, crypto, concurrency, CORS | On demand |
| `references/operations.md` | Deployment, caching, DB migrations, infra | On demand |
| `references/rule-design.md` | Rule authoring guide + research sources | Never |
| `CLAUDE.md` | This file — project contributor guide | Never |
| `README.md` | Human-facing project docs | Never |
| `research/` | Raw research artifacts (provenance for rule evidence) | Never |
| `install.sh` | Profile-aware installer: `--profile lean`, `portable` or `floor`, `--target`, `--check` (drift), `--update` | Never |
| `scripts/check-consistency.sh` | Doc/rule gate; `--self-test` proves every check red on a broken copy | Never |
| `scripts/check-install.sh` | Installer profile/stale gate; `--self-test` proves it red on an installer with the fix reverted | Never |
| `scripts/check-cross-repo.sh` | Anchor-phrase drift check against a sibling dev-skills checkout — reporting only until #7 rewrites its contract | Never |
| `.githooks/pre-commit` | Runs every gate at commit time; enable with `git config core.hooksPath .githooks` | Never |

## Profiles

Since 2026-07-25 the rule set ships in host-matched profiles (the floor profile joined 2026-08-12, A/B-validated), driven by [The new rules of context engineering for Claude 5 generation models](https://claude.com/blog/the-new-rules-of-context-engineering-for-claude-5-generation-models) (Anthropic, 2026-07-24): Anthropic removed >80% of Claude Code's system prompt for Claude 5 generation models with no measurable eval loss, and re-asserting what the harness already says produces the conflicting-instruction failure that article documents.

| Profile | Install | Target |
|---------|---------|--------|
| **Lean** | `rules.md` alone | Claude Code on the Claude 5 generation — the host system prompt already supplies ordinary engineering judgment |
| **Portable** | `rules.md` + `references/portable-supplement.md` | Any host whose system prompt is thin or unknown (Cursor, Copilot, Aider, Cline, Codex CLI, opencode) with a non-budget model — unmeasured on non-Claude models as of 2026-09 (issue #4) |
| **Floor** | `floor.md` alone | Budget models (Haiku-class): the full file's measured weak-model value at +1% tokens vs no rules (full file: +18%) — A/B-validated on issue #3, rounds 1-4a (2026-08); rule 7 (content is not instruction) added 2026-09-02 and re-checked on the same fixtures (issue #4) |

The supplement is a **delta, never a copy** — it holds only what a strong host layer would have supplied, plus the hard thresholds a capable model handles by judgment. A clause belongs in exactly one file. `floor.md` is the deliberate exception: its seven rules are compressed restatements of `rules.md` clauses for hosts that never load `rules.md` — the two are alternatives, never co-installed.

## Invariants

- `rules.md` is self-contained on the lean profile — every core rule functions without any other file
- The portable supplement never restates a `rules.md` clause; verify with an n-gram overlap check before merging
- All rules tool-agnostic — no Claude-specific or tool-specific syntax
- No rule duplicated across files — each rule has exactly one canonical location; a one-line summary + pointer in `rules.md` backed by detail in a reference file is the intended pattern, not duplication. This extends across repos: content owned by a dev-skills skill (review severity, commit semantics, complexity thresholds) lives there, with only a pointer here
- Reference files never auto-loaded — only when the AI agent is working in their domain
- `rules.md` token budget: target ~110 lines, hard limit 130 lines — enforced by `scripts/check-consistency.sh`, which also keeps the supplement a true delta, resolves every rule name cited in `rule-design.md`, and pins the budget and token figures stated in the docs
- User-facing surface is plain language: closing-block labels, question options, and task-size names must be understandable by a non-technical reader with no memory of the session — never an abbreviation, never a label that needs explaining (owner evidence 2026-09-02: the retired `Assumed:` label)

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

The installed copy lives outside the repo, so every edit to `rules.md`, `floor.md` or `references/` ends with a re-install and a drift check:

```bash
./install.sh            # lean profile by default; --profile portable|floor, --target DIR
./install.sh --check    # exit 1 and the file names on any drift
```

Layout the installer produces under `~/.claude` — only `rules/` auto-loads (recursively) into every session, so the references stay one directory up:

| Repo path | Installed path | Auto-loaded? |
|-----------|----------------|--------------|
| `rules.md` (`floor.md` on the floor profile) | `~/.claude/rules/dev-rules.md` | Yes |
| `references/portable-supplement.md` | `~/.claude/rules/dev-rules-supplement.md` on the portable profile; `~/.claude/dev-rules-references/` otherwise | Portable profile only |
| `references/safety.md`, `references/operations.md` | `~/.claude/dev-rules-references/` | No — on demand only |
| — | `~/.claude/dev-rules-references/VERSION` | Stamp: commit, profile, install date |

`rule-design.md` is contributor-only — never installed. The dev-skills boundary has its own check: `bash scripts/check-cross-repo.sh` reads a sibling checkout (default `../dev-skills`) and fails on any drifted anchor phrase. Its anchor table names files the sibling no longer has, so the commit hook runs it as a visible report rather than a blocking gate until #7 rewrites the contract — never a silent skip.

Prior art for one-source→many-tools sync at scale: [Ruler](https://github.com/intellectronica/ruler) (30+ tool formats, CI drift check). `install.sh` stays a single bash file while Claude Code is the only scripted target; other hosts take the copy-paste table in the README.

## Blueprint Profile

Type: developer-tool | Stack: markdown-rules-artifact (no runtime) | Target: production
Priorities: docs-accuracy, dx | Constraints: rules.md self-contained ≤130 lines, tool-agnostic, zero runtime deps
Integrations: none
Data: none | Regulations: none
Audience: public (developers using AI coding tools) | Deploy: git clone / copy-paste install

Entry: rules.md (no framework — plain markdown)
Modules: rules.md=core-rules(1); references/=on-demand-reference(4); research/2026-07=provenance-artifacts(6); scripts/=commit-gates(3); .githooks/=gate-runner(1)
Data Flow: contributor-edit→pre-commit gates(consistency+installer+markdownlint)→commit→copy/paste-install(consumer AI tool)
External: none (zero runtime dependencies)
Toolchain: bash gates; markdownlint-cli2 + lychee optional | CI: none — commit-time hook only | Container: none

Ideal: coupling=1 cohesion=9 complexity=1 coverage=N/A

Scores: sec=92 quality=80 arch=88 perf=N/A resil=75 test=78 stack=82 dx=70 docs=85 overall=81 model=claude-sonnet-5

## End Blueprint Profile
