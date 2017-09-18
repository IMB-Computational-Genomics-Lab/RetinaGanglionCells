#!/bin/bash

# Detect where script is being launched from
RUN_DIR=$(dirname "$0")

# Load variables from XML
XML_SCRIPT=$RUN_DIR/ParseXML.bash
XML_INPUT=$RUN_DIR/project.xml
source $XML_SCRIPT $XML_INPUT
source $RUN_DIR/CheckEnv.bash

# Create fastq and output directories if they don't exist
mkdir -p $FASTQ_DIR
mkdir -p $OUTPUT_DIR

# Process BCL to FASTQ with Cell Ranger 1.3.1
export PATH=${CELLRANGER_DIR}:$PATH
source ${CELLRANGER_DIR}/sourceme.bash

echo "Running Cell Ranger 1.3.1 - mkfastq with INPUT PATH: ${RAW_DIR} and OUTPUT PATH: ${FASTQ_DIR}"

cd $FASTQ_DIR
time cellranger mkfastq --run=${RAW_DIR} --csv=${SAMPLESHEET} --use-bases-mask="Y26n*,I8n*,n*,Y98n*" --ignore-dual-index

echo "Running Cell Ranger 1.3.1 - count with INPUT PATH: ${FASTQ_DIR} and OUTPUT PATH: ${OUTPUT_DIR}"

cd $OUTPUT_DIR
INPUT_DIR=$FASTQ_DIR/$FLOWCELL_ID/outs/fastq_path

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
time cellranger count --id=${ID_1} --sample=${SAMPLE_1} --indices=${INDEX_1} --fastqs=${INPUT_DIR} --cells=${NCELLS_1} --localmem=${NMEM}GB --localcores=${NCORE} --transcriptome=${REFERENCE_DIR}

# Run Sample 2
time cellranger count --id=${ID_2} --sample=${SAMPLE_2} --indices=${INDEX_2} --fastqs=${INPUT_DIR} --cells=${NCELLS_2} --localmem=${NMEM}GB --localcores=${NCORE} --transcriptome=${REFERENCE_DIR}

# Aggregate data using Cell Ranger Aggr
MOLECULE_H5=$RUN_DIR/aggregation.csv

cd $OUTPUT_DIR
ID=IPSCRetina_scRNA_Aggr
time cellranger aggr --id=${ID} --csv=${MOLECULE_H5} --normalize=mapped
