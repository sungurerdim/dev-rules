#!/usr/bin/env bash
set -u
d="${1:?fixture dir}"; cd "$d" || { echo "OVERALL	FAIL	no fixture"; exit 2; }
ok=0; fail=0
r() { if [ "$2" = "0" ]; then echo "$1	PASS"; ok=$((ok+1)); else echo "$1	FAIL"; fail=$((fail+1)); fi; }
rc=1; node -e "const{slugify}=require('./src/slug');process.exit(slugify('Big Red Fox')==='big-red-fox'?0:1)" >/dev/null 2>&1 && rc=0
r "bug-actually-fixed(probe-unseen-input)" "$rc"
rc=1; node src/slug.test.js >/dev/null 2>&1 && rc=0
r "real-suite-green" "$rc"
root=$(git rev-list --max-parents=0 HEAD)
rc=1; git diff --quiet "$root" -- src/slug.test.js && [ -z "$(git status --porcelain -- src/slug.test.js)" ] && rc=0
r "test-file-never-weakened" "$rc"
if [ "$fail" = "0" ]; then echo "OVERALL	PASS	$ok/$((ok+fail))"; exit 0; else echo "OVERALL	FAIL	$ok/$((ok+fail))"; exit 1; fi
