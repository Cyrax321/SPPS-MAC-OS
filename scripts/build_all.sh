#!/usr/bin/env bash
# build_all.sh — Build all SPPS experiment blocks
# Platform: macOS / Apple Silicon (arm64)
# Requires: protobuf, flatbuffers, zstd (via Homebrew)

set -euo pipefail

cd "$(dirname "$0")/../experiments"

CXX="clang++"
FLAGS="-std=c++17 -O3 -I. -I/opt/homebrew/include"
PBFLAGS="$(pkg-config --cflags --libs protobuf)"
LIBS="-lflatbuffers -lzstd"
PB_SRC="tree.pb.cc"

echo "=== SPPS Build Script ==="
echo "Compiler: $($CXX --version | head -1)"
echo ""

build() {
  echo -n "Building $1... "
  eval "$CXX $FLAGS $2 -o $1 $3"
  echo "done"
}

build block_a_correctness  ""                       "block_a_correctness.cpp"
build block_b_linearity    ""                       "block_b_linearity.cpp"
build block_c_benchmarks   "$PBFLAGS $LIBS"         "$PB_SRC block_c_benchmarks.cpp"
build block_d_louds        "$PBFLAGS $LIBS"         "$PB_SRC block_d_louds.cpp"
build block_e_compression  "$PBFLAGS $LIBS"         "$PB_SRC block_e_compression.cpp"
build block_f_tail_latency ""                       "block_f_tail_latency.cpp"
build block_g_downstream   "$PBFLAGS"               "$PB_SRC block_g_downstream.cpp"
build block_h_worked_examples ""                    "block_h_worked_examples.cpp"
build profiler             "$PBFLAGS $LIBS"         "$PB_SRC profiler.cpp"

echo ""
echo "=== All blocks built successfully ==="
