# Model 02: group share

## 1. What it is

Model 01 plus one dial, pA: the share of agents in group A (the rich). Everything else is the same: wealth gap k = 4, everyone emits, no sink, same damage for all.

| Parameter | Value | Meaning |
|---|---|---|
| r0 | 10 | mean start wealth, fixed |
| k | 4 | wealth ratio A to B, as in model 01 |
| pA | 0.2 | share of agents in A. 0.5 = half, as in model 01 |
| rB | r0 / (pA · k + 1 − pA) | start wealth of B |
| rA | k · rB | start wealth of A |

With pA = 0.2 and k = 4: 39 rich agents start at 25, 157 poor agents start at 6.25. Mean still 10. In model 01 the same k gave 16 and 4; with fewer rich agents each one holds more, because the total is fixed.

## 2. What changed

One parameter pA, the formula for rB (so the mean stays at r0 for any pA), and the group vector now has round(pA · N) zeros instead of N/2.

## 3. Why

How many are rich matters as much as how much richer they are. 20/80 is the real-world point (about 17.5% of UNFCCC Parties are high-income, World Bank), and it is the split used in the collective-risk literature (Vasconcelos et al. 2014). pA is a dial so it can be swept.

## 4. Baseline result

B out in year 22, A out in year 57. Compared to model 01 (17 and 41): the poor last a bit longer because each poor agent starts with more (6.25 instead of 4), the rich last much longer because each rich agent starts with 25 instead of 16. D reaches the same 550 in both, since everyone emits until they are out.

## 5. Limitations

No sink, no income, no mechanism, no choice. Still two sharp wealth levels, no spread inside a group.

## 6. Files

model_02.R, README_model_02.md
