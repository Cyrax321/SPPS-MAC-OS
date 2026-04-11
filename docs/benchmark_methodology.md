# Benchmark Methodology

## Timing Protocol

All wall-clock measurements use `std::chrono::high_resolution_clock`:

```cpp
auto t0 = high_resolution_clock::now();
// ... operation ...
auto t1 = high_resolution_clock::now();
double ms = duration_cast<duration<double, milli>>(t1 - t0).count();
```

### Trial Structure

| Phase | Count | Purpose |
|---|---|---|
| Warmup | 2 trials | JIT / branch predictor warm-up |
| Timed | 30 trials | Statistical measurement |
| Reported | Mean of 30 | Primary result |

### Metrics Reported

- `Enc(ms)` — serialization (encode) time
- `Dec(ms)` — deserialization (decode) time
- `DFS(ms)` — depth-first traversal of decoded tree
- `Total(ms)` — Enc + Dec + DFS
- `Size(B)` — serialized payload size in bytes
- `B/node` — bytes per node

## Statistical Analysis

- **Mean** over 30 trials (primary)
- **CV%** (coefficient of variation = stddev/mean × 100) for stability
- **P50/P90/P95/P99** percentiles in Block F

Threshold: CV% ≤ 5% considered stable.

## Memory Measurement

Peak RSS via `/usr/bin/time -l` (macOS-specific):
```bash
/usr/bin/time -l ./profiler spps real_ast_benchmark.txt 2>&1
```
Field: `maximum resident set size` (bytes).

PMU hardware counters via `xctrace` (Instruments CPU Counters template):
- Instructions retired
- Cycles elapsed
- Derived IPC = Instructions / Cycles

## Compilation Flags

```bash
clang++ -std=c++17 -O3 -I. -I/opt/homebrew/include \
  $(pkg-config --cflags --libs protobuf) -lflatbuffers -lzstd
```

`-O3` enables auto-vectorization, loop unrolling, and inlining.
No profile-guided optimization (PGO) or link-time optimization (LTO) was used.

## Variance Interpretation

Observed CV% values across all datasets:

| Method | Encode CV% (mean) | Stability |
|---|---|---|
| SPPS | 2.26% | ✅ Stable |
| (all datasets < 3%) | | ✅ |

A CV% below 5% indicates that the measurement is not dominated by
system noise, OS scheduling jitter, or thermal throttling on the M1.
The M1's efficiency cores and unified memory architecture exhibit
exceptionally stable memory latency, contributing to low variance.
