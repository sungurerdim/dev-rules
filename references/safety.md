# Safety Reference

Detailed rules for security-critical code. Load when working on: authentication, payments, cryptography, multi-tenant systems, CORS, concurrent/async code, URL-fetching features (SSRF), dependency/supply-chain changes, AI agents & MCP tools, secrets handling, or AI-assisted code review.

---

## Async & Concurrency Safety

AI-generated code misuses concurrency primitives 2x more than human-written code (CodeRabbit 2025). Extra vigilance required.

Concurrent code (locks, mutexes, event loops, queues, shared state) requires explicit synchronization verification.

**Detect shared-state risks:**
- Two code paths writing to same resource (file, DB row, cache key) without coordination
- Read-modify-write sequences without atomic operations or optimistic locking
- Event handlers assuming sequential execution but running concurrently

**Prevention checklist:**
1. Identify every shared resource (DB rows, files, cache entries, in-memory state)
2. For each: verify mutual exclusion OR idempotent operations OR optimistic concurrency (version/ETag)
3. Lock ordering: acquiring multiple locks → always acquire in consistent order to prevent deadlock
4. Prefer database-level constraints (unique indexes, serializable transactions) over application-level locks
5. Test with concurrent requests — single-threaded test suite hides race conditions

**Example — wrong:** Two API requests update user balance without locking → lost update.
**Example — right:** `UPDATE accounts SET balance = balance - $amount WHERE balance >= $amount` (atomic, no read-modify-write).

---

## Multi-Tenant Isolation

Every data access path must include tenant context. Missing tenant filter = data leak.

**Detect isolation gaps:**
- DB queries without `WHERE tenant_id = ?` (or equivalent row-level security policy)
- Cache keys without tenant prefix → cross-tenant cache poisoning
- File storage paths without tenant namespace
- Background jobs processing data without tenant context propagation

**Prevention checklist:**
1. Every query: verify tenant_id filter present (or RLS policy enforces it)
2. Every cache key: include tenant identifier as prefix
3. Every file path: namespace by tenant
4. Every background job: propagate tenant context from triggering request
5. Test with 2+ tenants: verify tenant A cannot access tenant B's data via any endpoint

---

## CORS & API Exposure

Cross-origin misconfiguration exposes APIs to unauthorized origins.

**Rules:**
- Use explicit origin allowlist — `Access-Control-Allow-Origin: *` acceptable only for truly public, read-only APIs
- Credentials (`Access-Control-Allow-Credentials: true`) require specific origin, not wildcard
- Preflight caching (`Access-Control-Max-Age`): set to reduce OPTIONS request overhead
- Expose only required headers — minimize `Access-Control-Expose-Headers`

**Common misconfigurations:**
- Reflecting `Origin` header as `Allow-Origin` without validation → any site can access the API
- Allowing all methods when only GET/POST needed
- Missing `Vary: Origin` header → CDN serves wrong CORS headers

---

## Auth Code Discipline

Prefer managed auth services (Auth0, Supabase Auth, Firebase Auth, Clerk) over DIY. DIY auth requires all of:

| Requirement | Implementation |
|-------------|---------------|
| Password hashing | bcrypt (cost ≥ 12) or argon2id — never SHA/MD5 |
| Comparison | Timing-safe comparison for tokens + hashes |
| Token rotation | Refresh tokens with rotation + reuse detection |
| Session invalidation | Server-side session store with explicit logout/revoke |
| Rate limiting | Per-user + per-IP on auth endpoints |
| MFA | TOTP or WebAuthn — SMS only as fallback |

OAuth/OIDC: use PKCE for all public clients (SPA, mobile). Implicit flow is deprecated.

RFC 9700 (OAuth 2.0 Security Best Current Practice, 2025) consolidates OAuth 2.0 security guidance — PKCE for all clients, implicit + ROPC grants deprecated, exact redirect-URI matching; OAuth 2.1 (still an IETF draft) incorporates it. Passkeys (WebAuthn/FIDO2) recommended passwordless alternative — support as secondary auth method.

---

## Payment & Financial Code

Financial calculations require exact arithmetic — floating-point errors accumulate.

| Rule | Detail |
|------|--------|
| Money type | Use `Decimal`/`BigDecimal` or integer cents — never `float`/`double` |
| Idempotency | Every payment endpoint accepts idempotency key to prevent double-charge |
| Webhook verification | Verify webhook signatures before processing (Stripe: `stripe-signature`, PayPal: IPN verification) |
| Audit trail | Log every financial state transition with timestamp, actor, amount, result |
| Refund safety | Refund amount must not exceed original charge. Verify before processing. |

