# SPPS Algorithm Overview

## Problem Statement

Given a rooted ordered tree T with n nodes, produce a compact, reversible
encoding that:
- Runs in **O(n)** time and space
- Uniquely identifies the tree (bijection)
- Preserves child ordering (ordered tree)
- Supports efficient reconstruction (O(n) decode)

## Approach: Signed Positional Prüfer Sequences

SPPS extends the classical Prüfer sequence with two additions:

### 1. Positional Child Rank (k)
Encodes the index of each leaf among its parent's ordered children.
This preserves sibling order — lost in the classical Prüfer encoding.

### 2. Direction Flag (d ∈ {+1, −1})
Distinguishes the direction of the virtual edge connecting the root
to an augmented virtual node v_virt. This resolves root ambiguity.

### Encoding Formula

For each step i of the Prüfer peeling process:
```
ω_i = d_i × (P_i × N + k_i)
```
where:
- `leaf`  = current minimum-degree leaf
- `P`     = parent of leaf (= neighborSum[leaf] for degree-1 nodes)
- `k`     = ChildRank[leaf] (0-indexed position among P's children)
- `d`     = direction flag (+1 for child→parent, −1 for parent→child)
- `N`     = n + 2 (augmented tree size)

The final sequence S has length n−2 (last element dropped).

## Decode

1. Recover degree sequence D from S (count P_i occurrences)
2. Reconstruct spatial child map M[] using BasePointer[] offsets
3. Identify root: the non-virtual degree-1 node after peeling

Time complexity: O(n) — two linear passes over S.

## Key Properties

| Property | Value |
|---|---|
| Sequence length | n − 2 |
| Encoding space | 8 bytes/node (int64 × (n−2)) |
| Encode time | ~7–18 ns/node (Apple M1) |
| Decode time | ~5–17 ns/node (Apple M1) |
| Correctness | Bijection — proven by Prüfer theory extension |
