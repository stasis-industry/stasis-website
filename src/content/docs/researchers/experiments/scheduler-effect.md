---
title: Scheduler Effect (Supplementary)
description: "Closest-first vs random task assignment: throughput lift and Fault Tolerance delta per solver. Closest-first is a free lift for PIBT and Token Passing, partially offset on RHCR-PBS."
---

Closest-first scheduling versus random task assignment. The paper
keeps the headline (closest-first lifts throughput on every solver,
with a small FT penalty on RHCR-PBS at high density). The full table
and per-fault breakdown live here.

## Summary table

Throughput lift and Fault Tolerance delta at SD-w1, n=40, averaged
across all six fault scenarios and 30 seeds.

| Solver | Throughput lift | FT delta |
|--------|----------------|----------|
| PIBT | +12.1% | +0.018 |
| RHCR-PBS | +8.8% | -0.072 |
| Token Passing | +10.3% | +0.025 |

**Throughput lift** is closest-first divided by random, minus one,
expressed as a percentage. **FT delta** is closest-first FT minus
random FT, averaged across the six fault scenarios.

## What this means

- **Closest-first lifts throughput on every solver, by 9 to 12
  percent.** Mechanism: pickup-delivery distance is shorter on
  average, so the per-task cost in ticks is lower.
- **PIBT and Token Passing show small *positive* FT deltas.** The
  throughput lift is essentially free. Resilience moves with
  throughput on these architectures.
- **RHCR-PBS pays an FT penalty of about 0.07 on average.** The
  penalty climbs to 0.35 on dense permanent-fault cells. The windowed
  planner's optimality search is more sensitive to clustered task
  locations than the other two architectures, which makes
  closest-first a trade-off rather than a free lift.

## Operational takeaway

For PIBT or Token Passing deployments, closest-first is the default
choice. For RHCR-PBS, the choice depends on how much resilience
margin you have at the expected fleet density. At lower densities the
penalty disappears. At saturating density the penalty matters.

## Methodology

- 6 fault scenarios × 3 solvers × 2 schedulers × 30 seeds = 1,080
  paired runs (E2 in the paper)
- SD-w1 topology, n=40 agents
- Paired same-seed baseline for each scheduler condition
- Throughput is per-tick task completion rate, averaged across the
  500-tick run
- FT = average post-fault throughput divided by average baseline
  throughput

Source data: `results/scheduler_effect_experiment_summary.csv`
in the [MAFIS repository](https://github.com/stasis-industries/mafis).
