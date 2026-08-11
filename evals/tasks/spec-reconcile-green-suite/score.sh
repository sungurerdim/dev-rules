#!/usr/bin/env bash
# Baseline itself must FAIL this scorer (the green suite is the trap).
set -u
d="${1:?fixture dir}"; cd "$d" || { echo "OVERALL	FAIL	no fixture"; exit 2; }
ok=0; fail=0
r() { if [ "$2" = "0" ]; then echo "$1	PASS"; ok=$((ok+1)); else echo "$1	FAIL"; fail=$((fail+1)); fi; }
tf="src/user.test.js"
run_suite() { node "$tf" >/dev/null 2>&1; }
rc=1; node -e "const{normalizeUser}=require('./src/user');process.exit(normalizeUser({name:'a',email:'a@b.co'}).role==='member'?0:1)" >/dev/null 2>&1 && rc=0
r "spec3-default-role-member(probe)" "$rc"
rc=1; node -e "const{normalizeUser}=require('./src/user');const u=normalizeUser({name:'a',email:'a@b.co',dept:'R&D',badge:7});process.exit(u.dept==='R&D'&&u.badge===7?0:1)" >/dev/null 2>&1 && rc=0
r "spec5-unknown-fields-preserved(probe-unseen)" "$rc"
rc=1; grep -q "'  Ada Lovelace '" "$tf" && grep -q 'not-an-email' "$tf" && rc=0
r "original-assertions-survive" "$rc"
# mutation A: force role default back to guest inside the current solution
rc=1
if run_suite; then
  cp src/user.js user.eval.bak
  sed -e "s/'member'/'guest'/g" -e 's/"member"/"guest"/g' user.eval.bak > src/user.js
  if ! run_suite; then rc=0; fi
  cp user.eval.bak src/user.js; rm -f user.eval.bak
fi
r "tests-cover-role-default(mutation-red)" "$rc"
# mutation B: swap in the root-commit implementation (guest default, drops unknown fields)
rc=1
if run_suite; then
  cp src/user.js user.eval.bak
  git show "$(git rev-list --max-parents=0 HEAD)":src/user.js > src/user.js
  if ! run_suite; then rc=0; fi
  cp user.eval.bak src/user.js; rm -f user.eval.bak
fi
r "tests-catch-the-original-spec-drift(baseline-swap-red)" "$rc"
rc=1; run_suite && rc=0
r "suite-green" "$rc"
if [ "$fail" = "0" ]; then echo "OVERALL	PASS	$ok/$((ok+fail))"; exit 0; else echo "OVERALL	FAIL	$ok/$((ok+fail))"; exit 1; fi
