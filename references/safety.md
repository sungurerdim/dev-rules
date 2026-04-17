# Safety Reference

Detailed rules for security-critical code. Load when working on: authentication, payments, cryptography, multi-tenant systems, CORS, or concurrent/async code.

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

RFC 9700 (OAuth 2.1, 2025) consolidates OAuth 2.0 best practices. Passkeys (WebAuthn/FIDO2) recommended passwordless alternative — support as secondary auth method.

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

## OWASP API Security Top 10 (2025)

When building APIs, verify against top risks:

| # | Risk | Prevention |
|---|------|-----------|
| API1 | Broken Object-Level Authorization | Verify user owns requested object on every endpoint |
| API2 | Broken Authentication | Rate limit auth endpoints, use OAuth 2.1, enforce MFA |
| API3 | Broken Object Property-Level Authorization | Return only fields requester is authorized to see |
| API4 | Unrestricted Resource Consumption | Rate limiting, pagination limits, request size caps |
| API5 | Broken Function-Level Authorization | RBAC on every endpoint, not just UI-visible ones |

Source: [OWASP API Security Top 10 (2023)](https://owasp.org/API-Security/editions/2023/en/0x11-t10/)
