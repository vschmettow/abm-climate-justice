# Model 01: income and fixed sink

File: model_01.R (was commons_v2.R, 16 Sept 2026)

## 1. What this model is

Two groups of agents on a 14 x 14 grid with periodic boundaries, 196 agents, four neighbours each. The grid is who you observe, not who you harm. Group A (rich) and group B (poor), 50/50, starting wealth 20 and 10. One shared commons D, starting at 0. 1000 rounds.

Each round:
1. Act. Play your strategy. With probability 0.01 restrain regardless. Below wealth C = 8 you must extract.
2. Earn. Income = share x wealth, share = b0 h2 / (wealth + h2). Extracting earns the full amount, restraining earns a = 0.4 of it.
3. Commons. D += alpha (n_extract − sigma N) − beta max(0, n_restrain − sigma N). A fixed sink of sigma N alpha per round; restrainers above the balance point remove beta each.
4. Damage. Everyone loses dg D.
5. Mechanism slot. Pay and get.
6. Settle. Wealth += payoff. At zero, eliminated permanently.
7. Imitate. Copy the strategy of the best paid of self and four neighbours.
8. Record.

| Parameter | Value | Meaning |
|---|---|---|
| N | 196 | agents |
| p_A | 0.5 | share in group A |
| r_A, r_B | 20, 10 | starting wealth |
| b0, h2 | 0.034, 50 | income scale, diminishing returns |
| a | 0.4 | restraining income as a share of extracting |
| C | 8 | wealth below which you cannot restrain |
| alpha | 0.05 | commons added per extractor |
| sigma | 0.5 | sink as a share of the population |
| beta | 0.01 | extra drawdown per restrainer above the balance point |
| dg | 0.001 | damage per unit of D |
| p_init, p_rand | 0.5, 0.01 | mixed start, random restraint |
| T | 1000 | rounds |

Outcome: cumulative well-being = average wealth over the run, eliminated agents count zero. Scored three ways: mean (utilitarian), group B mean (maximin), gap between groups (egalitarian).

## 2. What changed from the previous model

First model in this series. Earlier single-shot and vectorised versions (two_group_commons_v0, commons_v1) are in the archive.

## 3. Why

Built as the abstract base model for the research proposal (sent 16 Sept). Design rules: resource dynamics are enough; the base game is immutable and mechanisms sit on top at one slot. Coding style: 2D arrays, nested loops, no functions.

Key literature: Nowak and May 1992 (lattice, copy the best neighbour); Santos and Pacheco 2011 and Vasconcelos et al. 2014 (one base model, mechanisms swapped in); Schelling 1971 (local rules, emergent outcome).

## 4. Baseline result

Total collapse. Both groups eliminated by round 510. Restraint goes extinct within a few rounds. Criteria at baseline: 26.8 / 11.7 / 30.1.

## 5. Known limitations and open points

- Parameters chosen for plausibility, not sourced. Feedback on 15 Oct: too abstract, define the agent, ground the numbers.
- The sink removes a fixed amount even at zero emissions.
- T = 1000 has no calendar meaning.

## 6. Files

model_01.R, this README. Notebook sections 4 and 4b (claude/thesis-notebook.md) hold the full design history.
