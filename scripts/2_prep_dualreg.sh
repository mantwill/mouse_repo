#!/bin/bash


## Manuell: Dual Regression Matrix erstellen
#Glm

## dual_regression-FSL Befehlsskript ändern
 #EDIT HERE MANUELL austauschen in dual_regression_withregfilt!!!!!!!
  # RAND="$FSLDIR/bin/randomise -i $OUTPUT/dr_stage2_ic$jj -o $OUTPUT/dr_stage3_ic$jj -m /data/hippo/maron/Projects/BecauseY/MouseMouse/Nightmare/data/5_group_analysis.gica/groupmelodic.ica/stats/masks/bin_mask_comp_$jj $DESIGN -n $NPERM -T -V"
 #fi

# Store the current directory
CURRENT_DIR=$(pwd)

# create directories for DSURQ masks
mkdir stats; 
mkdir stats/masks; 

# copy DSURQ masks
cp misc_data/DSURQE_masks/* stats/masks/


# Directory containing the files
SOURCE_DIR="${CURRENT_DIR}/confoundscorrected/confound_correction_datasink/cleaned_timeseries"
# Directory where the file list should be saved
TARGET_DIR="${CURRENT_DIR}/dual_regression/design_files"
DUAL_REG_DIR="${TARGET_DIR}/output_withmask"

# Create the target directory if it doesn't exist
mkdir -p "${TARGET_DIR}"
mkdir -p "${DUAL_REG_DIR}"

# File name for the list
FILELIST="${TARGET_DIR}/filelist.txt"

# Find all .nii.gz files and add them to the list
find "${SOURCE_DIR}" -type f -name "*.nii.gz" > "${FILELIST}"


