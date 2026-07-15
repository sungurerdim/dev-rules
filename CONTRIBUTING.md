# Contributing to dev-rules

## Local setup

No build step — this is a markdown artifact. Clone the repo and edit directly:

```bash
git clone https://github.com/sungurerdim/dev-rules.git
cd dev-rules
```

## Before opening a PR

1. Read [CLAUDE.md](CLAUDE.md) — the rule-authoring pre-checks, weakness-taxonomy mapping, and sync requirement all live there. Every new or modified rule in `rules.md` must pass those pre-checks.
2. Run the same checks CI runs:
   ```bash
   npx markdownlint-cli2 "**/*.md" "!research/2026-07/**"
   wc -l rules.md   # must stay ≤ 300 lines (target ~240)
   ```
3. If you touched `rules.md` or `references/`, re-sync the installed copies and verify (commands in [CLAUDE.md § Sync Requirement](CLAUDE.md#sync-requirement)).

## PR expectations

- One logical change per PR — keep diffs reviewable.
- Conventional Commits for the title (`docs:`, `fix:`, `ci:`, etc. — see [rules.md § Conventional Commits](rules.md)).
- New or changed rule → cite the evidence (≥2 documented real-world failure cases) per CLAUDE.md's pre-checks; note it in the PR description.
- CI (`markdownlint` + `links` + line-budget) must pass before merge — required status checks are enforced on `main`.

## Testing

"Tests" here are the CI gates: markdownlint, the `rules.md` line-budget check, and the lychee link checker. Run them locally (commands above) before pushing.
