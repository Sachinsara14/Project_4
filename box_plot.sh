#!/bin/bash

echo "--- Starting TCGA Analysis Pipeline ---"

# 1. Extract data (Skip if already done)
if [ ! -d "e6e83fd4-2f80-44e1-8dce-588a37308dbb" ]; then
    echo "Extracting tcga_data.tar.gz..."
    tar -zxvf tcga_data.tar.gz > /dev/null 2>&1
    echo "Extraction complete."
else
    echo "Step 1: Data already unzipped. Skipping."
fi

# 2. Prepare Output
OUTPUT_FILE="nkx2_1_expression_data.csv"
echo "sample_type,tpm" > $OUTPUT_FILE

echo "Step 2: Parsing Sample Sheet and Extracting NKX2-1..."

# 3. Parse Metadata and Extract Data
awk -F'\t' '
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "File ID") id_col=i
        if ($i == "File Name") name_col=i
        if ($i == "Sample Type") type_col=i
    }
}
NR>1 {
    if ($type_col == "Primary Tumor" || $type_col == "Solid Tissue Normal") {
        print $id_col "\t" $name_col "\t" $type_col
    }
}' gdc_sample_sheet.tsv | while IFS=$'\t' read -r file_id file_name sample_type; do
    
    file_path="${file_id}/${file_name}"
    
    if [ -f "$file_path" ]; then
        # --- THE FIX IS HERE ---
        # We added "; exit" so it stops after the first match
        tpm=$(awk '$2 == "NKX2-1" {print $7; exit}' "$file_path")
        
        if [ ! -z "$tpm" ]; then
            echo "${sample_type},${tpm}" >> $OUTPUT_FILE
        fi
    fi
done

echo "Done! Extracted data saved to $OUTPUT_FILE"
# Let's verify the fix
echo "Preview of fixed data:"
head -n 5 $OUTPUT_FILE