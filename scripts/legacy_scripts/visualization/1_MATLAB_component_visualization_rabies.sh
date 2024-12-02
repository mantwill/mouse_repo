### component visualization matlab slicesdir

#must before register melodic_IC to unbiased template (using e.g. fsleyes with nearest neighbour)


# before running this we did the following:
# from group_ica folder: gather mask.nii.gz, mean.nii.gz, melodic_IC.nii.gz
# from preprocessing folder: gather template_sharpen_shapeupdate.nii.gz

# melodic_IC was resampled to template_sharpen_shapeupdate file (using fsleyes). If file cannot be selected, manually setting image dimensions
# also works. Melodic IC is resampled using nearest neighbor algorithm.

# additionally, the mask.nii is also resampled to the template_sharpen_ file. Here to it is most important that the image dimensions are identical, also using smoohting +
# nearest neighbour.

# we then also use fslmaths to extract the brain (fslmaths template_blabla -mul mask.nii template_sharpen_shapeupdate_bet)

# if we want to automate this entirely we need to find the function that changes image dimensions in fsl (and does e.g. nearest neighbor) 


fslswapdim visualization/melodic_IC_resampled.nii.gz x z y visualization/melodic_IC_resampled_swapped.nii.gz # melodic
fslswapdim visualization/template_sharpen_shapeupdate_bet.nii.gz x z y visualization/template_sharpen_shapeupdate_bet_swapped.nii.gz # template


slices_summary visualization/melodic_IC_resampled_swapped 4 visualization/template_sharpen_shapeupdate_bet_swapped.nii.gz visualization/melodic_IC.sum

























#try this:

# Create an identity matrix (if you don't have one)
# echo "1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1" > identity.mat

# Use flirt to resample
# flirt -in input_image.nii -ref input_image.nii -out resampled_image.nii -applyisoxfm 0.1 -interp nearestneighbour -setdimx NEW_DIM_X -setdimy NEW_DIM_Y -setdimz NEW_DIM_Z
# fslmaths resampled_image.nii -s 2 smoothed_image.nii