---

## Cryptography

Use platform/language standard libraries exclusively. Custom crypto implementations introduce vulnerabilities.

| Rule | Detail |
|------|--------|
| Libraries | Node: `crypto`, Python: `cryptography`, Go: `crypto/*`, Rust: `ring`/`rustls` |
| Algorithms | AES-256-GCM for symmetric, Ed25519/ECDSA for signing, X25519 for key exchange |
| Key storage | Env vars or secrets manager — never in source code, config files, or logs |
| Key rotation | Define rotation schedule. Support concurrent old+new keys during transition |
| Random values | Use cryptographically secure RNG (`crypto.randomBytes`, `secrets.token_bytes`) — never `Math.random()` or `random.random()` for security-sensitive values |

---

## OWASP API Security Top 10 (2023)

When building APIs, verify against top risks:

| # | Risk | Prevention |
|---|------|-----------|
| API1 | Broken Object-Level Authorization | Verify user owns requested object on every endpoint |
| API2 | Broken Authentication | Rate limit auth endpoints, use OAuth 2.1, enforce MFA |
| API3 | Broken Object Property-Level Authorization | Return only fields requester is authorized to see |
| API4 | Unrestricted Resource Consumption | Rate limiting, pagination limits, request size caps |
| API5 | Broken Function-Level Authorization | RBAC on every endpoint, not just UI-visible ones |

