# experiments/

This directory contains the complete SPPS experimental code, datasets, and outputs.

## Quick Start

```bash
# 1. Generate protobuf/flatbuffers headers
protoc --cpp_out=. tree.proto
flatc --cpp tree.fbs

# 2. Build all blocks
make -f Makefile all

# 3. Verify datasets are present
bash ../scripts/verify_datasets.sh

# 4. Run a single block
./block_a_correctness
./block_d_louds
```

## File Index

| File | Role |
|---|---|
| `block_a_correctness.cpp` | Correctness proofs (fuzzing) |
| `block_b_linearity.cpp` | O(n) linearity verification |
| `block_c_benchmarks.cpp` | Multi-dataset benchmark |
| `block_d_louds.cpp` | LOUDS baseline head-to-head |
| `block_e_compression.cpp` | zstd compression analysis |
| `block_f_tail_latency.cpp` | Tail latency / CV% |
| `block_g_downstream.cpp` | End-to-end pipeline benchmark |
| `block_h_worked_examples.cpp` | Step-by-step encode/decode traces |
| `profiler.cpp` | Memory + PMU profiling harness |
| `tree.proto` | Protobuf schema |
| `tree.fbs` | FlatBuffers schema |
| `Makefile` | Build system |

## Datasets

See `../docs/dataset_description.md` for full details.
Run `../scripts/verify_datasets.sh` to confirm all files are present.
