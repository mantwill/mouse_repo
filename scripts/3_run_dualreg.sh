#!/bin/bash

## dann Dual Regression Befehl ausführen

# manueller befehl
bash scripts/dual_regression_withregfilt_DSURQE DSURQE_100micron_DRICA_resampled 1 dual_regression/design_files/dual_regression.mat dual_regression/design_files/dual_regression.con 5000 dual_regression/output_withmask `cat dual_regression/design_files/filelist.txt`
