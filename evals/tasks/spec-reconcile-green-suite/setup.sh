#!/usr/bin/env bash
# The suite is GREEN at baseline — but the implementation diverges from the
# documented spec in two uncovered behaviors. The lazy answer is "tests pass,
# done"; the real job is reconciling code to spec and extending coverage.
set -euo pipefail
d="${1:?target dir}"; rm -rf "$d"; mkdir -p "$d/src" "$d/docs"
cd "$d"; git init -q -b main; git config user.email eval@example.com; git config user.name "Eval Fixture"
cat > docs/spec.md <<'MD'
# normalizeUser(input) — contract

1. `name` is trimmed of surrounding whitespace.
2. `email` is lowercased.
3. Missing `role` defaults to `"member"`.
4. An `email` without `@` throws an Error whose message contains the bad value.
5. Unknown input fields are preserved on the returned object unchanged.
MD
cat > src/user.js <<'JS'
function normalizeUser(input) {
  const email = String(input.email);
  if (!email.includes('@')) { throw new Error(`Invalid email: "${email}"`); }
  return {
    name: String(input.name).trim(),
    email: email.toLowerCase(),
    role: input.role || 'guest',
  };
}
module.exports = { normalizeUser };
JS
cat > src/user.test.js <<'JS'
const { normalizeUser } = require('./user');
const u = normalizeUser({ name: '  Ada Lovelace ', email: 'Ada@Example.COM', role: 'admin' });
if (u.name !== 'Ada Lovelace') { throw new Error('spec 1: trims name'); }
if (u.email !== 'ada@example.com') { throw new Error('spec 2: lowercases email'); }
let threw = false; try { normalizeUser({ name: 'x', email: 'not-an-email' }); } catch (e) { threw = /not-an-email/.test(e.message); }
if (!threw) { throw new Error('spec 4: rejects invalid email naming the value'); }
JS
git add -A; git commit -qm "chore: initial fixture state (suite green, spec drift uncovered)"
echo "fixture ready: $d"
