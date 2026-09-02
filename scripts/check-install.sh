#!/usr/bin/env bash
# dev-rules installer gate — proves the profile/stale contract of install.sh against a throwaway
# target tree. Runs at commit time via .githooks/pre-commit; this repo has no CI, so this is the
# only mechanical check on installer behaviour.
# Portable: bash + coreutils + grep + sed (macOS, Linux, Git Bash on Windows). No python, no network.
#
#   bash scripts/check-install.sh              every case against this checkout's install.sh
#   bash scripts/check-install.sh --self-test  prove the cases go red on a deliberately broken installer
#
# Exit 0 only when every case passes. A case that cannot run is a failure, never a pass.
set -u

root=${DEV_RULES_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}
fail=0
pass() { printf 'PASS  %s\n' "$1"; }
red()  { printf 'FAIL  %s\n' "$1"; fail=$((fail+1)); }

tmp=$(mktemp -d); trap '[ -n "${tmp:-}" ] && rm -rf "$tmp"' EXIT

# The name the pre-installer manual-copy layout left under rules/, where everything auto-loads.
LEGACY=rules/portable-supplement.md
plant() { printf 'superseded supplement from the manual-cp era\n' > "$1/$LEGACY"; }

# contract INSTALLER — every case for one installer copy; increments `fail` on each breach
contract() {
  local ins=$1 tgt=$tmp/target out rc
  rm -rf "$tgt"; mkdir -p "$tgt/rules"

  # 1. Issue #6: the pre-installer copy auto-loads, so installing must clear it.
  plant "$tgt"
  bash "$ins" --target "$tgt" --profile lean >/dev/null 2>&1
  if [ -f "$tgt/$LEGACY" ]; then
    red "lean install leaves $LEGACY in place — it would auto-load beside the lean rules"
  else
    pass "lean install clears the pre-installer $LEGACY"
  fi

  # 2. Nothing of ours may sit in the always-loaded directory except the profile's own file.
  out=$(ls "$tgt/rules" 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
  if [ "$out" = "dev-rules.md" ]; then
    pass "lean install leaves exactly dev-rules.md under rules/"
  else
    red "lean install leaves '$out' under rules/ — expected only dev-rules.md"
  fi

  # 3. A freshly installed tree must read clean.
  if bash "$ins" --target "$tgt" --check >/dev/null 2>&1; then
    pass "--check exits 0 on a freshly installed lean tree"
  else
    red "--check exits non-zero right after its own install"
  fi

  # 4. Re-planted by hand → --check must name it, not report a clean tree.
  plant "$tgt"
  out=$(bash "$ins" --target "$tgt" --check 2>&1); rc=$?
  if [ "$rc" -ne 0 ] && printf '%s' "$out" | grep -q "STALE.*$LEGACY"; then
    pass "--check exits 1 and reports STALE for a hand-placed $LEGACY"
  else
    red "--check exit=$rc and did not report STALE for $LEGACY — drift would pass silently"
  fi

  # 5. Switching profiles must not leave the other profile's always-loaded file behind.
  rm -rf "$tgt"
  bash "$ins" --target "$tgt" --profile portable >/dev/null 2>&1
  if [ -f "$tgt/rules/dev-rules-supplement.md" ]; then
    bash "$ins" --target "$tgt" --profile lean >/dev/null 2>&1
    if [ -f "$tgt/rules/dev-rules-supplement.md" ]; then
      red "portable→lean leaves rules/dev-rules-supplement.md behind — both layers would load"
    else
      pass "portable→lean clears rules/dev-rules-supplement.md"
    fi
  else
    red "portable install did not produce rules/dev-rules-supplement.md — the profile is broken"
  fi

  # 6. floor claims no references; a lean→floor switch must clear the on-demand set.
  rm -rf "$tgt"
  bash "$ins" --target "$tgt" --profile lean >/dev/null 2>&1
  bash "$ins" --target "$tgt" --profile floor >/dev/null 2>&1
  out=$(ls "$tgt/dev-rules-references" 2>/dev/null | grep -v '^VERSION$' | tr '\n' ' ' | sed 's/ $//')
  if [ -z "$out" ]; then
    pass "lean→floor clears the on-demand references the floor profile does not claim"
  else
    red "lean→floor leaves '$out' under dev-rules-references/ — the floor profile claims none"
  fi
}

# The broken copy reverts exactly one thing: the pre-installer name in stale_paths.
self_test() {
  local broken=$tmp/broken removed rc
  mkdir -p "$broken/references"
  cp "$root/rules.md" "$root/floor.md" "$broken/"
  cp "$root"/references/*.md "$broken/references/"
  grep -v 'pre-installer manual-copy name' "$root/install.sh" > "$broken/install.sh"
  removed=$(( $(wc -l < "$root/install.sh") - $(wc -l < "$broken/install.sh") ))
  if [ "$removed" -ne 1 ]; then
    red "self-test: expected to remove exactly 1 line from install.sh, removed $removed — the marker comment moved, so this test no longer breaks what it claims to"
    return
  fi

  ( fail=0; contract "$root/install.sh" >/dev/null 2>&1; exit "$fail" ); rc=$?
  if [ "$rc" -eq 0 ]; then pass "self-test control: the contract is green on this checkout's installer"
  else red "self-test control: the contract is red on this checkout's installer ($rc case(s))"; fi

  ( fail=0; contract "$broken/install.sh" >/dev/null 2>&1; exit "$fail" ); rc=$?
  if [ "$rc" -ne 0 ]; then pass "self-test: the contract goes red ($rc case(s)) on an installer missing the pre-installer name"
  else red "self-test: the contract stayed green on the broken installer — it does not actually guard issue #6"; fi
}

case "${1:-}" in
  --self-test) self_test ;;
  "") contract "$root/install.sh" ;;
  *) echo "usage: $0 [--self-test]"; exit 2 ;;
esac
if [ "$fail" -eq 0 ]; then echo "OK: all cases passed"; exit 0; else echo "RED: $fail case(s) failed"; exit 1; fi
