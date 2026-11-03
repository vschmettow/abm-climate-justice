# Model 00: bare

## 1. What it is

The absolute simplest version. 
Two groups that do not differ in anything. 
--> Everyone starts with the same wealth, everyone emits, No sink (yet).
| Parameter | Value | Meaning |
|---|---|---|
| nd | 14 | grid side, 196 agents, edges wrap |
| T | 100 | years, 2026 to 2126 |
| groups | 50 / 50 | random places, identical in every way |
| r0 | 10 | start wealth, same for all |
| c | 0.1 | cost of restraining per year (in the code, never used yet) |
| alpha | 0.05 | emission per emitter per year |
| D0 | 267 | excess CO2 in 2025 |
| dg | 2e-6 | damage dg · D² per agent per year |

Each year: everyone emits, D grows by alpha per emitter, everyone pays dg · D², agents at zero wealth are out. The copying rule (best of self and 4 neighbours) is in the code but has nothing to copy, since everyone does the same.


## 2. Result

D grows in a straight line from 267. Damage grows with D², so wealth falls faster and faster. All 196 agents go out in year 29, D is then about 550. Everything equal, as intended.

