# Model 02: literature values

File: model_02.R (was commons_v3.R, 18 Oct 2026)

## 1. What this model is

Same structure as model 01: 196 agents, 14 x 14 grid, two groups, one commons, mechanism slot, copy the best neighbour. Changes to the numbers and three formulas, listed in section 2.

Each round:
1. Act. Play your strategy. Random restraint 0.01. Below C you must emit.
2. Earn. Income = b0 wealth^gamma. Emitting earns the full amount, restraining earns a of it.
3. Commons. D += alpha n_emit − s D − beta max(0, n_restrain − sigma N). Proportional sink.
4. Damage. Everyone loses dg D.
5. Mechanism slot.
6. Settle. At zero, eliminated.
7. Imitate.
8. Record.

| Parameter | Value | Meaning | Source |
|---|---|---|---|
| p_A | 0.2 | share in group A | Vasconcelos 2014; World Bank |
| r_A, r_B | 40, 10 | starting wealth, ratio 4 | Vasconcelos 2014 |
| b0, gamma | 0.125, 0.3 | income = b0 wealth^gamma | Cobb-Douglas, DICE-2023 |
| a | 0.9 | restraining income share | IPCC AR6 WG3: 1 to 4% of GDP |
| C | 8 | restraint threshold | chosen |
| alpha | 0.05 | commons per emitter | mean Party emission, GCB 2025 |
| s | 0.02 | sink share of D per year | 21 GtCO2 / 1000 GtCO2 excess |
| dg | 0.0001 | damage per unit of D | 1 to 10% income loss at 2 C |
| T | 100 | rounds, one per year | horizon to 2100 |

## 2. What changed from the previous model

- Agent defined: one country, a UNFCCC Party, one vote each (Rule 41).
- Groups 50/50, ratio 2 → 20/80, ratio 4.
- Income share b0 h2 / (wealth + h2) → b0 wealth^0.3. h2 dropped.
- a 0.4 → 0.9.
- dg 0.001 → 0.0001.
- Sink fixed (sigma N alpha) → proportional (s D), s = 0.02.
- T 1000 → 100.
- Vocabulary: emit, not extract.

## 3. Why

The model had to become less abstract, with numbers that can be justified. A literature search (180 verified sources, claude/grounding-report.md) gave each parameter a source or marked it as a free choice.

- Country as agent: UNFCCC one Party one vote (Vihma 2015, Kemp 2016); two wealth classes as in Vasconcelos et al. 2014.
- a = 0.9: decarbonisation costs 1 to 4% of GDP (IPCC AR6 WG3 C.12.2). The old 0.4 implied a 60% income loss.
- dg = 0.0001: literature gives 1 to 10% income loss at 2 C (Barrage and Nordhaus 2024; Kalkuhl and Wenz 2020). The old value gave 25 to 43%.
- Proportional sink: sinks respond to the concentration anomaly, not a fixed flux (IPCC AR6 WG1 B.4; MacDougall et al. 2020).
- T = 100: no published projection extends past 2100.
- Power-law income: Cobb-Douglas capital share, the saturating form had no referent.

## 4. Baseline result

No collapse. Everyone alive after 1000 rounds. D stops at 18% of critical. Wealth grows 30-fold. Two causes: a proportional sink caps D at alpha N / s, and income piles up with nothing pulling wealth down. Lowering s alone does not help; agents have saved too much by the time D passes critical.

## 5. Known limitations and open points

- The model does not produce the tragedy at literature values. This is a finding, and the reason for model 03.

## 6. Files

model_02.R, this README. Grounding report and sources in the project (claude/grounding-report.md, claude/grounding-sources.md).
