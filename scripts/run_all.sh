#!/usr/bin/env bash
# run_all.sh — Run all SPPS experiment blocks sequentially
# Outputs are saved to experiments/block_*_output_run.txt
# Prerequisite: run scripts/build_all.sh first

set -euo pipefail

EXPDIR="$(dirname "$0")/../experiments"
cd "$EXPDIR"

BLOCKS=(
  "block_a_correctness"
  "block_b_linearity"
  "block_c_benchmarks"
  "block_d_louds"
  "block_e_compression"
  "block_f_tail_latency"
  "block_g_downstream"
  "block_h_worked_examples"
)

echo "=== SPPS Full Experiment Run ==="
echo "Date: $(date)"
echo "Host: $(uname -a)"
echo ""

for block in "${BLOCKS[@]}"; do
  if [ -f "./$block" ]; then
    echo "--- Running $block ---"
    ./"$block" | tee "${block}_output_run.txt"
    echo ""
  else
    echo "WARNING: $block not found, skipping (run build_all.sh first)"
  fi
done

echo "=== All blocks complete. Outputs in experiments/*_output_run.txt ==="
