#!/bin/bash

 
SOURCE_DIR=${1:-lab_uno}
TARGET_DIR=${2:-bakap}
 

for FILE in ${TARGET_DIR}/*; do
    chmod +w -R ${FILE}
done

rm -rf ${SOURCE_DIR}
rm -rf ${TARGET_DIR}
rm -r *.zip
