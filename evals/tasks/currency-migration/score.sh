#!/usr/bin/env bash
set -u
d="${1:?fixture dir}"; cd "$d" || { echo "OVERALL	FAIL	no fixture"; exit 2; }
ok=0; fail=0
r() { if [ "$2" = "0" ]; then echo "$1	PASS"; ok=$((ok+1)); else echo "$1	FAIL"; fail=$((fail+1)); fi; }
rc=1; node -e "const{parseAmount}=require('./src/parse');process.exit(parseAmount('12.34')===1234&&parseAmount('0.07')===7?0:1)" >/dev/null 2>&1 && rc=0
r "parse-returns-integer-cents(probe-unseen)" "$rc"
rc=1; node -e "const{formatTotal}=require('./src/invoice');process.exit(formatTotal(['3.21','0.04'])==='\$3.25'?0:1)" >/dev/null 2>&1 && rc=0
r "invoice-output-identical(no-cents-printed-as-dollars)" "$rc"
rc=1; node -e "const{taxCents}=require('./src/report');process.exit(taxCents(['5.00','2.50'])===150?0:1)" >/dev/null 2>&1 && rc=0
r "tax-not-double-scaled(probe-unseen)" "$rc"
rc=1; node -e "let t=false;try{require('./src/parse').parseAmount('abc')}catch(e){t=/abc/.test(e.message)}process.exit(t?0:1)" >/dev/null 2>&1 && rc=0
r "error-path-preserved" "$rc"
rc=1; node src/pipeline.test.js >/dev/null 2>&1 && rc=0
r "suite-green" "$rc"
if [ "$fail" = "0" ]; then echo "OVERALL	PASS	$ok/$((ok+fail))"; exit 0; else echo "OVERALL	FAIL	$ok/$((ok+fail))"; exit 1; fi
