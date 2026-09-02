# Contributing to dev-rules

## Local setup

No build step — this is a markdown artifact. Clone the repo and edit directly:

```bash
git clone https://github.com/sungurerdim/dev-rules.git
cd dev-rules
git config core.hooksPath .githooks   # enables the commit gate — do this once
```

That last line is not optional housekeeping: **this repo runs no CI.** Nothing checks a push after the fact, so every gate runs in `.githooks/pre-commit`, before the commit exists. Without it you get no checks at all.

## Before you commit

1. Read [CLAUDE.md](CLAUDE.md) — the rule-authoring pre-checks, weakness-taxonomy mapping, and sync requirement all live there. Every new or modified rule in `rules.md` must pass those pre-checks.
2. The hook runs the gates for you. To run them by hand:
   ```bash
   bash scripts/check-consistency.sh --self-test && bash scripts/check-consistency.sh   # line budgets (rules.md <= 130 lines, target ~110), profile overlap, rule-name references, doc figures
   bash scripts/check-install.sh --self-test && bash scripts/check-install.sh           # install.sh profile/stale contract
   bash scripts/check-cross-repo.sh --allow-missing-sibling                             # dev-skills boundary — reporting only, see #7
   npx markdownlint-cli2 "**/*.md" "!research/2026-07/**" "!ds/audit/**"                 # hook runs it only if already on PATH
   ```
3. If you touched `rules.md`, `floor.md` or `references/`, re-install and verify: `./install.sh && ./install.sh --check` (layout in [CLAUDE.md § Sync Requirement](CLAUDE.md#sync-requirement)).

## Pull requests

- One logical change per PR — keep diffs reviewable.
- Conventional Commits for the title (`docs:`, `fix:`, `test:`, etc. — see [rules.md § Conventional Commits](rules.md)).
- New or changed rule → cite the evidence (≥2 documented real-world failure cases) per CLAUDE.md's pre-checks; note it in the PR description.
- No automated check runs on your PR. Paste the output of the gates above into the description so a reviewer can see they were green on your machine.

## Testing

"Tests" here are the commit gates: the consistency script (line budgets, profile overlap, rule-name references, doc figures) and the installer script (profile/stale contract). Neither is trusted on its own word — each ships a `--self-test` that deliberately breaks a throwaway copy and fails if the check stays green. markdownlint and the lychee link checker run opportunistically, only when already installed.
