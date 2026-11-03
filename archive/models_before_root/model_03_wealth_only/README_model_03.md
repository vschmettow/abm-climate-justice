# Model 03: wealth only

File: model_03.R (was commons_v4.R, 18 Oct, patched and renamed base_model_v0.R, 19 Oct 2026)

## 1. What this model is

196 countries, 14 x 14 grid, 20% rich (wealth 40) and 80% poor (wealth 10). No income. Wealth only goes down: by restraining, by damage, by a mechanism. One commons D, starting at 0. 100 rounds, one per year.

Each round:
1. Act. Play your strategy. Random restraint 0.01, a one-round act. Below c you must emit.
2. Commons. D += alpha n_emit − s D − beta max(0, n_restrain − sigma N).
3. Pay. Restrainers pay c. Everyone loses dg D².
4. Mechanism slot. Pay and get. Changes payoff and D only.
5. Settle. At zero, eliminated.
6. Imitate. Copy what the best paid of self and four neighbours did. Fall back to your own strategy.
7. Record.

| Parameter | Value | Meaning | Source |
|---|---|---|---|
| p_A | 0.2 | share in group A | Vasconcelos 2014 |
| r_A, r_B | 40, 10 | starting wealth | Vasconcelos 2014 |
| c | 0.1 | cost of restraining, same for all | chosen |
| alpha | 0.05 | commons per emitter | mean Party emission |
| s | 0.005 | sink share of D per year | chosen, low for saturation |
| beta, sigma | 0.01, 0.5 | restrainer drawdown above the balance point | carried from model 01 |
| dg | 2 x 10⁻⁶ | damage coefficient on D² | shape DICE-2023; value chosen |
| T | 100 | rounds | horizon to 2100 |

## 2. What changed from the previous model

- Income removed. No b0, gamma, a. Wealth only falls.
- Restraining has a fixed cost c instead of an income loss.
- Damage dg D → dg D². Convex.
- Sink s 0.02 → 0.005.
- Random restraint made a one-round act: strategy and action separated, so an isolated agent cannot get stuck restraining.
- D_crit redefined as sqrt(c / dg): where yearly damage equals the cost of restraining.

## 3. Why

Model 02 produced no tragedy. Income grew without bound and damage never caught up. Dropping income is the simplest fix: it removes three parameters and makes the commons the only thing agents lose to.

- Fixed cost of restraining: the clean alternative costs the same whoever buys it, so it takes 1% of a poor country's wealth per year and 0.25% of a rich one's. That is H1's incidence built in.
- Convex damage: DICE-2023 uses a quadratic damage function (Barrage and Nordhaus 2024). Small D hurts nothing, large D hurts a lot.
- Low sink: real sinks saturate (IPCC AR6 WG1 B.4.1), so the long-run effective rate is below today's 2%. No source for 0.005; replaced in model 04.
- The one-round random restraint fixes a bug: after the poor died, isolated rich agents who drew a random restraint had no neighbour to copy and stayed restraining forever.

## 4. Baseline result

Ten seeds, identical. Poor out at round 59. Rich out at 125 to 126. Restraint zero apart from the 1% random draw. D crosses D_crit at round 28, peaks at 2.2 D_crit when the poor die, then drifts down. Once the poor are gone, commons growth slows; the rich survive longer because the poor died.

## 5. Known limitations and open points

- With no income, a transfer can only delay collapse, never reverse it. Fine over 100 years; a limitation over longer runs.
- dg size has no source; set so collapse lands inside T.
- s = 0.005 has no source.
- Rich collapse at 125, outside T = 100.

## 6. Files

model_03.R, this README. baseline_v4.png in the archive is the figure for this model.
