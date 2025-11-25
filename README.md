#  Project 4: TCGA RNA-seq Data Analysis

**Goal:** Automate the analysis of large-scale cancer genomics data to validate biomarkers. This project analyzes **Lung Adenocarcinoma (LUAD)** data from The Cancer Genome Atlas (TCGA) to quantify the differential expression of the gene *NKX2-1* in Primary Tumors versus Solid Tissue Normal samples.

###  Key Features
* **Metadata Parsing:** Automatically links blind data files to clinical information (Tumor vs Normal) using the GDC sample sheet.
* **Automated Extraction:** Uses Bash/Awk to mine specific gene targets from hundreds of RNA-seq files without manual intervention.
* **Statistical Visualization:** Generates publication-quality boxplots in R, applying Log2 transformation for proper expression scaling.

###  File Structure

| File | Language | Description |
| :--- | :--- | :--- |
| `box_plot.sh` | Bash | The engine. Unzips data, parses `gdc_sample_sheet.tsv`, extracts TPM values for *NKX2-1*, and saves a CSV. |
| `expression_plot.r` | R | The visualizer. Reads the CSV, performs $Log_2(TPM+1)$ transformation, and plots the comparison. |
| `gdc_sample_sheet.tsv` | Data | Metadata linking File IDs to Sample Types. |
| `tcga_data.tar.gz` | Data | Compressed archive containing raw gene expression files. |

### Prerequisites
* Bash / Unix Environment
* R (Libraries: `ggplot2`)
* Standard tools: `tar`, `awk`, `grep`

### Usage

#### 1. Extract and Process Data
Run the Bash script to unzip the archive and mine the data.
```bash
bash box_plot.sh
```

#### Output 
`nkx2_1_expression_data.csv`

#### 2. Visualize Result
```bash
Rscript expression_plot.R
```
#### Output file
`nkx2_1_boxplot.png`
