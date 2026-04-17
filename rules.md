# Development Rules

## Failure Prevention

### Scope Boundary [PROHIBITION]

Touch only lines task requires. Unrelated issues: mention, don't fix. Never reformat untouched code, reorder imports beyond what change requires, or change whitespace in unmodified lines.

### Test Integrity [PROHIBITION]

Fix code or test to validate real behavior — never weaken, skip, mock away, or relax assertions to pass. Test environment: real OS paths, production-equivalent layouts. Every bug fix includes a regression test.

Test boundary conditions: empty inputs, null/undefined, max-size, concurrent access, locale/timezone. Verify data transformations with edge inputs, not just happy-path samples.

### Cross-file Consistency [PROHIBITION]

Modify A → grep all consumers of changed interfaces/exports/types first. Change that breaks dependent file = not done.

### Over-engineering Prevention [PROHIBITION]

Make only changes directly requested or clearly necessary. Don't add features, refactor, or improve beyond what was asked. Don't add error handling or validation for impossible scenarios. Don't create helpers for one-time operations. Three similar lines > premature abstraction.

### File Creation Discipline [PROHIBITION]

Don't create files unless absolutely necessary. Prefer editing existing files. Don't add docstrings, comments, or type annotations to code you didn't change. Comments: only where logic isn't self-evident — explain WHY not WHAT.

### Backwards-Compatibility Hacks [PROHIBITION]

Don't rename unused `_vars`, re-export types, add `// removed` comments for deleted code, or add compatibility shims. If unused, delete completely.

### Concurrency Safety [PROHIBITION]

Identify all shared mutable state; apply synchronization (mutex, channels, actors, atomic). Prefer message-passing. Verify with concurrent test scenarios. Load `references/safety.md` for detailed patterns.

### Change Verification [GATE]

Modify function → verify: all other behaviors unchanged? All callers unaffected? Return type/shape unchanged? No conditional branch logic altered outside target?

### Migration Sweep [GATE]

Rename/move/interface change → grep entire codebase: all imports, implementors, configs, env vars, docs, tests reference new name? Build passes with zero broken references?

### Trust Verification [GATE]

Before any import/API/dependency → verify: in codebase? in registry? version correct? API available in that version? not transitive-only? Never assume from memory.

### Format Preservation [GATE]

Format/schema/data conversion → all fields preserved, including unknown ones? Target can't represent source field → warn explicitly. Round-trip produces identical output?

### Meaningful Test Data [GATE]

Use realistic values — `user@example.com` over `a@b.c`, `$99.99` over `$1`. Arbitrary minimal data hides precision errors. Test boundary conditions: empty, max-size, Unicode, timezone.

### Self-Verification [GATE]

After completing change: re-read modified file, verify change matches requirement, check for unintended side effects. Use `git diff` to confirm only intended lines changed.

### Non-Functional Accountability [GATE]

Security, performance, accessibility, observability, maintainability require explicit verification. After implementing any user-facing feature: verify a11y (keyboard nav, contrast), error handling (failure path?), observability (logged?).

### Artifact-First Recovery [GATE]

After context gap → re-read files before modifying (files survive context compression; conversation state does not). Tool error → diagnose, then different approach. Before reporting done → re-read modified files, verify no steps skipped, no TODOs left, original requirement fully satisfied.

### Task Pre-flight [GATE]

Before executing any task touching 3+ files or changing behavior: produce pre-flight block and wait for confirmation.

```
Goal:     [one-line: what changes and why]
Include:  [files / modules to modify]
Exclude:  [files / modules off-limits]
Output:   [code / tests / both]
Criteria: [lint clean / tests pass / type-check / etc.]
```

Scope ambiguous → ask one clarifying question first. Single-file cosmetic changes exempt.

## Process Framework

- **Before starting:** State end goal. Try simplest approach first. Complex tasks: track progress in file (not conversation memory — files survive context compression).
- **While working:** Execute steps in order. Verify each step before proceeding. Never skip a step.
- **Before finishing:** Re-read modified files. All steps completed? Original requirement fully met?
- **On uncertainty:** State it explicitly. Ask, don't guess.
- **On destructive actions:** Consider reversibility + blast radius. Force push, file deletion, schema drops — confirm with user first. Pausing is cheap; lost work is not.
- **On repeated failure:** Same fix fails 3× → stop and report what was tried and what blocked.
- **On scope expansion:** Finding count exceeds 2× estimate → stop and ask.
- **On AI-generated code:** Verify understanding before accepting. Critical paths (auth, payments, data mutations) require line-by-line verification.

## Quality Thresholds

### Complexity Limits

| Metric | Limit |
|--------|-------|
| Cyclomatic Complexity | ≤ 15 |
| Method Lines | ≤ 50 |
| File Lines | ≤ 500 |
| Nesting Depth | ≤ 3 |
| Parameters | ≤ 4 |

Flag when approaching limits. Refactor only when current task scope allows.

### Output & Edit Standards

Preserve existing file indentation style + surrounding code patterns. On Windows, use path format project already uses.

### Code Readability

Prefer boring-but-clear over clever-but-opaque.

- Descriptive names over short — `remainingRetries` over `r`
- Linear flow (early returns) over nested conditions
- Assumptions (input always > 0, list always non-empty) → document with assertion or comment

### Error Messages

Every error message: what was expected, what was received, how to fix it.

