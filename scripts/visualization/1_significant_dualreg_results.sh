# Full path of dual regression head directories
analysis_path=$(pwd)
dual_reg_path="${analysis_path}/dual_regression/output_withmask"
pval_cutoff=0.95  # Set p-value cutoff for significance


# Define paths
source_path="$analysis_path/preprocessed/bold_datasink/commonspace_labels"
destination_path="$analysis_path/preprocessed"

# Find the first folder inside the source path
first_folder=$(find "$source_path" -mindepth 1 -maxdepth 1 -type d | head -n 1)

# Check if the folder exists
if [ -z "$first_folder" ]; then
  echo "No folder found in $source_path."
  exit 1
fi

# Find the first NIfTI file within the first folder (and subfolders)
nifti_file=$(find "$first_folder" -type f -name "*.nii" | head -n 1)

# Check if a NIfTI file was found
if [ -z "$nifti_file" ]; then
  echo "No NIfTI file found in $first_folder."
  exit 1
fi

# Copy the file and rename it
cp "$nifti_file" "$destination_path/commonspace_labels_file.nii"

# Notify success
if [ $? -eq 0 ]; then
  echo "NIfTI file successfully copied and renamed to $destination_path/commonspace_labels_file.nii."
else
  echo "Failed to copy the NIfTI file."
  exit 1
fi


# Change directory to the dual regression path
cd "${dual_reg_path}"

echo $(pwd)

# Visualization with FSLeyes for each significant file
while IFS= read -r line; do
    # Extract filename and max p-value from each line
    filename=$(echo "${line}" | awk '{print $1}')

    # Extract IC number from filename
    ic_number=$(echo "${filename}" | grep -oP 'ic\K\d+')

    # Launch FSLeyes for visualization
    echo "Launching FSLeyes for visualization of ${filename} with IC number ${ic_number}"
    fsleyes "${analysis_path}/preprocessed/unbiased_template_datasink/unbiased_template/template_sharpen_shapeupdate.nii.gz" -cm greyscale -a 100 \
    "${analysis_path}/preprocessed/commonspace_labels_file.nii.gz" -cm rainbow -a 0 \
   "${analysis_path}/misc_data/DSURQE_100micron_DRICA_resampled.nii.gz" -v "${ic_number}" -cm red-yellow -dr 3.5 15 -a 60\
    "${filename}" -cm blue-lightblue -dr 0.95 1 -a 60

done < stats/filtered_stats1.txt


# Visualization with FSLeyes for each significant file
while IFS= read -r line; do
    # Extract filename and max p-value from each line
    filename=$(echo "${line}" | awk '{print $1}')

    # Extract IC number from filename
    ic_number=$(echo "${filename}" | grep -oP 'ic\K\d+')

    # Launch FSLeyes for visualization
    echo "Launching FSLeyes for visualization of ${filename} with IC number ${ic_number}"
    fsleyes "${analysis_path}/preprocessed/unbiased_template_datasink/unbiased_template/template_sharpen_shapeupdate.nii.gz" -cm greyscale -a 100 \
    "${analysis_path}/preprocessed/commonspace_labels_file.nii.gz" -cm rainbow -a 0 \
   "${analysis_path}/misc_data/DSURQE_100micron_DRICA_resampled.nii.gz" -v "${ic_number}" -cm red-yellow -dr 3.5 15 -a 60\
    "${filename}" -cm blue-lightblue -dr 0.95 1 -a 60

done < stats/filtered_stats2.txt
