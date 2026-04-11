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

## Pseudocode

### Encode (Algorithm 1)

```
Input:  rooted ordered tree T, root r, n nodes
Output: sequence S of length n-2

1.  Augment T: add virtual node v_virt = n+1, edge r—v_virt
2.  Compute ChildRank[], parent[], neighborSum[], D[] in O(n)
3.  ptr ← first node in [1..n+1] with D[ptr] = 1
4.  leaf ← ptr
5.  for i = 1 to n:
6.    if D[leaf] = 0: break
7.    P ← neighborSum[leaf]
8.    d ← (parent[leaf]=P) ? +1 : ((parent[P]=leaf) ? -1 : +1)
9.    k ← ChildRank[leaf]
10.   S.append(d × (P × N + k))
11.   D[P] -= 1;  neighborSum[P] -= leaf
12.   if D[P]=1 and P < ptr: leaf ← P
13.   else: advance ptr to next D[ptr]=1; leaf ← ptr
14. S.pop_back()   // drop last entry (encodes root implicitly)
15. return S
```

### Decode (Algorithm 2)

```
Input:  sequence S, n
Output: children[] adjacency, root

1.  D_dec[v] ← 1 for all v              // start with degree 1
2.  for ω in S: D_dec[|ω|/N] += 1       // recover out-degrees
3.  Build BasePointer[] (prefix sum of out-degrees)
4.  Init M[0..sum_degrees] ← 0
5.  ptr ← first v with D_dec[v] = 1; leaf ← ptr
6.  for ω in S:
7.    P ← |ω| / N;  k ← |ω| % N
8.    M[BasePointer[P] + k] ← leaf
9.    D_dec[P] -= 1
10.   advance leaf similarly to encode
11. root ← degree-1 node ≠ v_virt
12. return children[] from M[], root
```

## Complexity Analysis

| Operation | Time | Space |
|---|---|---|
| Encode | O(n) | O(n) |
| Decode | O(n) | O(n) |
| DFS traversal | O(n) | O(depth) |
| **Total roundtrip** | **O(n)** | **O(n)** |

All four auxiliary arrays (D, parent, neighborSum, ChildRank) are computed
in a single O(n) pass over the children adjacency list. The peeling loop
runs exactly n−1 iterations, each in amortized O(1).
