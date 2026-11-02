# Model 00: equal base

## 1. What it is

The simplest version. Two groups that do not differ in anything. Everyone starts with the same wealth, everyone emits the same, everyone pays the same to restrain. Mike asked for this as the root that every later model builds on, one change at a time.

| Parameter | Value | Meaning |
|---|---|---|
| nd | 14 | grid side, 196 agents, edges wrap |
| T | 100 | years, 2026 to 2126 |
| groups | 50 / 50 | random places, identical in every way |
| r0 | 10 | start wealth, same for all |
| c | 0.1 | cost of restraining per year |
| alpha | 0.05 | emission per emitter per year |
| s0, D_half | 0.045, 200 | saturating sink, s0 · D / (1 + D/D_half) |
| D0 | 267 | excess CO2 in 2025 |
| dg | 2e-6 | damage dg · D² per agent per year |

Each year: act (emit or restrain), commons updates (emissions in, sink out), everyone pays (damage, plus c if restraining), agents at zero wealth are out, everyone copies the best action among self and 4 neighbours.

## 2. What changed

Nothing to change from. This is the root. Compared to model 05 it drops: two wealth levels, 20/80 split, clustering h, copying weight w, mechanisms, the random start (p_init) and the random one-year restraint (p_rand). Everyone starts as an emitter, nothing random happens apart from the group placement.

## 3. Why

Mike: build the simplest base model ever, everything equal, then add one thing at a time so every effect has one cause. The two groups are kept in the code even though they are identical, so the next model only has to change their numbers, not the structure.

## 4. Baseline result

Nobody ever restrains. D rises from 267 to about 425. All 196 agents go out in year 41, in the same step, because every agent has exactly the same history. Everything equal, as intended. The copying rule is in the code but has nothing to copy yet.

## 5. Limitations

No income, no mechanism, no difference between groups. Not meant to say anything about the world yet. Only meant to show that the machinery runs and that two identical groups give identical results.

## 6. Files

model_00.R, README_model_00.md
