#!/bin/bash
# This script is called by ProcessData to parse information entered into the project.xml file
# The project.xml file should be in the same directory as this file.

# Load this XML file
INPUT_XML=$1

# Load these variables into the bash environment
## Cell Ranger-related paths
CELLRANGER_DIR=$(xmllint --xpath "string(//cellranger-dir)" $INPUT_XML)
BCL2FASTQ_DIR=$(xmllint --xpath "string(//bcl2fastq-dir)" $INPUT_XML)

## Assign directories for this job
RAW_DIR=$(xmllint --xpath "string(//raw-dir)" $INPUT_XML)
FASTQ_DIR=$(xmllint --xpath "string(//fastq-dir)" $INPUT_XML)
OUTPUT_DIR=$(xmllint --xpath "string(//output-dir)" $INPUT_XML)
REFERENCE_DIR=$(xmllint --xpath "string(//reference-dir)" $INPUT_XML)

## Flowcell ID
FLOWCELL_ID=CAU14ANXX

## Get system memory and RAM
NMEM=$(xmllint --xpath "string(//memory)" $INPUT_XML)
NCORE=$(xmllint --xpath "string(//cpus)" $INPUT_XML)
