# Development Rules

## Failure Prevention

### Scope Boundary [PROHIBITION]

Only touch lines the task requires. Unrelated issues: mention, don't fix. Never reformat untouched code, add annotations to unmodified functions, reorder imports beyond what the change requires, or change whitespace in unmodified lines.

### Test Integrity [PROHIBITION]

Fix the code or fix the test to correctly validate real behavior — weakening, skipping, mocking away, or relaxing assertions to make a test pass creates false confidence. Test environment must use real OS paths, production-equivalent layouts, and native host verification. Every bug fix includes a regression test.

Test boundary conditions: empty inputs, null/undefined values, maximum-size inputs, concurrent access, and locale/timezone edge cases. If a function handles data transformation, verify preservation with extreme/edge inputs — not just happy-path samples.

### Cross-file Consistency [PROHIBITION]

After modifying file A, verify no file B depends on the changed interface, export, type, or constant in a now-broken way. Grep all consumers before declaring done. A change that breaks a dependent file is not done. AI-generated code has 2× more cross-file dependency errors than human-written code.

### Over-engineering Prevention [PROHIBITION]

Only make changes directly requested or clearly necessary. Don't add features, refactor code, or make "improvements" beyond what was asked. Don't add error handling, fallbacks, or validation for scenarios that can't happen. Don't create helpers or abstractions for one-time operations. Don't design for hypothetical future requirements. Three similar lines of code is better than a premature abstraction.

### File Creation Discipline [PROHIBITION]

Don't create files unless absolutely necessary. Prefer editing existing files over creating new ones. Don't add docstrings, comments, or type annotations to code you didn't change. Only add comments where the logic isn't self-evident.

### Backwards-Compatibility Hacks [PROHIBITION]

Don't rename unused `_vars`, re-export types, add `// removed` comments for deleted code, or add compatibility shims. If something is unused, delete it completely.

### Concurrency Safety [PROHIBITION]

AI misuses concurrency primitives 2× more than human developers. When writing concurrent code: identify all shared mutable state, apply synchronization (mutex, channels, actors, atomic operations), verify with concurrent test scenarios. Prefer message-passing over shared state. When working on concurrent code: load `references/safety.md` for detailed patterns.

### Change Verification [GATE]

After modifying a function → verify: all other behaviors in that function unchanged? All callers unaffected? No return type/shape changes beyond the fix? No conditional branch logic altered outside the target?

### Migration Sweep [GATE]

After rename/move/interface change → grep/glob entire codebase: all imports, implementors, configs, env vars, docs, and tests reference the new name? Build passes with zero broken references?

### Trust Verification [GATE]

Before using any import, API, or dependency → verify it exists in codebase, registry, or docs. Check: package exists in registry? Version correct? API available in that version? Not transitive-only? Never assume from memory — AI models hallucinate packages, versions, and API signatures. Without verification, 63% of AI systems hallucinate dangerously within 90 days.

### Format Preservation [GATE]

During format/schema/data conversion → all fields preserved, including unknown ones? Target can't represent a source field → warn explicitly. Round-trip produces identical output?

### Meaningful Test Data [GATE]

Use realistic values that exercise actual business logic — `'user@example.com'` over `'a@b.c'`, `$99.99` over `$1`, `'John Smith'` over `'x'`. Arbitrary minimal test data creates false confidence: a discount calculation tested with `$1` hides precision errors visible at `$999.99`. Test boundary conditions: empty inputs, maximum-size inputs, Unicode, timezone edge cases.

### Self-Verification [GATE]

After completing a change: re-read the modified file, verify the change matches the requirement, check for unintended side effects in surrounding code. Use `git diff` to confirm only intended lines changed — unintended modifications are the most common agent failure mode. Predict the expected output before reading actual output — discrepancy signals a bug. Without verification gates, 63% of AI systems produce dangerous hallucinations within 90 days.

### Non-Functional Accountability [GATE]

Security, performance, accessibility, observability, and maintainability require explicit verification — not autopilot. Systems that "look functional" but lack these fail in production. After implementing any user-facing feature: verify a11y (keyboard nav, contrast), verify error handling (what happens on failure?), verify observability (is this operation logged?).

### Artifact-First Recovery [GATE]

