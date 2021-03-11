#!/bin/bash


if [[ $# -eq 3 ]]; then
    SOURCE_DIR=${1}
    RM_LIST=${2} 
    TARGET_DIR=${3}
 
elif [[ $# -eq 0 ]]; then
    SOURCE_DIR=${1:-lab_uno}
    RM_LIST=${2:-lab_uno/2remove} 
    TARGET_DIR=${3:-bakap}
fi

for FILE in ${TARGET_DIR}/*; do
    chmod +w -R ${FILE}
done

rm -rf ${SOURCE_DIR}
rm -rf ${TARGET_DIR}
rm -r *.zip
