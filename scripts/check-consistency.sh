#!/usr/bin/env bash
# dev-rules consistency gate — the exact checks CI runs, runnable locally.
# Portable: bash + coreutils + awk + grep + sed (macOS, Linux, Git Bash on Windows). No python.
#
#   bash scripts/check-consistency.sh              run every check against this repo
#   bash scripts/check-consistency.sh --self-test  prove each check goes red on a deliberately broken copy
#
# Exit 0 only when every check passes. A check that cannot run is a failure, never a pass.
set -u

RULES_LIMIT=130      # rules.md hard line limit — CLAUDE.md, CONTRIBUTING.md and README.md must state this number
RULES_TARGET=110     # rules.md target line count
FLOOR_LIMIT=30       # floor.md hard line limit
OVERLAP_MAX=2        # shared 7-word sequences allowed between rules.md and the portable supplement
TOKEN_TOLERANCE=15   # percent: README's stated token figure vs measured chars/4

root=${DEV_RULES_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}
tmp=""            # scratch dir for --self-test; removed on exit
fail=0
pass() { printf 'PASS  %s\n' "$1"; }
red()  { printf 'FAIL  %s\n' "$1"; fail=$((fail+1)); }
rd()   { tr -d '\r' < "$1"; }                 # read without CR bytes (Windows checkouts)
lines(){ rd "$1" | wc -l | tr -d ' '; }

# 1. Line budgets ---------------------------------------------------------------------------------
check_line_budgets() {
  local n
  n=$(lines "$root/rules.md")
  if [ "$n" -le "$RULES_LIMIT" ]; then pass "line-budget rules.md: $n lines (target ~$RULES_TARGET, limit $RULES_LIMIT)"
  else red "line-budget rules.md: $n lines exceeds the $RULES_LIMIT-line limit"; fi
  n=$(lines "$root/floor.md")
  if [ "$n" -le "$FLOOR_LIMIT" ]; then pass "line-budget floor.md: $n lines (limit $FLOOR_LIMIT)"
  else red "line-budget floor.md: $n lines exceeds the $FLOOR_LIMIT-line limit"; fi
}

# 2. Profile delta: the supplement must never restate rules.md (shared 7-word sequences) ----------
check_overlap() {
  local out count
  out=$(awk -v N=7 '
    { gsub(/[^A-Za-z0-9 ]/, " "); n = split(tolower($0), t, " ")
      for (i = 1; i <= n; i++) if (t[i] != "") { if (FILENAME == ARGV[1]) A[++na] = t[i]; else B[++nb] = t[i] } }
    END {
      for (i = 1; i + N - 1 <= na; i++) { s = A[i]; for (j = 1; j < N; j++) s = s " " A[i+j]; SA[s] = 1 }
      for (i = 1; i + N - 1 <= nb; i++) { s = B[i]; for (j = 1; j < N; j++) s = s " " B[i+j]
        if ((s in SA) && !(s in seen)) { seen[s] = 1; c++; print "      shared: " s } }
      print c + 0
    }' "$root/rules.md" "$root/references/portable-supplement.md")
  count=$(printf '%s\n' "$out" | tail -n 1)
  if [ "$count" -le "$OVERLAP_MAX" ]; then pass "overlap rules.md/supplement: $count shared 7-grams (max $OVERLAP_MAX)"
  else red "overlap rules.md/supplement: $count shared 7-grams (max $OVERLAP_MAX) — the supplement restates rules.md"
       printf '%s\n' "$out" | sed '$d'; fi
}

# 3. Rule-name references: backticked names in rule-design.md's taxonomy and harness-survey sections
#    must be real headings in rules.md, floor.md or the supplement --------------------------------
headings() {
  rd "$root/rules.md" | sed -n 's/^\*\*\([^*]*\)\*\*.*/\1/p' | sed 's/ \[GATE\]//; s/[.:]$//'
  rd "$root/rules.md" | sed -n 's/^## //p' | sed 's/ \[GATE\]//'
  rd "$root/floor.md" | sed -n 's/^[0-9]*\. \*\*\([^:*]*\):\*\*.*/\1/p'
  rd "$root/references/portable-supplement.md" | sed -n 's/^## //p'
}
section() { rd "$root/references/rule-design.md" | awk -v t="## $1" '$0 == t { f = 1; next } /^## / { f = 0 } f'; }
check_rule_refs() {
  local hs refs r unknown="" missing=0
  hs=$(headings)
  refs=$({ section "AI Weakness Taxonomy"; section "Harness Coverage Survey"; } | grep -o '`[^`]*`' | tr -d '`' | sort -u)
  if [ -z "$refs" ]; then red "rule-refs: no backticked rule names found in the taxonomy/harness sections of rule-design.md"; return; fi
  while IFS= read -r r; do
    if ! printf '%s\n' "$hs" | grep -Fxq -- "$r"; then unknown="$unknown      unknown rule name: $r
"; missing=$((missing+1)); fi
  done < <(printf '%s\n' "$refs")
  if [ "$missing" -eq 0 ]; then pass "rule-refs: every backticked rule name in rule-design.md resolves to a heading in rules.md, floor.md or the supplement"
  else red "rule-refs: $missing backticked name(s) in rule-design.md match no heading in rules.md, floor.md or the supplement"; printf '%s' "$unknown"; fi
}

# 4. Budget mirror: the docs that state the rules.md line budget must all agree with this script ----
check_budget_mirror() {
  local f n bad=0
  for f in CLAUDE.md CONTRIBUTING.md README.md; do
    for n in $(rd "$root/$f" | grep -oE '[0-9]{3} lines' | grep -oE '[0-9]{3}' | sort -u); do
      case "$n" in "$RULES_LIMIT"|"$RULES_TARGET") ;;
        *) printf '      %s states "%s lines" (limit is %s, target %s)\n' "$f" "$n" "$RULES_LIMIT" "$RULES_TARGET"; bad=$((bad+1)) ;;
      esac
    done
    rd "$root/$f" | grep -q "$RULES_LIMIT lines" || { printf '      %s does not state the %s-line limit\n' "$f" "$RULES_LIMIT"; bad=$((bad+1)); }
  done
  if [ "$bad" -eq 0 ]; then pass "budget-mirror: CLAUDE.md, CONTRIBUTING.md and README.md all state the $RULES_LIMIT-line limit and no other"
  else red "budget-mirror: $bad line-budget statement(s) disagree with this script"; fi
}

