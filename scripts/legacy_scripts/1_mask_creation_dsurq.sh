#!/bin/bash
#Präprozessieren der LGI1-Daten


##################################################
#### download Bru2Nii from
#### https://github.com/neurolabusc/Bru2Nii/releases
#### open the linux folder
#### Open the GUI
#### load in the subject file 
#### use XP5.nii file (rsfmri) for further analysis
###################################################

Directory=$1

### mask approach

### gehe zu group_analysis_after_regfilt... gehe zu stats
mkdir stats; 
mkdir stats/masks; 

cp misc_data/DSURQE_masks/* stats/masks/

fslmaths DSURQE_100micron_DRICA_resampled.nii.gz -thr 3 stats/masks/mask_thresholded

## split melodic_IC in different spatial maps per component
cd stats/masks/

fslsplit mask_thresholded mask_comp_ -t


## binarize spatial maps of melodic_IC
for i in mask_comp_0*; do fslmaths $i -bin bin_$i; done

