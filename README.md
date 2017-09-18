# Retina ganglion cells dataset
Maciej Daniszewski, Anne Senabouth, Duncan E. Crombie, Quan Nguyen, Samuel Lukowski, Tejal Kulkani,  Donald J Zack,  Alice Pébay, Joseph E. Powell and Alex W. Hewitt

Public repository for code associated with the processing of single-cell retina ganglion cells

## Raw Data
Link on GEO

## Required installations
### Cell Ranger 1.3.1
Please refer to the [10x Genomics](https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/1.3/) for information about this program.

### R 3.4.1
Please refer to the [R website](https://www.r-project.org/) for information about this program.

## Instructions
### Processing raw data with Cell Ranger 1.3.1
**THIS STAGE SHOULD BE RUN ON A HIGH-PERFORMANCE COMPUTING ENVIRONMENT**
1. Download the raw data from GEO. *Confirm final format - will determine where we will start in the pipeline*
2. Download the Cell Ranger 1.3.1 reference. You can also prepare your own by following the instructions [here](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/advanced/references).
3. Edit [project.xml](project.xml) to suit your computing environment. Make sure your paths do not end in '/'.
4. Run [ProcessData.bash](ProcessData.bash). If you are working on a cluster, you can call this from a cluster submission script. We have included one for PBSPro ([SubmitPBS.pbs](SubmitPBS.pbs)), which you can use as a template for other systems.

### Processing Cell Ranger output with R
