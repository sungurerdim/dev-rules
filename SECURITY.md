# Security Policy

## Reporting a vulnerability

This repository ships markdown instruction files (`rules.md`, `references/*.md`) with no runtime, no dependencies, and no user data — the primary security-relevant risk is a rule that could cause an AI agent to take an unsafe action (e.g. weaken a security check, leak secrets, or execute unsafe shell patterns) if adopted as-is.

If you find such an issue, please use [GitHub's private vulnerability reporting](https://github.com/sungurerdim/dev-rules/security/advisories/new) rather than opening a public issue.

## Scope

- Content of `rules.md` and `references/*.md` that could lead an AI coding agent to behave unsafely.
- `install.sh`, `scripts/*.sh`, or `.githooks/pre-commit` — shell that runs on a contributor's machine and could be made to execute or install something unintended.

This repository runs no CI: there are no GitHub Actions workflows and no secrets available to a pull request, so workflow-injection and secret-exfiltration reports do not apply.

Not in scope: this repo has no application runtime, no hosted service, and no user data to compromise.

## Response

This is a solo-maintained open-source project — best-effort response, no guaranteed SLA.
