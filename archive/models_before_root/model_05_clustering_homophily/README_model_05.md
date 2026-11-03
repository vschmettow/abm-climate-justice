# Model 05: clustering and homophily

File: model_05.R (1 Nov 2026). Working model.

## 1. What this model is

Model 04 plus two spatial parameters, both switched off at baseline.

196 countries, 14 x 14 grid, 20% rich (wealth 40) and 80% poor (wealth 10). No income. Wealth only goes down: by restraining, by damage, by a mechanism. One commons D, starting at today's excess CO2. 100 rounds, 2026 to 2126.

Each round:
1. Act. Play your strategy. Random restraint 0.01, a one-round act. Below c you must emit.
2. Commons. sink = s0 D / (1 + D / D_half). D += alpha n_emit − sink.
3. Pay. Restrainers pay c. Everyone loses dg D².
4. Mechanism slot. Pay and get. Changes payoff and D only.
5. Settle. At zero, eliminated.
6. Imitate. Compare your payoff with your four neighbours. A same-group neighbour's payoff counts in full. An other-group neighbour's advantage over you counts at weight w. Copy what the best did; fall back to your own strategy.
7. Record.

| Parameter | Value | Meaning | Source |
|---|---|---|---|
| p_A | 0.2 | share in group A | Vasconcelos 2014; World Bank |
| r_A, r_B | 40, 10 | starting wealth | Vasconcelos 2014 |
| h | 0 | clustering of the map: 0 random, 1 rich in one block | chosen; swept |
| w | 1 | weight on an other-group neighbour's advantage: 1 full, 0 ignore | chosen; swept |
| c | 0.1 | cost of restraining, same for all | chosen; swept |
| alpha | 0.05 | commons per emitter per year | mean Party emission, GCB 2025 |
| D0 | 267 | excess CO2 at start, 2025 | NOAA 425.6 ppm |
| s0 | 0.045 | sink rate at low D | fit to Raupach 2014, GCB 2025, AR6 |
| D_half | 200 | D at which the sink rate halves | same fit |
| dg | 2 x 10⁻⁶ | damage coefficient on D² | shape DICE-2023; value chosen; swept |
| p_init, p_rand | 0.5, 0.01 | mixed start, random restraint | lineage |
| T | 100 | rounds, one per year | horizon to 2100 |

Map construction: the rich are placed in a block, then a share 1 − h of all positions is shuffled. Countries do not move once the run starts.

## 2. What changed from the previous model

- h added. Starting map can be random (h = 0) or clustered (h = 1) or anything between.
- w added. Imitation can listen to all neighbours equally (w = 1) or to the own group only (w = 0) or anything between.
- Both at the lineage default in the base model: h = 0, w = 1. Baseline identical to model 04.

## 3. Why

The grid so far did one thing: decide whom you copy. Placement was random, so every country had a mix of rich and poor neighbours. In the real world rich border rich and poor border poor, and the UNFCCC blocs (EU, Umbrella Group, G77, AOSIS, LDCs) are exactly that. Countries also copy peers that look like them (Fankhauser et al. 2016). Vasconcelos et al. 2014 test this as homophily and find cooperation collapses when rich and poor only interact within their class.

Two dials capture this with no group counts or sizes to set. h is the map, w is the listening. Own-group-only learning is the w = 0 end of the sweep, not a separate rule. If agents compared with their whole group regardless of position, the grid would be decoration.

Why both stay off in the base: there is no sourced number for either. A realistic middle (say h = 0.7, w = 0.5) would be made up. The base model should be the plainest comparison point, and the sensitivity analysis shows what clustering does.

Rejected: a hard own-group-first rule (needs a fallback when all four neighbours are the other group, which happens to 40% of rich countries at h = 0); a cap of one random other-group neighbour (lumpy, only bites at borders); a Schelling sorting step to build the map (three hidden parameters; Schelling 1971 is cited for why clustering exists, the block-and-shuffle builds it).

Structural note: in the base model all emitters earn the same payoff and restraining costs the same for both groups. A poor country copying a rich neighbour can only copy emitting. Cross-group copying spreads emitting, not restraint, until a mechanism changes payoffs.

## 4. Baseline result

Ten seeds, identical to model 04. Poor out at round 41. Rich never eliminated. h and w have no effect in the baseline because everyone emits.

First look with a mechanism (flat fee 0.3 on emitters, revenue to the poor, one seed): the poor survive to round 100 or beyond when the rich example is kept away from them, by distance (h = 1, w = 1) or by deafness (h = 0, w = 0), and die by 86 to 100 otherwise. h and w interact. This is what E5 is for.

## 5. Known limitations and open points

- h and w have no sourced values. Swept 0 to 1 in E5.
- Rich never collapse inside T. Open.
- Removal as a mechanism and the returned-share f not yet implemented.

## 6. Files

model_05.R, this README. Notebook section 8 (1 Nov) has the full reasoning.
