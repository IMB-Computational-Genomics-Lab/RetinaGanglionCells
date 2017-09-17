#!/bin/bash

# Checks if environment is okay

function checkDir {
 if [ ! -d $1 ]; then
    MISSING_DIRS+=($1)
 fi
}

function checkFile {
  if [ ! -f $1 ]; then
    MISSING_FILES+=($1)
  fi
}

# CHECK ENVIRONMENT IS CORRECT
MISSING_DIRS=()
MISSING_FILES=()

# Directory check
checkDir $RAW_DIR
checkDir $CELLRANGER_DIR
checkDir $REFERENCE_DIR

# Filecheck
checkFile $RAW_DIR/RunInfo.xml

if [ ! ${#MISSING_DIRS[@]} -eq 0 ]; then
  echo "Please check the following directories:"
  echo ${MISSING_DIRS[@]}
  exit 1
fi

if [ ! ${#MISSING_FILES[@]} -eq 0 ]; then
  echo "Please check the following files:"
  echo ${MISSING_FILES[@]}
  exit 1
fi
