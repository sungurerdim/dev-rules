#!/usr/bin/env bash
# dev-rules installer — picks a profile, copies the right files into a Claude Code-style
# layout, stamps what was installed, and can check the installed copy for drift.
#
#   ./install.sh                         lean profile into ~/.claude (the default)
#   ./install.sh --profile portable      rules.md + the supplement (both always loaded)
#   ./install.sh --profile floor         floor.md alone, for budget models
#   ./install.sh --target DIR            install under DIR instead of ~/.claude
#   ./install.sh --check                 compare the installed copy with this checkout; exit 1 on drift
#   ./install.sh --update                git pull --ff-only, then re-install with the stamped profile
#
# Layout under the target (Claude Code auto-loads everything in rules/, nothing else):
#   rules/dev-rules.md                     rules.md  (floor profile: floor.md)
#   rules/dev-rules-supplement.md          portable profile only
#   dev-rules-references/{safety,operations,portable-supplement}.md   on-demand references
#   dev-rules-references/VERSION           stamp: commit, profile, date
#
# Other hosts (Cursor, Copilot, Aider, ...) take a plain copy of the files — see README › Install.
# Portable: bash + coreutils + diff + git (macOS, Linux, Git Bash on Windows).
set -u

repo=$(cd "$(dirname "$0")" && pwd)
target="${HOME:?HOME is not set}/.claude"
profile=""
mode="install"

while [ $# -gt 0 ]; do
  case "$1" in
    --profile) profile="${2:?--profile needs lean, portable or floor}"; shift 2 ;;
    --target)  target="${2:?--target needs a directory}"; shift 2 ;;
    --check)   mode="check"; shift ;;
    --update)  mode="update"; shift ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "unknown option: $1 (see --help)"; exit 2 ;;
  esac
done
case "$profile" in ""|lean|portable|floor) ;; *) echo "unknown profile: $profile (use lean, portable or floor)"; exit 2 ;; esac

rules_dir="$target/rules"
refs_dir="$target/dev-rules-references"
stamp_file="$refs_dir/VERSION"

stamped_profile() { [ -f "$stamp_file" ] && sed -n 's/.*profile=\([a-z]*\).*/\1/p' "$stamp_file" | head -n 1; }
effective_profile() {
  if [ -n "$profile" ]; then echo "$profile"; return; fi
  local s; s=$(stamped_profile)
  echo "${s:-lean}"
}
commit_id() { git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo "unknown"; }

# expected_pairs PROFILE — one "source|destination" line per file the profile installs
expected_pairs() {
  case "$1" in
    lean)
      echo "rules.md|$rules_dir/dev-rules.md"
      echo "references/safety.md|$refs_dir/safety.md"
      echo "references/operations.md|$refs_dir/operations.md"
      echo "references/portable-supplement.md|$refs_dir/portable-supplement.md" ;;
    portable)
      echo "rules.md|$rules_dir/dev-rules.md"
      echo "references/portable-supplement.md|$rules_dir/dev-rules-supplement.md"
      echo "references/safety.md|$refs_dir/safety.md"
      echo "references/operations.md|$refs_dir/operations.md" ;;
    floor)
      echo "floor.md|$rules_dir/dev-rules.md" ;;
  esac
}
# Files another profile would have left behind — removed on install so profiles never mix.
stale_paths() { echo "$rules_dir/dev-rules-supplement.md"; echo "$refs_dir/portable-supplement.md"; echo "$refs_dir/safety.md"; echo "$refs_dir/operations.md"; }

same_content() { # ignore CR/LF differences so a Windows checkout and a Unix install compare equal
  tr -d '\r' < "$1" > "$tmp/a"; tr -d '\r' < "$2" > "$tmp/b"; diff -q "$tmp/a" "$tmp/b" >/dev/null
}
tmp=$(mktemp -d); trap '[ -n "$tmp" ] && rm -rf "$tmp"' EXIT

do_install() {
  local p=$1 pair src dst n=0
  mkdir -p "$rules_dir" "$refs_dir"
  for pair in $(stale_paths); do
    if ! expected_pairs "$p" | grep -Fq "|$pair"; then rm -f "$pair"; fi
  done
  while IFS='|' read -r src dst; do
    cp "$repo/$src" "$dst"; n=$((n+1))
  done < <(expected_pairs "$p")
  printf 'dev-rules@%s profile=%s installed=%s\n' "$(commit_id)" "$p" "$(date -u +%Y-%m-%d)" > "$stamp_file"
  echo "Installed $n file(s) [$p profile] -> $target"
  echo "  always loaded:  $rules_dir/dev-rules.md$([ "$p" = portable ] && printf ' + dev-rules-supplement.md')"
  [ "$p" = floor ] || echo "  on demand:      $refs_dir/"
  echo "  stamp:          $stamp_file"
}

do_check() {
  local p=$1 pair src dst drift=0
  if [ ! -f "$stamp_file" ] && [ ! -f "$rules_dir/dev-rules.md" ]; then
    echo "Not installed under $target (no rules/dev-rules.md, no stamp)"; return 1
  fi
  echo "Installed: $(cat "$stamp_file" 2>/dev/null || echo 'no stamp') | Repo: dev-rules@$(commit_id) profile=$p"
  while IFS='|' read -r src dst; do
    if [ ! -f "$dst" ]; then echo "  MISSING  $dst"; drift=$((drift+1))
    elif ! same_content "$repo/$src" "$dst"; then echo "  DRIFT    $dst  (differs from $src)"; drift=$((drift+1))
    else echo "  ok       $dst"; fi
  done < <(expected_pairs "$p")
  for pair in $(stale_paths); do
    if [ -f "$pair" ] && ! expected_pairs "$p" | grep -Fq "|$pair"; then echo "  STALE    $pair  (not part of the $p profile)"; drift=$((drift+1)); fi
  done
  if [ "$drift" -eq 0 ]; then echo "Drift: none — the installed copy matches this checkout ($p profile)"; return 0; fi
  echo "Drift: $drift file(s) — run ./install.sh --profile $p to re-sync"; return 1
}

case "$mode" in
  install) do_install "$(effective_profile)" ;;
  check)   do_check "$(effective_profile)" ;;
  update)
    p=$(effective_profile)
    git -C "$repo" pull --ff-only || { echo "git pull --ff-only failed — resolve it in $repo, then re-run"; exit 1; }
    do_install "$p" ;;
esac