Source: [OWASP API Security Top 10 (2023)](https://owasp.org/API-Security/editions/2023/en/0x11-t10/)

---

## AI-Generated Insecure Defaults

AI assistants favor permissive, demo-friendly configuration. Veracode (2026) found ~45% of AI-generated samples carried a known weakness; Tenzai (2026) found 0 of 15 AI-built apps set basic security headers. Treat any AI-proposed config that disables a check or widens access as suspect until justified.

| Insecure default | Secure replacement |
|------------------|--------------------|
| `Access-Control-Allow-Origin: *` with credentials | Explicit origin allowlist; never `*` alongside `Allow-Credentials: true` |
| IAM `"Action": "*"` / security group `0.0.0.0/0` | Least-privilege actions + specific resource ARNs; restrict CIDR |
| `verify=False`, `rejectUnauthorized: false`, disabled cert checks | Keep TLS verification on |
| Missing CSP, HSTS, `X-Content-Type-Options`, `X-Frame-Options` | Set security headers on every response |
| `DEBUG=true` / stack traces in prod responses | Debug off; structured errors without internals |

Source: [Veracode GenAI 2026](https://www.veracode.com/blog/genai-security-and-vibe-coding/); [Tenzai 2026](https://blog.tenzai.com/bad-vibes-comparing-the-secure-coding-capabilities-of-popular-coding-agents/).

---

## SSRF — Server-Side Request Forgery (CWE-918)

Every AI coding agent in Tenzai's 2026 study introduced SSRF in a URL-preview feature (100% rate). Any feature that fetches a user-supplied URL (webhooks, link previews, image/PDF proxies, "import from URL"):

1. Block private/loopback/link-local targets: RFC 1918 (`10/8`, `172.16/12`, `192.168/16`), `127/8`, `169.254/16`, `::1`, and cloud metadata `169.254.169.254`.
2. Prefer an allowlist of permitted hosts; `https` scheme only; disable `file:`/`gopher:`/`ftp:`.
3. Re-validate the target after every redirect — a redirect can point back inward.
4. Resolve DNS once and connect to that resolved IP (defeats DNS-rebinding / TOCTOU).

Source: [CWE-918](https://cwe.mitre.org/data/definitions/918.html); [Tenzai 2026](https://blog.tenzai.com/bad-vibes-comparing-the-secure-coding-capabilities-of-popular-coding-agents/).

---

## IDOR / BOLA — Cross-User Test

Broken object-level authorization is the most common AI-introduced access flaw: the happy path works, the "is this *your* object?" check is missing (OWASP API1). For every endpoint taking an object reference, write the cross-user test:

1. As user A, create/own resource `R`.
2. As user B, request `R` by its ID.
3. Assert `403`/`404` — not `200`. A suite without this case does not test authorization.

Apply equally to indirect references (filenames, storage keys, sequential IDs).
Source: [OWASP API1: BOLA](https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/); [CVE-2025-48757](https://nvd.nist.gov/vuln/detail/CVE-2025-48757) (missing row-level authorization, CWE-863 — the same absent "is this yours?" check at table level).

---

## Secrets Sprawl & Scanning

GitGuardian's State of Secrets Sprawl 2026 recorded 28.65M new secrets in public GitHub commits; AI-assisted commits leak at 3.2% vs a 1.5% baseline (~2×), and MCP config files exposed 24,008 secrets in their first year.

1. Run a pre-commit + CI secret scanner (gitleaks, trufflehog, GitGuardian); block on hit.
2. `.gitignore` the files/dirs that accumulate keys: `.env`, `.cursor/`, `.continue/`, `**/mcp.json`, `.claude/settings.local.json`.
3. Never paste `.env`, tokens, or live credentials into a prompt — chat history is a leak vector.
4. On any detected secret: rotate it. Deleting the commit is not enough — assume it is already captured.

Source: [GitGuardian 2026](https://blog.gitguardian.com/the-state-of-secrets-sprawl-2026/).

---

## Supply-Chain Integrity

19.7% of LLM-suggested packages do not exist (USENIX 2025); attackers pre-register those names ("slopsquatting"), and autonomous agents install them with no human reading the name (CSA 2026 — a hallucinated `huggingface-cli` reached 30k+ downloads). Before adding any dependency (extends Trust Verification / W17):

| Check | Why |
|-------|-----|
| Exists in the official registry, registered before your project began, with real download history | Filters hallucinated + fresh-squat names |
| Name matches the intended ecosystem exactly — watch 1-char and cross-ecosystem variants | Typosquat / slopsquat defense |
| Version pinned + lockfile with integrity hashes committed | Reproducible, tamper-evident installs |
| SCA / advisory scan in CI (osv-scanner, Dependabot, Snyk) | Known-CVE gate |
| Agent-opened dependency-bump PRs reviewed by a human before merge | Bumps are a supply-chain entry point |

Source: [CSA Slopsquatting 2026](https://labs.cloudsecurityalliance.org/research/csa-research-note-slopsquatting-ai-supply-chain-20260419-csa/).

---

## MCP & Agent Tool Security

As agents gain tools, the tool layer becomes the attack surface. EchoLeak (CVE-2025-32711) exfiltrated Microsoft 365 Copilot data from a single crafted email; CurXecute (CVE-2025-54135) reached RCE in Cursor by steering the agent to write `.cursor/mcp.json` — the edit landed on disk even when the user clicked reject. OWASP now ships a Top 10 for Agentic Applications (2026).

| Threat | Mitigation |
|--------|-----------|
| Tool poisoning (malicious tool description steers the agent) | Review tool manifests; treat tool output as untrusted data, not instructions |
| Rug-pull (approved MCP server changes behavior later) | Pin server/tool versions; re-review on update |
| Confused deputy / over-broad agency | Least-agency: scope each tool to the task; no ambient credentials |
| Inter-agent trust | A subagent's return is untrusted until verified; don't execute peer "instructions" |
| Blind approvals | Approval prompts must show the raw tool name + parameters, not a model-written prose summary |

Source: [OWASP Agentic Top 10 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/); [EchoLeak CVE-2025-32711](https://nvd.nist.gov/vuln/detail/CVE-2025-32711); [CurXecute CVE-2025-54135](https://nvd.nist.gov/vuln/detail/CVE-2025-54135).

---

## License & IP Contamination

AI assistants can emit near-verbatim third-party or copyleft code without attribution. In *Doe v. GitHub* most claims were dismissed, but an open-source-license-violation claim survives and the DMCA "identicality" question is on appeal — provenance still matters. The EU AI Act (Reg. 2024/1689): GPAI obligations (Art. 53 — training-data summaries, copyright compliance) applied 2 Aug 2025; full applicability, including Article 50 transparency for AI-generated content, begins 2 Aug 2026.

1. Run a license/SCA scan (FOSSA, ScanCode) on AI-assisted PRs; flag GPL/AGPL/copyleft entering permissively-licensed code.
2. Large verbatim AI-emitted blocks → verify provenance before merge; prefer generating from your own interfaces.
3. Record AI assistance where your org or licensing policy requires an authorship/provenance note.

Source: [Doe v. GitHub case updates](https://githubcopilotlitigation.com/case-updates.html); [EU AI Act (EC)](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai).