After context gap → re-read files before modifying (conversation memory degrades after ~150-200 instructions and is not source of truth — structured files survive context compression, conversation state does not). Tool error → diagnose, then different approach (never retry identical command — but don't abandon a viable approach after a single failure either; diagnose before switching tactics). Before reporting done → re-read modified files, verify no steps skipped, no TODOs left behind, original requirement fully satisfied.

### Task Pre-flight [GATE]

Before executing any task that touches 3+ files or changes behavior (not cosmetic/docs edits): produce a compact pre-flight block and wait for user confirmation before modifying any files.

```
Goal:     [one-line: what changes and why]
Include:  [files / modules to modify]
Exclude:  [files / modules off-limits]
Output:   [code / tests / both]
Criteria: [lint clean / tests pass / type-check / etc.]
```

If scope is genuinely ambiguous, ask one clarifying question before showing the block — not after. Skip the question if the answer is inferable from the codebase, project rules, or prior conversation.

Single-file cosmetic changes (formatting, typos, comment edits, docs-only) are exempt.

## Process Framework

- **Before starting:** State the end goal. Try the simplest approach first. Complex tasks: track progress in a structured file (not just conversation memory — files survive context compression).
- **While working:** Execute numbered steps in order. Verify each step's output before proceeding. Never skip a step.
- **Before finishing:** Re-read modified files. All steps completed? Original requirement fully met?
- **On uncertainty:** State it explicitly. Ask, don't guess. Never assume requirements.
- **On destructive actions:** Consider reversibility and blast radius before executing. Force push, file deletion, schema drops, process kills — confirm with user before proceeding. The cost of pausing is low; the cost of lost work is high.
- **On repeated failure:** Same fix fails 3 times → stop and report. Don't loop — explain what was tried and what blocked progress.
- **On scope expansion:** Finding count exceeds 2x estimate → stop and ask before continuing.
- **On AI-generated code:** Verify understanding before accepting. Inability to explain what the code does signals unacceptable risk. Critical paths (auth, payments, data mutations) require line-by-line verification.
- **On state persistence:** Store critical requirements and progress in project rule files or a progress tracking file — conversation memory degrades after ~150-200 instructions. Files survive context compression; conversation state does not.

## Quality Thresholds

### Complexity Limits

Flag when code approaches these limits. Refactor only when current task scope allows.

| Metric | Limit |
|--------|-------|
| Cyclomatic Complexity | ≤ 15 |
| Method Lines | ≤ 50 |
| File Lines | ≤ 500 |
| Nesting Depth | ≤ 3 |
| Parameters | ≤ 4 |

### Output & Edit Standards

Preserve existing file indentation style and surrounding code patterns. On Windows, use the path format the project already uses.

### Code Readability

Prefer boring-but-clear over clever-but-opaque. The next developer (or AI) must understand the code without external context.

- Choose descriptive names over short names — `remainingRetries` over `r`
- Prefer linear flow (early returns) over nested conditions
- When an assumption exists (input always > 0, list always non-empty), document it with an assertion or comment

### Error Messages

Every error message includes: what was expected, what was received, and how to fix it.

| Weak | Strong |
|------|--------|
| `"Invalid input"` | `"Expected positive integer for 'retries', got -1. Use a value >= 1."` |
| `"Auth failed"` | `"API key expired (last valid: 2026-03-01). Regenerate at /settings/api."` |
| `"Not found"` | `"User 'abc123' not found in tenant 'acme'. Verify the user ID and tenant."` |

### Function Contracts

Document at system boundaries: null-safety (which params accept null), exception semantics (throws vs returns error), side effects (I/O, state mutation, external calls), and preconditions (valid input ranges).

Internal helper functions: keep undocumented unless the contract is non-obvious.

### Security Awareness

Validate at system boundaries (user input, external APIs), trust internal code. Audit for OWASP top 10: command injection, XSS, SQL injection, path traversal.

**Human-verification gate:** Authentication, payment processing, encryption, and secrets management code requires human review before merge. AI generates scaffold and tests; human verifies logic correctness.

Shell command safety: quote all file paths, use `--` to separate flags from arguments, reject shell metacharacters in dynamic values.

Store secrets in environment variables or secrets managers — verify no hardcoded secrets in source, configs, or logs.

Integrate security scanning into CI pipeline — catch issues at generation time, not post-review. 24-30% of AI-generated code contains serious CWE security flaws. SAST/DAST in CI is essential for AI-assisted projects.

When working on auth, payments, crypto, multi-tenant systems, or CORS: load `references/safety.md` for detailed rules.

### Error Handling

Catch specific exceptions, not broader. Propagate when unsure. Error handling must not hide a bug.

### i18n & Accessibility

Flag missing i18n/a11y as HIGH on user-facing apps. Don't auto-fix — propose the framework's official/canonical i18n solution and message format. Verify the recommended package exists in the project's ecosystem before suggesting.

## Token & Context Efficiency

### Incremental Reading

Before re-reading a file already read this session → was it modified since? If unchanged, reference prior read. When verifying changes, read only modified sections. Use LSP diagnostics for type/import checks instead of reading files.

### Concise Output

Avoid repeating file contents back to the user after reading. Summarize findings, don't echo. When explaining changes, describe the delta — not the full before/after.

## Operational Awareness

### Observability

Log at decision points and error paths in critical flows (auth, payments, data mutations, external API calls). Use structured logging (JSON) with correlation IDs for request tracing.

| Log Level | Use For |
|-----------|---------|
| ERROR | Failures requiring attention — failed transactions, auth failures, data corruption |
| WARN | Degraded state — cache miss fallback, retry success, deprecated API usage |
| INFO | Business events — user actions, state transitions, deployment events |
| DEBUG | Development diagnostics — only in non-production |

### Production Defaults

Configuration values must be production-grade. Local/dev defaults in production configs cause outages.

| Setting | Dev Default (wrong) | Production Default (right) |
|---------|--------------------|-----------------------------|
| Connection pool | 5 | 20-50 (based on expected load) |
| Request timeout | 30s | 5-10s (fail fast) |
| Rate limit | unlimited | Defined per endpoint |
| Log level | DEBUG | INFO |

Validate all required environment variables at startup — fail fast on missing config rather than failing at runtime.

### Database Changes

Schema migrations must be backward-compatible with the previous application version (expand-contract pattern). Include both `up` and `down` operations. Test rollback before applying to production.

Data-destructive migrations (column drops, type narrowing): flag for human review with data preservation verification.

When working on deployment, caching, infrastructure, or monitoring: load `references/operations.md` for detailed rules.

## Conventional Commit Classification

Litmus test — both must be YES for a version bump:

| Question | YES | NO |
|----------|-----|----|
| Can end users do something they **couldn't** before? | `feat` | `refactor`/`chore` |
| Was something **broken** for end users and now works? | `fix` | `refactor`/`chore` |

Common misclassifications:

| Actual Change | Wrong Type | Correct Type |
|---------------|-----------|-------------|
| Refactor with same behavior | feat | refactor |
| Dev-only tooling change | feat | chore |
| Test-only fix | fix | test |
| Docs update | fix | docs |

- When uncertain → always prefer non-bumping type
- Type ≠ scope. `ci: fix config` = no bump. `fix(ci): fix config` = patch bump. Use the correct TYPE.
- CI, docs, tests, config, tooling → always their own type, never `feat`/`fix`

## Toolchain Detection

Detect project toolchain from config files:

| Signal | Toolchain |
|--------|-----------|
| `package.json` scripts | npm/yarn/pnpm (check lockfile) |
| `go.mod` | go vet, go test, gofmt |
| `pyproject.toml` / `setup.py` | ruff/black, pytest |
| `Cargo.toml` | cargo clippy, cargo test, rustfmt |
| `Makefile` | make lint, make test |

If a project README or config specifies a toolchain, use it directly.

## Operations

### Commit History

Unpushed commits are local WIP — not permanent record. Before push: if >1 commit with WIP signals (wip/fix/debug/temp messages, same file in multiple commits, micro-commits ≤2 lines), collapse to net diff and re-plan atomically. Net diff is source of truth, not individual WIP steps.

### Tool Prerequisites

| Tool Role | Missing Behavior |
|-----------|-----------------|
| Critical (git, gh) | Stop with install instructions |
| Quality gate (linter, formatter) | Offer to install if installable (show command, ask user). If declined or system-level tool → skip silently |
| Non-critical operational | Warn once, continue |

### Skip Patterns

Never flag intentionally marked code: `# noqa`, `# intentional`, `# safe:`, `_` prefix, `TYPE_CHECKING` blocks, platform guards, test fixtures.

### Severity Levels

| Level | Criteria |
|-------|----------|
| CRITICAL | Security, data loss, crash |
| HIGH | Broken functionality |
| MEDIUM | Suboptimal but works |
| LOW | Style only |

When uncertain, choose lower severity.

### Fix Quality

Fixes must comply with: DRY (no duplicate logic), SSOT (no second source of truth), SoC (stay within module boundary), KISS (simplest solution), Consistency (match project patterns). A fix that violates these principles is a new problem, not a solution.

Verify before suggesting/applying: existing pattern exists? → reference it. New abstraction needed? → only if 3+ uses. Cross-module change? → flag for review.

## Project Types

| Type ID | UI Category |
|---------|-------------|
| `cli`, `library`, `devtool`, `extension` | Developer Tool |
| `api`, `data`, `ml` | Backend |
| `web`, `mobile`, `desktop`, `game` | Frontend |
| `iac`, `embedded` | Infrastructure |
| `monorepo` | Multi (sub-packages have own types) |

Detection: most specific match wins. Multiple signals → prefer type with more matches. Ambiguous → ask user.

User-facing types (web, mobile, desktop) require i18n and a11y consideration.
