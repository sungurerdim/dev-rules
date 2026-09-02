#!/usr/bin/env bash
# Cross-repo drift check — dev-rules and dev-skills each keep their own copy of the shared
# process doctrine (owner decision 2026-09-02, rule-design.md › Overlap Design Decision). This
# script reads a sibling dev-skills checkout and fails when an anchor phrase is missing on
# either side, so the two copies cannot drift silently.
#
#   bash scripts/check-cross-repo.sh [SIBLING]              default sibling: ../dev-skills
#   bash scripts/check-cross-repo.sh --allow-missing-sibling  CI: no sibling → SKIPPED, exit 0
#
# Each anchor: phrase | dev-rules file | dev-skills file (core/ first, references/ as fallback).
# Portable: bash + coreutils + grep (macOS, Linux, Git Bash on Windows).
set -u

root=$(cd "$(dirname "$0")/.." && pwd)
sibling="$root/../dev-skills"
allow_missing=0
for a in "$@"; do
  case "$a" in
    --allow-missing-sibling) allow_missing=1 ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) sibling="$a" ;;
  esac
done

if [ ! -d "$sibling" ]; then
  if [ "$allow_missing" = 1 ]; then echo "SKIPPED (not verified): no dev-skills checkout at $sibling"; exit 0; fi
  echo "FAIL  no dev-skills checkout at $sibling — pass the path, or --allow-missing-sibling to skip visibly"; exit 1
fi

anchors='
≤ ~5 files and ≤ ~25 tool calls|rules.md|execution-loop.md
stop, report actual scope, re-confirm|rules.md|execution-loop.md
Verification-Infrastructure Gap|rules.md|execution-loop.md
red-at-baseline|rules.md|execution-loop.md
3 attempts|rules.md|execution-loop.md
Breaking-first|rules.md|principles.md
Error Ownership|rules.md|principles.md
Checkpoint|rules.md|checkpoint-protocol.md
Decided without asking — say if wrong|rules.md|report-and-outcome-templates.md
Only you can do|rules.md|report-and-outcome-templates.md
never an activity count|rules.md|report-and-outcome-templates.md
'

resolve_skill_file() { # core/ is the current home; references/ is the pre-2026-09 layout
  if [ -f "$sibling/core/$1" ]; then echo "$sibling/core/$1"
  elif [ -f "$sibling/references/$1" ]; then echo "$sibling/references/$1"
  else echo ""; fi
}

fail=0; ok=0
while IFS='|' read -r phrase rfile sfile; do
  [ -n "$phrase" ] || continue
  rpath="$root/$rfile"; spath=$(resolve_skill_file "$sfile")
  if [ -z "$spath" ]; then echo "DRIFT  '$phrase': dev-skills file $sfile not found (core/ or references/)"; fail=$((fail+1)); continue; fi
  miss=""
  tr -d '\r' < "$rpath" | grep -Fq -- "$phrase" || miss="$miss dev-rules/$rfile"
  tr -d '\r' < "$spath" | grep -Fq -- "$phrase" || miss="$miss dev-skills/${spath#"$sibling"/}"
  if [ -z "$miss" ]; then ok=$((ok+1))
  else echo "DRIFT  '$phrase' missing in:$miss"; fail=$((fail+1)); fi
done <<EOF
$anchors
EOF

echo "anchors present on both sides: $ok, drifted: $fail (sibling: $sibling)"
[ "$fail" -eq 0 ] && exit 0 || exit 1
