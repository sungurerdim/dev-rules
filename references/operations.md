# Operations Reference

Detailed rules for operational concerns. Load when working on: deployment, caching, infrastructure, or observability.

---

## Observability Baseline

Every production service needs structured logging, metrics, and health checks.

**Structured logging format:**
```json
{"timestamp": "ISO8601", "level": "ERROR", "service": "api", "correlation_id": "req-abc", "message": "...", "context": {...}}
```

**Correlation IDs:** Generate a unique ID per request. Propagate through all downstream calls (HTTP headers, queue messages, background jobs). Include in every log entry.

**Alert thresholds:**

| Metric | Alert When |
|--------|-----------|
| Error rate | > 1% of requests in 5-minute window |
| Latency p99 | > 2x baseline for 5 minutes |
| Queue depth | Growing for > 10 minutes |
| Disk/memory | > 85% utilization |
| Certificate expiry | < 14 days remaining |

**Health check endpoints:** `/health` returns 200 when service is operational. `/ready` returns 200 when service can accept traffic (DB connected, cache warm, dependencies reachable).

Source: [OpenTelemetry Specification (2025)](https://opentelemetry.io/docs/specs/otel/)

---

## Cache Coherence

Every cache interaction must define: TTL, invalidation strategy, and stale-data tolerance.

**TTL selection guide:**

| Data Type | Suggested TTL | Rationale |
|-----------|--------------|-----------|
| Static assets | 1 year + cache busting (content hash in URL) | Immutable after deploy |
| User profile | 5-15 minutes | Tolerates brief staleness |
| Auth tokens | Match token expiry | Security-critical — must not outlive validity |
| API responses | 30s-5m depending on update frequency | Balance freshness vs load |
| Configuration | 1-5 minutes or event-driven invalidation | Must reflect changes promptly |

**Invalidation strategies:**
- **Write-through:** Update cache on every write. Consistent but slower writes.
- **Write-behind:** Queue cache updates. Faster writes but briefly stale.
- **Event-driven:** Publish invalidation events on data change. Best for distributed systems.
- **TTL-only:** Accept staleness up to TTL. Simplest, sufficient for many use cases.

**Cache stampede prevention:** When a popular cache key expires, many requests hit the database simultaneously. Mitigate with: stale-while-revalidate, mutex/lock on cache miss, or probabilistic early expiration.

---

## Configuration Validation

**Startup validation:** Check all required config values before accepting traffic. Missing or invalid config → fail fast with a clear error message listing every missing variable.

**Environment separation:**
- `.env.example` in repo with placeholder values and comments — never real secrets
- `.env` in `.gitignore` — never committed
- Production secrets via secrets manager (Vault, AWS Secrets Manager, GCP Secret Manager, Doppler)

**Feature flags:** Every flag has an owner and expiration date. Flags older than 90 days without explicit extension: schedule for removal. Dead flags increase complexity and test surface.

---

## Database Migration Safety

**Expand-contract pattern:** When changing a column or table, expand first (add new), migrate data, update code, then contract (remove old). This allows the previous application version to still function during deployment.

**Safe migration checklist:**

| Step | Verification |
|------|-------------|
| 1. Write migration | Both `up` and `down` operations defined |
| 2. Test on copy | Run against production-schema copy with realistic data volume |
| 3. Verify rollback | Execute `down`, verify data integrity, execute `up` again |
| 4. Check performance | Migration completes within maintenance window (or is online-safe) |
| 5. Backup | Point-in-time backup exists before production execution |

**Data-destructive operations** (DROP COLUMN, ALTER TYPE narrowing, DELETE without WHERE): require explicit human approval. Verify data preservation or document accepted data loss.

**Large table migrations:** Use online migration tools (gh-ost, pt-online-schema-change, pgroll) for tables > 1M rows to avoid locking.

---

## Deployment Safety

**Pre-deployment checklist:**

| Check | Verification |
|-------|-------------|
| Rollback plan | Previous version can be restored within 5 minutes |
| Health checks | `/health` and `/ready` endpoints respond correctly |
| Graceful shutdown | Application handles SIGTERM, drains connections, completes in-flight requests |
| Smoke tests | Critical user journeys pass in staging before production deploy |
| Monitoring | Dashboards and alerts configured for the new feature/change |

**Staged rollout:** For high-risk changes, deploy incrementally: 1% → 10% → 50% → 100%. Monitor error rates and latency at each stage. Automated rollback if error rate exceeds threshold.

**Zero-downtime deployment:** Use blue-green or rolling deployment. Verify: database migrations are backward-compatible, no breaking API changes for in-flight requests, session state survives instance rotation.

**Container security:** Scan images for CVEs before deploying (Trivy, Snyk Container). Use distroless or chainguard base images for minimal attack surface. Source: [Docker Security Best Practices (2025)](https://docs.docker.com/build/building/best-practices/)

**Post-deployment:** Monitor for 15 minutes after full rollout. Compare error rates, latency, and business metrics against pre-deployment baseline.
