# Load ascend (development version) package
devtools::load_all(pkg = "ascend-dev")

# BiocParallel Setup
library(BiocParallel)
ncores <- parallel::detectCores() - 1
register(MulticoreParam(workers = ncores, progressbar=TRUE), default = TRUE)

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

# Load data into ASCEND
em.set <- CellRangerToASCEND(file.dir, "GRCh38p7")

# Filter Cells
em.set <- FilterByOutliers(em.set, cell.threshold = 3, control.threshold = 3)
em.set <- FilterByControl("Mt", 20, em.set)
em.set <- FilterByControl("Rb", 50, em.set)
em.set <- FilterByExpressedGenesPerCell(em.set, pct.value = 1)

# Normalise counts with Scran method
em.set <- scranNormalise(em.set)

# Reduce with PCA
em.set <- RunPCA(em.set)
em.set <- ReduceDimensions(eem.set, n = 20)

# Cluster data with CORE algorithm
em.set <- RunCORE(em.set, conservative = TRUE)

# Remove dead cluster from dataset
em.set <- SubsetCluster(em.set, clusters = c("1"))

# Separate out samples
# Split expression matrix by batch
sample1.obj <- SubsetBatch(em.set, batches = c("1"))
sample2.obj <- SubsetBatch(em.set, batches = c("2"))

# Extract expression matrix
sample1.matrix <- GetExpressionMatrix(sample1.obj, format = "data.frame")
sample2.matrix <- GetExpressionMatrix(sample2.obj, format = "data.frame")

# Write files
write.table(sample1.matrix, file = "iPSC_RGscRNASeq_Sample1.tsv", sep = "\t", col.names = NA)
write.table(sample2.matrix, file = "iPSC_RGscRNASeq_Sample2.tsv", sep = "\t", col.names = NA)