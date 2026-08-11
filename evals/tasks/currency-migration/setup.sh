#!/usr/bin/env bash
# End-to-end semantic migration: parseAmount must move from dollar floats to
# integer cents, with three dependent modules whose assumptions are coupled —
# the naive change double-scales tax and prints cents as dollars.
set -euo pipefail
d="${1:?target dir}"; rm -rf "$d"; mkdir -p "$d/src"
cd "$d"; git init -q -b main; git config user.email eval@example.com; git config user.name "Eval Fixture"
cat > src/parse.js <<'JS'
function parseAmount(str) {
  const v = Number.parseFloat(str);
  if (!Number.isFinite(v) || v < 0) { throw new Error(`Expected non-negative amount, got "${str}"`); }
  return v;
}
module.exports = { parseAmount };
JS
cat > src/cart.js <<'JS'
const { parseAmount } = require('./parse');
function total(amountStrs) {
  return amountStrs.reduce((sum, s) => sum + parseAmount(s), 0);
}
module.exports = { total };
JS
cat > src/invoice.js <<'JS'
const { total } = require('./cart');
function formatTotal(amountStrs) {
  return `$${total(amountStrs).toFixed(2)}`;
}
module.exports = { formatTotal };
JS
cat > src/report.js <<'JS'
const { total } = require('./cart');
// VAT is 20%, reported in integer cents.
function taxCents(amountStrs) {
  return Math.round(total(amountStrs) * 100 * 0.2);
}
module.exports = { taxCents };
JS
cat > src/pipeline.test.js <<'JS'
const { formatTotal } = require('./invoice');
const { taxCents } = require('./report');
if (formatTotal(['12.34', '0.66']) !== '$13.00') { throw new Error('invoice format'); }
if (taxCents(['10.00']) !== 200) { throw new Error('vat 20% of 10.00 is 200 cents'); }
let threw = false; try { require('./parse').parseAmount('-1'); } catch (e) { threw = true; }
if (!threw) { throw new Error('rejects negative'); }
JS
git add -A; git commit -qm "chore: initial fixture state (suite green, dollar floats)"
echo "fixture ready: $d"
