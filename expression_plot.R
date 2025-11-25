 # Check for ggplot2
if (!require("ggplot2")) install.packages("ggplot2")

library(ggplot2)

cat("--- Starting Project 4: Visualization ---\n")

# 1. Read the CSV we just made
csv_file <- "nkx2_1_expression_data.csv"
if (!file.exists(csv_file)) {
  stop("Error: CSV file not found! Did you run box_plot.sh?")
}

data <- read.csv(csv_file)
cat("Loaded", nrow(data), "samples.\n")

# 2. The Math: Log2(TPM + 1)
#    The project specifically asks for this transformation
data$log_tpm <- log2(data$tpm + 1)

# 3. Generate the Boxplot
cat("Generating plot...\n")

p <- ggplot(data, aes(x=sample_type, y=log_tpm, fill=sample_type)) +
  
  # Draw the boxplot
  geom_boxplot(outlier.colour="black", outlier.shape=16, outlier.size=2) +
  
  # Custom Colors (Pink for Tumor, Blue for Normal)
  scale_fill_manual(values=c("Solid Tissue Normal"="#56B4E9", "Primary Tumor"="#E69F00")) +
  
  # Theme and Labels
  theme_minimal() +
  labs(
    title = "NKX2-1 Expression: Normal vs Tumor",
    subtitle = "Lung Adenocarcinoma (LUAD)",
    x = "Tissue Type",
    y = "Log2 (TPM + 1)"
  ) +
  theme(
    legend.position = "none", # Hide legend (X-axis explains it enough)
    plot.title = element_text(hjust = 0.5, face="bold", size=14),
    axis.text = element_text(size=11)
  ) +
  
  # Add "n=" counts above the boxes (Professional touch)
  stat_summary(
    fun.data = function(y) {
      return(data.frame(y = max(y) + 0.5, label = paste0("n=", length(y))))
    },
    geom = "text",
    position = position_dodge(width = 0.75)
  )

# 4. Save the image
ggsave("nkx2_1_boxplot.png", plot=p, width=8, height=6, dpi=300)
cat("Success! Plot saved to 'nkx2_1_boxplot.png'\n")