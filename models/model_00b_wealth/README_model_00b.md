# Model 00b: wealth gap

## 1. What it is

Model 00a plus one dial, k. Group A starts with k times the wealth of group B. Everything else is the same: everyone emits, no sink, same damage for all.

| Parameter | Value | Meaning |
|---|---|---|
| r0 | 10 | mean start wealth, fixed |
| k | 4 | wealth ratio A to B. 1 = equal, higher = more unequal |
| rB | 2 · r0 / (1 + k) | start wealth of B |
| rA | k · rB | start wealth of A |

The mean stays at r0 whatever k is, so turning k only moves wealth from B to A, it does not add or remove any. With k = 4: A starts at 16, B at 4.

## 2. What changed

Three lines at the top (k, rA, rB), one line in the setup loop that gives each agent its group's wealth. One new plot panel for the grid, one for mean wealth per group.

## 3. Why

The first thing the two groups differ in. A single number makes the gap easy to sweep later. The ratio form was chosen because it is how the gap is usually described (the rich have k times as much) and because k = 1 gives model 00a back exactly.

## 4. Baseline result

Damage is the same for everyone, so the poor group simply runs out first. With k = 4, B is out in year 17, A in year 41. Larger k: B earlier, A later. D reaches the same 550 regardless, because everyone emits until they are out and total wealth is the same.

| k | B out | A out |
|---|---|---|
| 1 | 29 | 29 |
| 2 | 23 | 35 |
| 4 | 17 | 41 |
| 8 | 11 | 47 |

## 5. Limitations

No sink, no income, no mechanism, no choice. The gap only shifts who dies when. Nothing the agents do depends on it yet.

## 6. Files

model_00b.R, README_model_00b.md
