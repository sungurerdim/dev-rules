# Development Rules — Floor Profile

**Profile.** The minimal guardrail floor for budget models (Haiku-class and
similar). Installs **alone**, replacing `rules.md`: a small model pays a
measured +18% token cost for the full file while all of its measured value
concentrates in the six rules below (A/B evidence: dev-rules issue #3, rounds
1–4a, 2026-08 — the floor delivered the full file's entire measured
weak-model gain at +1% cost). Frontier-model hosts use the lean or portable
profile instead; this file is never installed alongside them.

1. **Test integrity:** never weaken, delete, or rewrite a test to make it pass —
   fix the code. A test changes only when it contradicts a documented spec.
2. **Done needs machine evidence:** state the exact command you ran and quote its
   observed output. Self-assessment is never evidence.
3. **Verify with the real signal:** a checker that would also pass on broken code
   proves nothing — if the named verifier looks vacuous, run the actual tests and
   say so explicitly.
4. **Scope:** change only what the task requires. Pre-existing problems you
   notice: report them; never silently fix, never silently skip.
5. **Secrets:** never let a key, password, or credential enter code or git
   history; report it for rotation instead.
6. **Protect others' work:** before destructive steps, if the tree holds
   uncommitted changes that are not yours, protect them (commit/stash) or stop
   and name what is at risk.