# 5. Token estimate: README's figure for rules.md must track the measured size (chars/4) ------------
check_token_estimate() {
  local stated measured lo hi
  stated=$(rd "$root/README.md" | grep -oE '~[0-9,]+ tokens for the main file' | head -n 1 | grep -oE '[0-9,]+' | tr -d ,)
  if [ -z "$stated" ]; then red "token-estimate: README.md has no '~N tokens for the main file' statement"; return; fi
  measured=$(( $(rd "$root/rules.md" | wc -c | tr -d ' ') / 4 ))
  lo=$(( measured * (100 - TOKEN_TOLERANCE) / 100 )); hi=$(( measured * (100 + TOKEN_TOLERANCE) / 100 ))
  if [ "$stated" -ge "$lo" ] && [ "$stated" -le "$hi" ]; then pass "token-estimate: README says ~$stated tokens, measured ~$measured (chars/4, within $TOKEN_TOLERANCE%)"
  else red "token-estimate: README says ~$stated tokens, measured ~$measured (chars/4) — update the README figure"; fi
}

run_all() { check_line_budgets; check_overlap; check_rule_refs; check_budget_mirror; check_token_estimate; }

# Self-test: every check must go red on a copy broken in exactly the way it guards against ----------
self_test() {
  local src
  tmp=$(mktemp -d); trap '[ -n "$tmp" ] && rm -rf "$tmp"' EXIT
  src=$root
  fresh() {
    rm -rf "$tmp/case"; mkdir -p "$tmp/case/references"
    cp "$src"/rules.md "$src"/floor.md "$src"/README.md "$src"/CLAUDE.md "$src"/CONTRIBUTING.md "$tmp/case/"
    cp "$src"/references/*.md "$tmp/case/references/"
  }
  expect() { # expect NAME CHECK-FUNCTION WANT — WANT=1: the check must fail on the broken copy; WANT=0: it must pass
    local name=$1 fn=$2 want=$3 rc got
    ( root="$tmp/case"; fail=0; "$fn" >/dev/null 2>&1; exit "$fail" ); rc=$?
    got=green; [ "$rc" -ne 0 ] && got=red
    if [ "$want" = 1 ] && [ "$got" = red ]; then pass "self-test $name: red on the broken copy"
    elif [ "$want" = 0 ] && [ "$got" = green ]; then pass "self-test $name: green on the untouched copy"
    else red "self-test $name: got $got on the $([ "$want" = 1 ] && echo broken || echo untouched) copy"; fi
  }
  fresh; expect "control" run_all 0
  fresh; yes "padding line" | head -n 200 >> "$tmp/case/rules.md"; expect "line-budget rules.md" check_line_budgets 1
  fresh; yes "padding line" | head -n 40 >> "$tmp/case/floor.md"; expect "line-budget floor.md" check_line_budgets 1
  fresh; rd "$src/rules.md" | awk '{ if (length($0) > length(m)) m = $0 } END { print m }' >> "$tmp/case/references/portable-supplement.md"; expect "overlap" check_overlap 1
  fresh; rd "$src/references/rule-design.md" | awk -v add='| W99 | Bogus | x | `No Such Rule` |' '{ print } $0 == "## AI Weakness Taxonomy" { print add }' > "$tmp/case/references/rule-design.md"; expect "rule-refs" check_rule_refs 1
  fresh; rd "$src/CONTRIBUTING.md" | sed "s/$RULES_LIMIT lines/300 lines/" > "$tmp/case/CONTRIBUTING.md"; expect "budget-mirror" check_budget_mirror 1
  fresh; rd "$src/README.md" | sed 's/~[0-9,]* tokens for the main file/~9,000 tokens for the main file/' > "$tmp/case/README.md"; expect "token-estimate" check_token_estimate 1
}

case "${1:-}" in
  --self-test) self_test ;;
  "") run_all ;;
  *) echo "usage: $0 [--self-test]"; exit 2 ;;
esac
if [ "$fail" -eq 0 ]; then echo "OK: all checks passed"; exit 0; else echo "RED: $fail check(s) failed"; exit 1; fi
