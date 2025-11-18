# Load libraries
library(DESeq2)
library(ggplot2)
library(pheatmap)
install.packages("ggrepel")  # Install the package
library(ggrepel)  # Load it


setwd(" ")
countData <- read.csv("Count_Matrix.csv", row.names = 1)
colData <- read.csv("coldata.csv", row.names = 1)

# Ensure row names of colData match column names of countData
stopifnot(all(rownames(colData) == colnames(countData)))

# Ensure 'condition' is a factor
colData$condition <- as.factor(colData$condition)

# Create DESeq2 dataset
dds <- DESeqDataSetFromMatrix(countData=countData, 
                              colData=colData, 
                              design=~condition)

sum(rowSums(counts(dds)) <= 10)
dds <- dds[rowSums(counts(dds)) > 10, ]

# Run DESeq2
dds <- DESeq(dds)


res <- results(dds, contrast = c("condition", "condition1", "condition2"))

summary(res)

# View the results
head(res)


vsd <- vst(dds, blind = FALSE)
vsd
vsd_data <- assay(vsd) 

write.csv(vsd_data, "vsd_normalized_data.csv")

plotPCA(vsd, intgroup = "condition")


# Dispersion estimates
plotDispEsts(dds)

resOrdered <- res[order(res$pvalue), ]

# Save results
write.csv(as.data.frame(resOrdered), "DEGs_results.csv")


# Plot MA plot
plotMA(res, main="DESeq2 MA Plot (Raw P-values)", ylim=c(-5,5))

# Summary of results
summary(res)

# Get significant DEGs (based on raw p-value)
sig_DEGs <- subset(resOrdered, pvalue < 0.05)
sig_DEGs
write.csv(as.data.frame(sig_DEGs), "Significant_DEGs_raw_pvalues.csv")


upregulated_genes <- subset(sig_DEGs, log2FoldChange > 1.5)   
downregulated_genes <- subset(sig_DEGs, log2FoldChange < -1.5)


head(upregulated_genes)
head(downregulated_genes)

write.csv(upregulated_genes, "upregulated_genes.csv")
write.csv(downregulated_genes, "downregulated_genes.csv")




#Volcano plot for top 10 upregulated and top 10 downregulated genes


# Load libraries
library(ggplot2)
library(ggrepel)

# Read differential expression data
deg <- read.csv("DEGs_results.csv", header=TRUE, stringsAsFactors=FALSE)

# Classify genes based on significance & fold change
deg$change <- ifelse(deg$pvalue < 0.05 & deg$log2FoldChange > 1.5, "Upregulated",
                     ifelse(deg$pvalue < 0.05 & deg$log2FoldChange < -1.5, "Downregulated", "Not Significant"))

# Select top 10 most significant UPREGULATED genes (smallest p-value)
top10_up <- head(deg[deg$change == "Upregulated", ][order(deg$pvalue), ], 10)

# Select top 10 most significant DOWNREGULATED genes (smallest p-value)
top10_down <- head(deg[deg$change == "Downregulated", ][order(deg$pvalue), ], 10)

# Combine for annotation
top_genes <- rbind(top10_up, top10_down)

# Volcano Plot with Gene Labels
ggplot(deg, aes(x = log2FoldChange, y = -log10(pvalue), color = change)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("Upregulated" = "red", "Downregulated" = "blue", "Not Significant" = "gray")) +
  
  # Annotate top upregulated & downregulated genes
  geom_text_repel(data = top_genes, aes(label = X), 
                  size = 3, 
                  box.padding = 0.5, 
                  max.overlaps = 20) +  
  
  theme_minimal() +
  labs(title = "Volcano Plot of Differential Gene Expression",
       x = "Log2 Fold Change (logFC)",
       y = "-Log10 P-value (Significance)",
       color = "Gene Regulation") +  
  theme(legend.title = element_blank())  





