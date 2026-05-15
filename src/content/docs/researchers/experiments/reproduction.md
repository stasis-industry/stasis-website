---
title: Reproducing the Results
description: "Step-by-step pipeline to reproduce all paper numbers from the MAFIS source tree: type check, test suite, full experiment matrix, and analysis scripts."
---

Every number in the paper comes from a deterministic pipeline. This
page is the operational version of `REPRODUCIBILITY.md` in the
[MAFIS repository](https://github.com/stasis-industries/mafis).

## Requirements

- **Rust** 1.75 or newer (tested on 1.93.0)
- **Python** 3.8 or newer with `pandas`, `matplotlib`, `numpy`,
  `scipy`
- Roughly 4 GB of RAM for the full experiment matrix
- Roughly 2 GB of disk for compiled binaries and result CSVs

## Quick verification (about 3 minutes)

```bash
cargo check
cargo test
```

`cargo check` runs the type and borrow checker in about 5 seconds.
`cargo test` runs the full test suite (568 tests across core, solver,
fault, analysis, experiment, and integration suites) in about 3
minutes. Every test should pass with zero failures.

## Full experiment suite (about 7 hours on a laptop)

```bash
cargo test --release --test experiment_suite \
  full_experiment_suite -- --ignored --nocapture
```

This runs 4,320 paired faulted-and-baseline simulations across three
sub-experiments. `run_matrix` parallelises over N-1 rayon threads
(15 threads on the M4 Pro used for the paper data).

| Sub-experiment | Configuration | Runs |
|----------------|---------------|------|
| Warehouse Single-Dock | 3 solvers × 6 scenarios × 3 densities × 30 seeds | 1,620 |
| Warehouse Dual-Dock | 3 solvers × 6 scenarios × 3 densities × 30 seeds | 1,620 |
| Scheduler effect | 3 solvers × 6 scenarios × 2 schedulers × 30 seeds | 1,080 |

The runs write to `results/`:

| File | Contents |
|------|----------|
| `results/warehouse_single_dock_experiment_runs.csv` | Per-run metrics, Single-Dock |
| `results/warehouse_single_dock_experiment_summary.csv` | Aggregated stats |
| `results/warehouse_dual_dock_experiment_runs.csv` | Per-run metrics, Dual-Dock |
| `results/warehouse_dual_dock_experiment_summary.csv` | Aggregated stats |
| `results/scheduler_effect_experiment_runs.csv` | Per-run metrics, scheduler |
| `results/scheduler_effect_experiment_summary.csv` | Aggregated stats |
| `results/all_runs.csv` | Combined |

## Auxiliary aisle-width probe (about 1 hour)

```bash
cargo test --release --lib \
  run_rhcr_braess_observatory_proof -- --ignored --nocapture
```

About 600 paired runs across SD-w1 n=60, SD-w2 n=108, SD-w3 n=151.
Tests whether the FT > 1.2 cells observed under recoverable faults
arise from PBS node-budget saturation. The test is idempotent.
Completed matrices are skipped on resume.

Then run the analysis:

```bash
python3 scripts/analysis/rhcr_braess_observatory_proof.py
```

## Statistical analysis (about 1 second each)

All analysis scripts use pandas, matplotlib, numpy, and scipy.

| Script | Purpose |
|--------|---------|
| `structural_cascade_scaling.py` | Per-tier structural cascade regression vs walkable area |
| `mitigation_delta.py` | Mitigation Δ by solver and aisle width |
| `ft_baseline_audit.py` | Baseline validity flags, including FT > 1.2 cells |
| `delta_diff.py` | Pre/post-fix drift table |

Run each from the repo root:

```bash
python3 scripts/analysis/structural_cascade_scaling.py
python3 scripts/analysis/mitigation_delta.py
python3 scripts/analysis/ft_baseline_audit.py
```

Outputs land under `results/aisle_width/analysis/` as PNG figures and
JSON statistical summaries.

## Determinism

All simulations use a ChaCha8 generator seeded per configuration.
Paired runs (baseline and faulted) share the seed, so metric
differences are causally attributable to the fault condition rather
than between-run variance. Traces are bit-identical within a single
machine. Cross-machine traces may differ by one floating-point ULP
on parallel reductions. Run all seeds on one machine for strict
reproducibility.

## Solver fidelity

Each solver traces to a public reference implementation:

- PIBT to [pibt2](https://github.com/Kei18/pibt2)
- RHCR-PBS to [Jiaoyang-Li/RHCR](https://github.com/Jiaoyang-Li/RHCR)
- Token Passing to the original Ma et al. paper

The repository's `RELIABILITY.md` documents the per-solver fidelity
audit, deviations from reference implementations, and test coverage
gates that protect each port from drift.
