# Development Rules

## Failure Prevention

### Scope Boundary [PROHIBITION]

Only touch lines the task requires. Unrelated issues: mention, don't fix. Never reformat untouched code, add annotations to unmodified functions, reorder imports beyond what the change requires, or change whitespace in unmodified lines.

### Test Integrity [PROHIBITION]

Never weaken, skip, mock away, or relax assertions to make a test pass. Fix the code, or fix the test to correctly validate real behavior. Test environment must use real OS paths, production-equivalent layouts, and native host verification — not bypassed in harness. Every bug fix includes a regression test.

### Cross-file Consistency [PROHIBITION]

After modifying file A, verify no file B depends on the changed interface, export, type, or constant in a now-broken way. Grep all consumers before declaring done. A change that breaks a dependent file is not done.

### Change Verification [GATE]

After modifying a function → verify: all other behaviors in that function unchanged? All callers unaffected? No return type/shape changes beyond the fix? No conditional branch logic altered outside the target?

### Migration Sweep [GATE]

After rename/move/interface change → grep/glob entire codebase: all imports, implementors, configs, env vars, docs, and tests reference the new name? Build passes with zero broken references?

### Trust Verification [GATE]

Before using any import, API, or dependency → verify it exists in codebase, registry, or docs. Check: package exists in registry? Version correct? API available in that version? Not transitive-only? Never assume from memory.

### Format Preservation [GATE]

During format/schema/data conversion → all fields preserved, including unknown ones? Target can't represent a source field → warn explicitly. Round-trip produces identical output?

### Artifact-First Recovery [GATE]

After context gap → re-read files before modifying (conversation memory is not source of truth). Tool error → diagnose, then different approach (never retry identical command). Before reporting done → re-read modified files, verify no steps skipped, no TODOs left behind, original requirement fully satisfied.

## Process Framework

- **Before starting:** State the end goal. Complex tasks: track progress explicitly.
- **While working:** Execute numbered steps in order. Verify each step's output before proceeding. Never skip a step.
- **Before finishing:** Re-read modified files. All steps completed? Original requirement fully met?
- **On uncertainty:** State it explicitly. Ask, don't guess. Never assume requirements.
- **On scope expansion:** Finding count exceeds 2x estimate → stop and ask before continuing.

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

### Error Handling

Catch specific exceptions, never broader. Propagate when unsure. Error handling must never hide a bug.

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
| Quality gate (linter, formatter) | Skip silently — project-specific, absence expected |
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
