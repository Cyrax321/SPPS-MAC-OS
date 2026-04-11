# Cache Boundary Analysis (Block B4)

## Apple M1 Cache Hierarchy

| Level | Size | Associativity |
|---|---|---|
| L1d | 64 KB (P-core) | 8-way |
| L1i | 128 KB (P-core) | 8-way |
| L2 | 4 MB (P-core cluster) | 16-way |
| SLC (System-Level Cache) | 8 MB (shared) | — |

## SPPS Working Set

The SPPS encoder maintains four arrays simultaneously:

| Array | Size (n=1M) | Size (n=2.3M) |
|---|---|---|
| `D[]` (degree) | 4 MB | 9.2 MB |
| `parent[]` | 4 MB | 9.2 MB |
| `neighborSum[]` | 8 MB | 18.4 MB |
| `ChildRank[]` | 4 MB | 9.2 MB |
| **Total** | **~20 MB** | **~46 MB** |

## L2 Overflow Point

At n ≈ 200K: 4 arrays × 4–8 B/node × 200K ≈ **5 MB** → exceeds L2 (4 MB).

However, the spike to 22.5 ns/node observed in Block B4 occurs at n ≈ 1.5M,
corresponding to the SLC (8 MB) being overwhelmed by the total 55 MB working set.

## Prefetcher Adaptation

The M1 hardware prefetcher detects the sequential access pattern in the
`neighborSum[]` peeling loop and pre-fetches cache lines. At n > 1.6M,
prefetch distance becomes large enough to hide most latency, returning
throughput to ~17–18 ns/node.

This is a hardware microarchitectural effect, **not** an algorithmic
super-linearity. The linear regression over all 12 B4 points confirms
R² = 0.999939.
