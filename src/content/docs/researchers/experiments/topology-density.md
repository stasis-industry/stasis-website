---
title: Topology and Density (Supplementary)
description: "Mean Attack Rate by topology and fleet density. Companion table to the main paper, showing layout as a second-order resilience lever beneath fault category and density."
---

This is the full Topology × Density table that was promised in the
paper as supplementary material. The headline takeaway: layout is a
second-order resilience lever. Density and fault category dominate.

## Mean Attack Rate by topology × density

Attack Rate is the cumulative fraction of the fleet ever materially
affected by any fault cascade across the 500-tick run. Lower is
better.

| Topology | Low density | Default | High density | Overall |
|----------|-------------|---------|--------------|---------|
| SD-w1 (Single-Dock, 57×33) | 0.57 (n=20) | 0.55 (n=40) | 0.49 (n=60) | 0.54 |
| DD (Dual-Dock, 61×33) | 0.56 (n=40) | 0.50 (n=80) | 0.44 (n=120) | 0.51 |

Both topologies show Attack Rate *decreasing* with density. More
agents in the warehouse means the same fault event touches a smaller
*fraction* of the fleet. The mechanism is denominator inflation, not
improved resilience per agent.

## What this means

- **Topology shifts Attack Rate by about 3 points overall.** Dual-Dock
  has a small advantage at matched density. Not enough to make
  topology choice a primary lever for fault response.
- **Fault scenario dominates.** Within each row, across-scenario
  spread is roughly 0.8, dwarfing the topology effect.
- **Density dominates the topology effect.** Going from low to high
  density on the same layout shifts Attack Rate by 8 to 12 points,
  several times more than swapping layouts at fixed density.

## Methodology

- 6 fault scenarios per cell (Burst-20%, Burst-50%, Wear-Medium,
  Wear-High, Zone-Outage 50t, Intermittent 80s80m15r)
- 3 solvers per cell (PIBT, RHCR-PBS, Token Passing)
- 30 seeds per (solver × scenario × density × topology) cell
- Token Passing excluded from n=120 cells per its completeness
  envelope of 100 agents
- Mean over all (solver × scenario × seed) within each density column

Source data: `results/warehouse_single_dock_experiment_summary.csv`
and `results/warehouse_dual_dock_experiment_summary.csv` in the
[MAFIS repository](https://github.com/stasis-industries/mafis).

## Why this is supplementary, not headline

A paper has a page budget. We kept the main findings (RQ1: solver
vulnerability profile, RQ2: paradoxical FT > 1 regime under RHCR-PBS)
in the printed text and moved second-order analyses here. The
framework is the same, the experiments are the same, the data is the
same. Only the page count is different.
