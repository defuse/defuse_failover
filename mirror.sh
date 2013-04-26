#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: ./mirror.sh <url> <output directory>"
    exit 1
fi

URL=$1
OUTPUT_DIR=$2

cd "$OUTPUT_DIR"
rm -rf *
wget --mirror --no-check-certificate --no-host-directories --page-requisites "$URL" 
