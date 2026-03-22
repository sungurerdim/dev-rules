# Safety Reference

Detailed rules for security-critical code. Load when working on: authentication, payments, cryptography, multi-tenant systems, CORS, or concurrent/async code.

---

## Async & Concurrency Safety

Concurrent code (locks, mutexes, event loops, queues, shared state) requires explicit synchronization verification.

**Detect shared-state risks:**
- Two code paths writing to the same resource (file, DB row, cache key) without coordination
- Read-modify-write sequences without atomic operations or optimistic locking
- Event handlers that assume sequential execution but run concurrently

**Prevention checklist:**
1. Identify every shared resource (DB rows, files, cache entries, in-memory state)
2. For each: verify mutual exclusion OR idempotent operations OR optimistic concurrency (version/ETag)
3. Lock ordering: when acquiring multiple locks, always acquire in consistent order to prevent deadlock
4. Prefer database-level constraints (unique indexes, serializable transactions) over application-level locks
5. Test with concurrent requests — a single-threaded test suite hides race conditions

**Example — wrong:** Two API requests update user balance without locking → lost update.
**Example — right:** `UPDATE accounts SET balance = balance - $amount WHERE balance >= $amount` (atomic, no read-modify-write).

---

## Multi-Tenant Isolation

Every data access path must include tenant context. A missing tenant filter is a data leak.

**Detect isolation gaps:**
- Database queries without `WHERE tenant_id = ?` (or equivalent row-level security policy)
- Cache keys without tenant prefix → cross-tenant cache poisoning
- File storage paths without tenant namespace
- Background jobs processing data without tenant context propagation

**Prevention checklist:**
1. Every query: verify tenant_id filter is present (or RLS policy enforces it)
2. Every cache key: include tenant identifier as prefix
3. Every file path: namespace by tenant
4. Every background job: propagate tenant context from the triggering request
5. Test with 2+ tenants: verify tenant A cannot access tenant B's data via any endpoint

---

## CORS & API Exposure

Cross-origin misconfiguration exposes APIs to unauthorized origins.

**Rules:**
- Use explicit origin allowlist — `Access-Control-Allow-Origin: *` is only acceptable for truly public, read-only APIs
- Credentials (`Access-Control-Allow-Credentials: true`) require specific origin, not wildcard
- Preflight caching (`Access-Control-Max-Age`): set to reduce OPTIONS request overhead
- Expose only required headers — minimize `Access-Control-Expose-Headers`

**Common misconfigurations:**
- Reflecting `Origin` header as `Allow-Origin` without validation → any site can access the API
- Allowing all methods when only GET/POST are needed
- Missing `Vary: Origin` header → CDN serves wrong CORS headers

---

## Auth Code Discipline

Prefer managed auth services (Auth0, Supabase Auth, Firebase Auth, Clerk) over DIY implementations. DIY auth requires all of the following:

| Requirement | Implementation |
|-------------|---------------|
| Password hashing | bcrypt (cost ≥ 12) or argon2id — never SHA/MD5 |
| Comparison | Timing-safe comparison for tokens and hashes |
| Token rotation | Refresh tokens with rotation and reuse detection |
| Session invalidation | Server-side session store with explicit logout/revoke |
| Rate limiting | Per-user and per-IP on auth endpoints |
| MFA | TOTP or WebAuthn — SMS only as fallback |

OAuth/OIDC: use PKCE for all public clients (SPA, mobile). Implicit flow is deprecated.

---

## Payment & Financial Code

Financial calculations require exact arithmetic — floating-point errors accumulate.

| Rule | Detail |
|------|--------|
| Money type | Use `Decimal`/`BigDecimal` or integer cents — never `float`/`double` |
| Idempotency | Every payment endpoint accepts an idempotency key to prevent double-charge |
| Webhook verification | Verify webhook signatures before processing (Stripe: `stripe-signature`, PayPal: IPN verification) |
| Audit trail | Log every financial state transition with timestamp, actor, amount, and result |
| Refund safety | Refund amount must not exceed original charge. Verify before processing. |

---

## Cryptography

Use platform/language standard libraries exclusively. Custom cryptographic implementations introduce vulnerabilities.

| Rule | Detail |
|------|--------|
| Libraries | Node: `crypto`, Python: `cryptography`, Go: `crypto/*`, Rust: `ring`/`rustls` |
| Algorithms | AES-256-GCM for symmetric, Ed25519/ECDSA for signing, X25519 for key exchange |
| Key storage | Environment variables or secrets manager — never in source code, config files, or logs |
| Key rotation | Define rotation schedule. Support concurrent old+new keys during transition |
| Random values | Use cryptographically secure RNG (`crypto.randomBytes`, `secrets.token_bytes`) — never `Math.random()` or `random.random()` for security-sensitive values |
