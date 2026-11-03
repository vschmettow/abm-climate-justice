# abm-climate-justice

Agent-based modelling and game theory to explore whether distributive justice mechanisms, such as polluter-pays and needs-based transfers, can move unequal groups towards lasting climate cooperation, and where they break down.

Master's thesis, TUM and Oxford, 2026 to 2027.

## What is where

```
models/   one folder per model version
docs/     methods document, meeting notes, decisions
archive/  old files, not maintained. models_before_root/ holds models 01 to 05
```

Each model folder has `model_0N.R` and `README_model_0N.md`. The README says what the model is, what changed from the one before, why, what came out, and what it cannot do. Model 00 is the root, everything equal. Each later model adds one thing.

Experiment scripts (`run_*.R`) sit in the model folder they belong to and write their results as `.csv` and `.png` next to the script.

## Run

Open the .Rproj in RStudio, open a script, run the whole file.
