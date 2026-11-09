# Model 04: choice

## 1. What it is

Model 03 plus the other option. Agents start as emitter or restrainer by coin flip, and once in a while an agent restrains for one year by accident. From here on the copying rule has two things to compare, and the model is a game.

| Parameter | Value | Meaning |
|---|---|---|
| p_init | 0.5 | share that starts as restrainer |
| p_rand | 0.01 | chance per agent and year to restrain once by accident |
| c | 0.1 | cost of restraining per year (was in the code since 00, used for the first time) |

Restrain: pay c, add nothing to D. Emit: free, add alpha. Everyone pays dg · D² either way. Each year every agent copies the action of whoever did best among itself and its four neighbours. p_init = 0 and p_rand = 0 give model 03 back.

## 2. What changed

Two parameters, one line in the setup loop (coin flip for the start strategy), one line in the act step (random one-year restraint). One more plot panel for the share restraining.

## 3. Why

Imitation can only spread an action that somebody is already doing. With no restrainer anywhere, the rule had nothing to do in models 00 to 03. The random start puts both actions on the grid; the random one-year restraint keeps the option alive later, so a mechanism that makes restraining pay can still catch on even after restraining has died out. Strategy and action are kept apart (strat vs grid), so an accidental restraint is a one-year act, not a change of mind.

## 4. Baseline result

Half the agents restrain in year 1, 3% in year 2, almost none from year 3. Emitting is always the better copy: a restrainer pays c on top of the same damage, so every restrainer sees an emitting neighbour do better and switches. The tragedy appears on its own. Poor out between years 14 and 36, rich between 37 and about 95, as in model 03. D grows the same way.

## 5. Limitations

No sink, no income, no mechanism. Restraining has a cost and no benefit yet, so nobody keeps doing it. That is the state a mechanism has to change.

## 6. Files

model_04.R, README_model_04.md
