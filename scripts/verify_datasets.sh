#!/usr/bin/env bash
# verify_datasets.sh — Check that all required dataset files are present
# and have the correct node counts

set -euo pipefail

EXPDIR="$(dirname "$0")/../experiments"
OK=0
FAIL=0

check() {
  local file="$EXPDIR/$1"
  local expected_n="$2"
  local label="$3"

  if [ ! -f "$file" ]; then
    echo "  MISSING: $1"
    FAIL=$((FAIL+1))
    return
  fi

  local actual_n
  actual_n=$(head -1 "$file" | tr -d '[:space:]')
  if [ "$actual_n" = "$expected_n" ]; then
    echo "  OK:      $label (n=$actual_n)"
    OK=$((OK+1))
  else
    echo "  MISMATCH: $label — expected n=$expected_n, got n=$actual_n"
    FAIL=$((FAIL+1))
  fi
}

echo "=== Dataset Verification ==="
check "real_ast_benchmark copy.txt" "2325575" "Django AST"
check "sqlite3_ast_edges.txt"       "503141"  "sqlite3 AST"
check "xmark_edges.txt"             "500000"  "XMark XML"
echo ""
echo "Result: $OK OK, $FAIL FAILED"
[ "$FAIL" -eq 0 ] && echo "All datasets verified." || exit 1
