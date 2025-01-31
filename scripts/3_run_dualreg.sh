#!/bin/bash

## dann Dual Regression Befehl ausführen

# manueller befehl
#bash scripts/dual_regression_withregfilt_DSURQE misc_data/DSURQE_100micron_DRICA_resampled.nii.gz 1 dual_regression/design_files/dual_reg_B_vs_C.mat dual_regression/design_files/dual_reg_B_vs_C.con 5000 dual_regression/dual_reg_B_vs_C `cat dual_regression/design_files/filelist_BC.txt`

bash scripts/dual_regression_withregfilt_DSURQE misc_data/DSURQE_100micron_DRICA_resampled.nii.gz 1 dual_regression/design_files/dual_reg_A_vs_B.mat dual_regression/design_files/dual_reg_A_vs_B.con 5000 dual_regression/dual_reg_A_vs_B `cat dual_regression/design_files/filelist_AB.txt`
