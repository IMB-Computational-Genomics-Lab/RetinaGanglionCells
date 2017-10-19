#!/usr/bin/env Rscript
# Set up arguments and checks
args = commandArgs(trailingOnly = TRUE)

# Check if argument has been entered
if (length(args) == 0){
  stop("Please specify the location of your aggregated output.")
} else if (length(args) == 1){
  file.dir <- args[1]
  # Check if it exists
  if(!dir.exists(file.dir)){
    stop("Please specify the correct location of your aggregated output.")
  }
}

# Load ASCEND Package
library(ASCEND)

# BiocParallel Setup
library(BiocParallel)
ncores <- parallel::detectCores() - 1
register(MulticoreParam(workers = ncores, progressbar=TRUE), default = TRUE)

# Load data into ASCEND
aem.set <- CellRangerToASCEND(file.dir, "GRCh38p7")

# Filter Cells
aem.set <- FilterByOutliers(aem.set, cell.threshold = 3, control.threshold = 3)
aem.set <- FilterByControl("Mt", 20, aem.set)
aem.set <- FilterByControl("Rb", 50, aem.set)
aem.set <- FilterByExpressedGenesPerCell(aem.set, pct.value = 1)

# Normalise counts with Scran method
aem.set <- scranNormalise(aem.set)

# Reduce with PCA
aem.set <- RunPCA(aem.set)
aem.set <- ReduceDimensions(aem.set, n = 20)

# Cluster data with CORE algorithm
aem.set <- RunCORE(aem.set, conservative = TRUE)

# Remove dead cluster from dataset
aem.set <- SubsetCluster(aem.set, clusters = c("1"))

# Split expression matrix by batch
sample1.obj <- SubsetBatch(aem.set, batches = c("1"))
sample2.obj <- SubsetBatch(aem.set, batches = c("2"))

# Extract expression matrix
sample1.matrix <- GetExpressionMatrix(sample1.obj, format = "data.frame")
sample2.matrix <- GetExpressionMatrix(sample2.obj, format = "data.frame")

# Write files
write.table(sample1.matrix, file = "iPSC_RGscRNASeq_Sample1.tsv", sep = "\t", col.names = NA)
write.table(sample2.matrix, file = "iPSC_RGscRNASeq_Sample2.tsv", sep = "\t", col.names = NA)

