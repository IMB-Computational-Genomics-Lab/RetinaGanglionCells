#!/bin/bash

# Detect where script is being launched from
RUN_DIR=$(dirname "$0")

# Load variables from XML
XML_SCRIPT=$RUN_DIR/ParseXML.bash
XML_INPUT=$RUN_DIR/project.xml
source $XML_SCRIPT $XML_INPUT

# Create directories
mkdir -p $FASTQ_DIR
mkdir -p $OUTPUT_DIR

# Input Files
SAMPLE1_R1=$RAW_DIR/iPSC_RGCscRNAseq_Sample1_L005_R1.fastq.gz
SAMPLE1_R2=$RAW_DIR/iPSC_RGCscRNAseq_Sample1_L005_R2.fastq.gz
SAMPLE1_I1=$RAW_DIR/iPSC_RGCscRNAseq_Sample1_L005_I1.fastq.gz
SAMPLE2_R1=$RAW_DIR/iPSC_RGCscRNAseq_Sample2_L005_R1.fastq.gz
SAMPLE2_R2=$RAW_DIR/iPSC_RGCscRNAseq_Sample2_L005_R2.fastq.gz
SAMPLE2_I1=$RAW_DIR/iPSC_RGCscRNAseq_Sample2_L005_I1.fastq.gz

# Check before proceeding with pipeline
source $RUN_DIR/CheckEnv.bash

# Recreate mkfastq output directory
cp -r $RUN_DIR/mkfastq $FASTQ_DIR

# Reset FASTQ dir to new folder location
FASTQ_DIR=$FASTQ_DIR/mkfastq/$FLOWCELL_ID/outs/fastq_path

# Move files
cp $SAMPLE1_R1 $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1POS
cp $SAMPLE1_R2 $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1POS
cp $SAMPLE1_I1 $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1POS

cp $SAMPLE2_R1 $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1NEG
cp $SAMPLE2_R2 $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1NEG
cp $SAMPLE2_I1 $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1NEG

# Rename files
cd $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1POS
rename iPSC_RGCscRNAseq_Sample1 A81E7THY1POS_S1 *.fastq.gz
rename .fastq _001.fastq *.fastq.gz

cd $FASTQ_DIR/$FLOWCELL_ID/A81E7THY1NEG
rename iPSC_RGCscRNAseq_Sample2 A81E7THY1NEG_S2 *.fastq.gz
rename .fastq _001.fastq *.fastq.gz

# Run count with FASTQ with Cell Ranger 1.3.1
export PATH=${CELLRANGER_DIR}:$PATH
source ${CELLRANGER_DIR}/sourceme.bash

echo "Running Cell Ranger 1.3.1 - count with INPUT PATH: ${FASTQ_DIR} and OUTPUT PATH: ${OUTPUT_DIR}"

cd $OUTPUT_DIR
INPUT_DIR=$FASTQ_DIR

# Sample Information
ID_1=IPSCRetina_scRNA_Sample1
SAMPLE_1=A81E7THY1POS
INDEX_1=SI-GA-C11
NCELLS_1=2000

ID_2=IPSCRetina_scRNA_Sample2
SAMPLE_2=A81E7THY1NEG
INDEX_2=SI-GA-C12
NCELLS_2=2000

# Run Sample 1
time cellranger count --id=${ID_1} --sample=${SAMPLE_1} --indices=${INDEX_1} --fastqs=${INPUT_DIR} --cells=${NCELLS_1} --localmem=${NMEM}GB --localcores=${NCORE} --transcriptome=${REFERENCE_DIR} || exit 1

# Run Sample 2
time cellranger count --id=${ID_2} --sample=${SAMPLE_2} --indices=${INDEX_2} --fastqs=${INPUT_DIR} --cells=${NCELLS_2} --localmem=${NMEM}GB --localcores=${NCORE} --transcriptome=${REFERENCE_DIR} || exit 1

# Aggregate data using Cell Ranger Aggr
MOLECULE_H5=$RUN_DIR/aggregation.csv

cd $OUTPUT_DIR
ID=IPSCRetina_scRNA_Aggr
time cellranger aggr --id=${ID} --csv=${MOLECULE_H5} --normalize=mapped || exit 1
