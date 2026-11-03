# Model 04: saturating sink

File: model_04.R (was base_model_v2.R, 22 Oct 2026). Working model.

## 1. What this model is

196 countries, 14 x 14 grid, 20% rich (wealth 40) and 80% poor (wealth 10). No income. Wealth only goes down: by restraining, by damage, by a mechanism. One commons D, starting at today's excess CO2. 100 rounds, 2026 to 2126.

Each round:
1. Act. Play your strategy. Random restraint 0.01, a one-round act. Below c you must emit.
2. Commons. sink = s0 D / (1 + D / D_half). D += alpha n_emit − sink.
3. Pay. Restrainers pay c. Everyone loses dg D².
4. Mechanism slot. Pay and get. Changes payoff and D only.
5. Settle. At zero, eliminated.
6. Imitate. Copy what the best paid of self and four neighbours did. Fall back to your own strategy.
7. Record.

| Parameter | Value | Meaning | Source |
|---|---|---|---|
| p_A | 0.2 | share in group A | Vasconcelos 2014; World Bank |
| r_A, r_B | 40, 10 | starting wealth | Vasconcelos 2014 |
| c | 0.1 | cost of restraining, same for all | chosen; swept |
| alpha | 0.05 | commons per emitter per year | mean Party emission, GCB 2025; unit scaling chosen |
| D0 | 267 | excess CO2 at start, 2025 | NOAA 425.6 ppm, 1,149 GtCO2 |
| s0 | 0.045 | sink rate at low D | fit to Raupach 2014, GCB 2025, AR6 |
| D_half | 200 | D at which the sink rate halves | same fit |
| dg | 2 x 10⁻⁶ | damage coefficient on D² | shape DICE-2023; value chosen; swept |
| p_init, p_rand | 0.5, 0.01 | mixed start, random restraint | lineage |
| T | 100 | rounds, one per year | horizon to 2100 |

Reference lines: D_half = 200 (sink at half strength), D_crit = sqrt(c / dg) = 224 (yearly damage equals the cost of restraining). The run starts above both.

## 2. What changed from the previous model

- Sink s D with s = 0.005 → s0 D / (1 + D / D_half). Proportional at low D, saturating at high D, recovering as D falls. Ceiling s0 D_half = 9 units a year.
- D0 0 → 267.
- Restrainers no longer remove from D. beta and sigma gone. Restrain = stop emitting, pay c, add nothing.
- Carbon removal moved from the base action to the mechanism slot (restoration, D −= kappa sum(pay)), with the share of a removal that the sinks return (f, 0 to 0.77) as a swept efficiency.
- Vocabulary: emit and restrain.

An intermediate step (base_model_v1, 19 Oct, each restrainer removing alpha) is in the archive. It was dropped the same week; see section 3.

## 3. Why

- Sink from data. A second literature search (50 verified sources, claude/sink-report.md) found: sinks take half of annual emissions today; the rate per unit of excess has fallen by a third since 1959 (Raupach et al. 2014); the ocean buffer stiffens (Revelle factor) and the land sink loses carbon to warming (IPCC AR6 WG1 B.4.1); the sinks still take about a third of emissions in 2100 under high emissions. The form is a fit to five sourced points, giving today's 2% at D = 267. Nobody publishes the sink in this form; stated as a fit. The sink has to saturate and be able to recover (decided 20 Oct).
- Start at today's atmosphere. The run is 2026 to 2126; a clean atmosphere at the start was wrong.
- Restrain, not remove. Half the population removing to reach planetary net zero is a different kind of net zero from every country reaching zero itself, which is what the Paris Agreement and national laws target. Real removal is 2 GtCO2 a year worldwide; one removing country in the old form did 20 times that. Removal belongs in the mechanism layer.
- dg unchanged: the stronger sink and the higher D0 roughly cancel.

Limitation stated: the sink acts on the stock at a single saturating rate. The multi-timescale response and the memory of past uptake (Joos et al. 2013; Zickfeld et al. 2021; AR6 Figure 5.32) are not represented.

## 4. Baseline result

Ten seeds, identical. Poor out at round 41. Rich never eliminated. D rises from 267 to 426 at round 41, then falls as 157 emitters are gone and the sink recovers, toward a steady state near 46 where the sink matches the 39 remaining emitters. Damage fades. The rich survive because the poor collapsed. Rich are eliminated only at dg = 8 x 10⁻⁶, with the poor gone by round 15.

## 5. Known limitations and open points

- Rich never collapse inside T. Leave as the result, or raise dg? Open.
- The tipping point near half the population restraining is a coincidence of today's sink size, not a design choice.
- dg, c, D_half and the unit scaling of alpha are chosen. Ranges for the sensitivity analysis are in claude/thesis-methods-running.md section 3.

## 6. Files

model_04.R, this README. sink_curve.png (sink rate and flux against D). Sink report and sources in the project.