| Weak | Strong |
|------|--------|
| `"Invalid input"` | `"Expected positive integer for 'retries', got -1. Use a value >= 1."` |
| `"Auth failed"` | `"API key expired (last valid: 2026-03-01). Regenerate at /settings/api."` |
| `"Not found"` | `"User 'abc123' not found in tenant 'acme'. Verify the user ID and tenant."` |

### Function Contracts

Document at system boundaries: null-safety, exception semantics (throws vs returns error), side effects (I/O, state mutation, external calls), preconditions. Internal helpers: keep undocumented unless contract is non-obvious.

### Security Awareness

Validate at system boundaries (user input, external APIs), trust internal code. Audit for OWASP top 10.

**Human-verification gate:** Auth, payment, encryption, secrets management code requires human review before merge.

Shell command safety: quote all file paths, use `--` to separate flags from arguments, reject shell metacharacters in dynamic values. No hardcoded secrets in source, configs, or logs. Integrate security scanning into CI pipeline.

Load `references/safety.md` for detailed rules on auth, payments, crypto, multi-tenant, CORS.

### Error Handling

Catch specific exceptions, not broader. Propagate when unsure. Error handling must not hide a bug.

### i18n & Accessibility

Flag missing i18n/a11y as HIGH on user-facing apps. Don't auto-fix — propose framework's official i18n solution. Verify recommended package exists in project's ecosystem.

## Token & Context Efficiency

Before re-reading file already read this session → was it modified since? If unchanged, reference prior read. Summarize findings, don't echo. Describe delta — not full before/after.

## Operational Awareness

### Observability

Log at decision points + error paths in critical flows (auth, payments, data mutations, external API calls). Use structured logging (JSON) with correlation IDs.

| Log Level | Use For |
|-----------|---------|
| ERROR | Failures requiring attention |
| WARN | Degraded state — cache miss fallback, retry success, deprecated API |
| INFO | Business events — user actions, state transitions, deployment |
| DEBUG | Development diagnostics only |

### Production Defaults

| Setting | Dev Default (wrong) | Production Default (right) |
|---------|--------------------|-----------------------------|
| Connection pool | 5 | 20-50 (based on load) |
| Request timeout | 30s | 5-10s (fail fast) |
| Rate limit | unlimited | Defined per endpoint |
| Log level | DEBUG | INFO |

Validate all required env vars at startup — fail fast on missing config.

### Database Changes

Schema migrations: backward-compatible with previous app version (expand-contract). Include both `up` and `down`. Test rollback before production.

Data-destructive migrations (column drops, type narrowing): flag for human review.

Load `references/operations.md` for detailed deployment, caching, infrastructure, monitoring rules.

## Conventional Commit Classification

| Question | YES | NO |
|----------|-----|----|
| Can end users do something they **couldn't** before? | `feat` | `refactor`/`chore` |
| Was something **broken** for end users and now works? | `fix` | `refactor`/`chore` |

| Actual Change | Wrong | Correct |
|---------------|-------|---------|
| Refactor with same behavior | feat | refactor |
| Dev-only tooling change | feat | chore |
| Test-only fix | fix | test |
| Docs update | fix | docs |

When uncertain → non-bumping type. `ci: fix config` ≠ bump. `fix(ci): fix config` = patch bump. CI, docs, tests, config, tooling → always own type, never `feat`/`fix`.

## Toolchain Detection

| Signal | Toolchain |
|--------|-----------|
| `package.json` | npm/yarn/pnpm (check lockfile) |
| `go.mod` | go vet, go test, gofmt |
| `pyproject.toml` / `setup.py` | ruff/black, pytest |
| `Cargo.toml` | cargo clippy, cargo test, rustfmt |
| `Makefile` | make lint, make test |

README or config specifies toolchain → use directly.

## Operations

### Commit History

Unpushed commits = local WIP. Before push: if >1 commit with WIP signals (wip/fix/debug messages, same file in multiple commits, micro-commits ≤2 lines) → collapse to net diff and re-plan atomically.

### Tool Prerequisites

| Tool Role | Missing Behavior |
|-----------|-----------------|
| Critical (git, gh) | Stop with install instructions |
| Quality gate (linter, formatter) | Offer to install if installable. Declined/system-level → skip silently |
| Non-critical operational | Warn once, continue |

### Skip Patterns

Never flag intentionally marked code: `# noqa`, `# intentional`, `# safe:`, `_` prefix, `TYPE_CHECKING`, platform guards, test fixtures.

### Severity Levels

| Level | Criteria |
|-------|----------|
| CRITICAL | Security, data loss, crash |
| HIGH | Broken functionality |
| MEDIUM | Suboptimal but works |
| LOW | Style only |

When uncertain → lower severity.

### Fix Quality

DRY (no duplicate logic), SSOT, SoC (stay within module boundary), KISS, Consistency (match project patterns). Existing pattern present → reference it. New abstraction needed → only if 3+ uses. Cross-module change → flag for review.

## Project Types

| Type ID | UI Category |
|---------|-------------|
| `cli`, `library`, `devtool`, `extension` | Developer Tool |
| `api`, `data`, `ml` | Backend |
| `web`, `mobile`, `desktop`, `game` | Frontend |
| `iac`, `embedded` | Infrastructure |
| `monorepo` | Multi (sub-packages have own types) |

Detection: most specific match wins. Multiple signals → prefer type with more matches. Ambiguous → ask user. User-facing types (web, mobile, desktop) require i18n + a11y consideration.
