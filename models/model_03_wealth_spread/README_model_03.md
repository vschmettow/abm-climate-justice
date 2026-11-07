# Model 03: wealth spread

## 1. What it is

Model 02 plus one dial, sigma: how much wealth scatters inside a group. Each agent gets its group's level (rA or rB) times a random factor. Everything else is the same: k = 4, pA = 0.2, everyone emits, no sink.

| Parameter | Value | Meaning |
|---|---|---|
| sigma | 0.3 | spread within a group. 0 = everyone in a group identical, as in model 02 |

The factor is exp(rnorm(0, sigma) − sigma²/2), a lognormal with mean 1, so the group mean stays at rA or rB and the overall mean at r0. With sigma = 0.3 the rich run from about 13 to 47, the poor from about 3 to 13. The two groups now overlap: the richest poor agent has more than the poorest rich agent.

## 2. What changed

One parameter sigma and one line in the setup loop that multiplies each agent's start wealth by the random factor. The spread is drawn once at the start; nothing in the yearly loop changes.

## 3. Why

Until now everyone in a group was identical, so a group always died in one step and any later mechanism would flip a whole group at once. A spread makes agents differ one by one. Lognormal because wealth is skewed in reality (many near the middle, a long tail upward) and because it can never go negative. Group identity and wealth level are now two different things, which later lets mechanisms target by group or by wealth.

## 4. Baseline result

Collapse becomes a stretch instead of a step. Poor: first agent out in year 14, last in year 36. Rich: first out in year 37, last in year 93. In model 02 the whole poor group went in year 22 and the whole rich group in year 57. The curves in the "groups" panel now slope instead of dropping.

## 5. Limitations

No sink, no income, no mechanism, no choice. The spread is set once; wealth differences only come from the start, not from anything agents do.

## 6. Files

model_03.R, README_model_03.md
