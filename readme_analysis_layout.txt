### setup and preprocessing:
we mkdir consistent file structure.

we then transform all brkraw files into niftis using brkraw tools (see 1_setup_preprocessing.txt)

this is done mostly manually (copying commands from txt to bash). Could be semi-automated.

we run preprocessing using the rabies toolbox. 
preprocessing consists of preprocessing command / confound correction command / qc command and is supposed to be performed iteratively. 
commands are to be found 1_setup_preprocessing.txt



### dual regression
next we perform dual regression
what we need:
- design matrix for glm (manually setup using FSL, has to be saved into dual_regression/design_files/)
- created DSURQ masks (done by 2_prep_dualreg.sh)
- create the file list (done by 2_prep_dualreg.sh)

we thus run 2_prep_dualreg.sh, create all design files depending on the created filelist in dual_regression/design_files, 
and then can run 3_run_dualreg.sh.

Once this is done we can run 4_prep_results_dualreg.sh



### visualization
once all of this is complete, we can start working on the visualization, which can be mostly found inside the scripts/visualization folder.
what need:
- the sliced images for the 18 (17 used) DSURQ components (to be found in misc_data/DSURQ_images.sum)

Here we can show the significant voxels / clusters in the different components (assuming there are some). All data should already be there.
If everything is good, we can simply run: 1_significant_dualreg_results.sh



### fslnets analysis
I think we should be able to now simply run: 2_fslnets_analysis.m in MATLAB