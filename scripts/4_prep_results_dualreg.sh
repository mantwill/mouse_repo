
# Full path of dual regression head directories
# Store the current directory
CURRENT_DIR=$(pwd)

DUAL_REG_PATH="${CURRENT_DIR}/dual_regression/dual_reg_A_vs_B"
OUTPUT_PATH="${DUAL_REG_PATH}/stats"
pval_cutoff=0.95  # Set p-value cutoff for significance

# Change directory to the dual regression path
cd "${DUAL_REG_PATH}"
rm "${OUTPUT_PATH}/stats_output1.txt"
rm "${OUTPUT_PATH}/stats_output2.txt"
mkdir "${OUTPUT_PATH}"

# Investigate p-values and log max and min p-values to stats_output.txt for tfce_corrp_tstat1 files
echo "Processing tfce_corrp_tstat1 files..."
for i in *tfce_corrp_tstat1*; do
    echo -n "${i} " >> "${OUTPUT_PATH}/stats_output1.txt"
    fslstats "${i}" -R >> "${OUTPUT_PATH}/stats_output1.txt"
done

# Repeat for tfce_corrp_tstat2 files
echo "Processing tfce_corrp_tstat2 files..."
for i in *tfce_corrp_tstat2*; do
    echo -n "${i} " >> "${OUTPUT_PATH}/stats_output2.txt"
    fslstats "${i}" -R >> "${OUTPUT_PATH}/stats_output2.txt"
done

# Filter stats_output.txt to retain only entries with max p-values below or equal to the cutoff
echo "Filtering significant results..."
awk -v cutoff="${pval_cutoff}" '$NF >= cutoff' "${OUTPUT_PATH}/stats_output1.txt" | sort -k3,3nr > "${OUTPUT_PATH}/filtered_stats1.txt"
awk -v cutoff="${pval_cutoff}" '$NF >= cutoff' "${OUTPUT_PATH}/stats_output2.txt" | sort -k3,3nr > "${OUTPUT_PATH}/filtered_stats2.txt"
