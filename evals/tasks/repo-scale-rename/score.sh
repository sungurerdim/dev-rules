#!/usr/bin/env bash
# Rename formatMoney -> formatCurrency, no alias, all 12 consumers working,
# nothing outside the consumer set modified.
set -u
d="${1:?fixture dir}"; cd "$d" || { echo "OVERALL	FAIL	no fixture"; exit 2; }
ok=0; fail=0
r() { if [ "$2" = "0" ]; then echo "$1	PASS"; ok=$((ok+1)); else echo "$1	FAIL"; fail=$((fail+1)); fi; }
rc=1; node -e "const c=require('./src/currency');process.exit(c.formatCurrency&&c.formatCurrency(150)==='\$1.50'&&c.formatMoney===undefined?0:1)" >/dev/null 2>&1 && rc=0
r "core-renamed-no-alias" "$rc"
bad=0
for i in 017 034 051 068 085 102 119 136 153 170; do
  node -e "const m=require('./src/mod_$i');process.exit(m.priceLabel_$i(999)==='item-$i: \$9.99'?0:1)" >/dev/null 2>&1 || bad=$((bad+1))
done
rc=1; [ "$bad" = "0" ] && rc=0
r "all-10-direct-consumers-work(missed=$bad)" "$rc"
rc=1; node -e "const m=require('./src/mod_060');process.exit(m.hubLabel_060(50)==='hub-060: \$0.50'?0:1)" >/dev/null 2>&1 && rc=0
r "hub-reexport-consumer-works" "$rc"
rc=1; node -e "const m=require('./src/mod_120');process.exit(m.dynLabel_120(1)==='dyn-120: \$0.01'?0:1)" >/dev/null 2>&1 && rc=0
r "dynamic-require-consumer-works" "$rc"
rc=1; [ -z "$(git grep -l 'formatMoney' -- src 2>/dev/null)" ] && rc=0
r "zero-formatMoney-residue-in-src" "$rc"
rc=1; node src/pipeline.test.js >/dev/null 2>&1 && rc=0
r "suite-green" "$rc"
root=$(git rev-list --max-parents=0 HEAD)
allowed="src/currency.js src/util/index.js src/pipeline.test.js src/mod_017.js src/mod_034.js src/mod_051.js src/mod_068.js src/mod_085.js src/mod_102.js src/mod_119.js src/mod_136.js src/mod_153.js src/mod_170.js src/mod_060.js src/mod_120.js"
extra=""
for f in $( { git diff --name-only "$root"; git status --porcelain | awk '{print $2}'; } | sort -u); do
  case " $allowed " in *" $f "*) ;; *) extra="$extra $f";; esac
done
rc=1; [ -z "$extra" ] && rc=0
r "no-collateral-edits(extra:${extra:- none})" "$rc"
if [ "$fail" = "0" ]; then echo "OVERALL	PASS	$ok/$((ok+fail))"; exit 0; else echo "OVERALL	FAIL	$ok/$((ok+fail))"; exit 1; fi
