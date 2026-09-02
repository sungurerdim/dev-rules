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
   bash scripts/check-consistency.sh --self-test && bash scripts/check-consistency.sh   # line budgets (rules.md <= 130 lines, target ~110), profile overlap, rule-name references, README figures
   npx markdownlint-cli2 "**/*.md" "!research/2026-07/**"
   bash scripts/check-cross-repo.sh --allow-missing-sibling   # dev-skills boundary; a checkout at ../dev-skills makes it a real check
   ```
3. If you touched `rules.md`, `floor.md` or `references/`, re-install and verify: `./install.sh && ./install.sh --check` (layout in [CLAUDE.md § Sync Requirement](CLAUDE.md#sync-requirement)).

## PR expectations

- One logical change per PR — keep diffs reviewable.
- Conventional Commits for the title (`docs:`, `fix:`, `ci:`, etc. — see [rules.md § Conventional Commits](rules.md)).
- New or changed rule → cite the evidence (≥2 documented real-world failure cases) per CLAUDE.md's pre-checks; note it in the PR description.
- CI (`lint` = consistency script + markdownlint, `links` = lychee) must pass before merge — required status checks are enforced on `main`.

## Testing

"Tests" here are the CI gates: the consistency script (line budgets, profile overlap, rule-name references, README figures — each check proven red by its own `--self-test`), markdownlint, and the lychee link checker. Run them locally (commands above) before pushing.
