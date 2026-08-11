#!/usr/bin/env bash
# Context-pressure fixture: 180 modules + docs noise; formatMoney has 12 real
# consumers (10 direct, 1 via the util re-export hub, 1 dynamic require) and
# many prose decoys. The task is a no-alias project-wide rename.
set -euo pipefail
d="${1:?target dir}"; rm -rf "$d"; mkdir -p "$d"
cd "$d"; git init -q -b main; git config user.email eval@example.com; git config user.name "Eval Fixture"
python3 - <<'PY'
import os
os.makedirs('src/util', exist_ok=True)
os.makedirs('docs', exist_ok=True)
open('src/currency.js','w').write(
    "function formatMoney(cents) {\n"
    "  return `$${(cents / 100).toFixed(2)}`;\n"
    "}\n"
    "module.exports = { formatMoney };\n")
open('src/util/index.js','w').write(
    "const { formatMoney } = require('../currency');\n"
    "function clamp(x, lo, hi) { return Math.min(hi, Math.max(lo, x)); }\n"
    "module.exports = { formatMoney, clamp };\n")
direct = [17, 34, 51, 68, 85, 102, 119, 136, 153, 170]
hub_consumer, dyn_consumer = 60, 120
for i in range(180):
    name = f'src/mod_{i:03d}.js'
    if i in direct:
        body = (f"const {{ formatMoney }} = require('./currency');\n"
                f"function priceLabel_{i:03d}(cents) {{ return `item-{i:03d}: ${{formatMoney(cents)}}`; }}\n"
                f"module.exports = {{ priceLabel_{i:03d} }};\n")
    elif i == hub_consumer:
        body = (f"const util = require('./util');\n"
                f"function hubLabel_{i:03d}(cents) {{ return `hub-{i:03d}: ${{util.formatMoney(cents)}}`; }}\n"
                f"module.exports = {{ hubLabel_{i:03d} }};\n")
    elif i == dyn_consumer:
        body = (f"const money = require('./' + 'curr' + 'ency');\n"
                f"function dynLabel_{i:03d}(cents) {{ return `dyn-{i:03d}: ${{money.formatMoney(cents)}}`; }}\n"
                f"module.exports = {{ dynLabel_{i:03d} }};\n")
    else:
        decoy = "// formats money-like magnitudes for display widgets\n" if i % 9 == 0 else ""
        body = (decoy +
                f"function calc_{i:03d}(a, b) {{ return a * {i % 7 + 2} + b; }}\n"
                f"module.exports = {{ calc_{i:03d} }};\n")
    open(name, 'w').write(body)
for k in range(25):
    open(f'docs/note_{k:02d}.md','w').write(
        f"# Note {k:02d}\n\nOperational notes about pricing displays and money formatting conventions.\n")
open('src/pipeline.test.js','w').write(
    "const { formatMoney } = require('./currency');\n"
    "const { priceLabel_017 } = require('./mod_017');\n"
    "const { hubLabel_060 } = require('./mod_060');\n"
    "const { dynLabel_120 } = require('./mod_120');\n"
    "if (formatMoney(150) !== '$1.50') { throw new Error('core formats cents'); }\n"
    "if (priceLabel_017(999) !== 'item-017: $9.99') { throw new Error('direct consumer'); }\n"
    "if (hubLabel_060(50) !== 'hub-060: $0.50') { throw new Error('hub consumer'); }\n"
    "if (dynLabel_120(1) !== 'dyn-120: $0.01') { throw new Error('dynamic consumer'); }\n")
PY
git add -A; git commit -qm "chore: initial fixture state (180 modules, suite green)"
echo "fixture ready: $d ($(ls src | wc -l | tr -d ' ') files in src)"
