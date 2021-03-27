#!/bin/bash -eu
# Daniel Lesniewicz, 250996

NO_DIRECTORY_ERROR=1
WRONG_PARAM_ERROR=2
 
if [[ $# -eq 2 ]]; then
    echo -e "Skrypt uruchomiono z dwoma parametrami:"
    DIRECTORY_1=${1}
    FILE1=${2} 

    if [[ "${DIRECTORY_1}" = /* ]]; then
        echo -e "\tkatalog 1: ${DIRECTORY_1} <--bezwzgledna sciezka"
    else
        echo -e "\tkatalog 1: ${DIRECTORY_1} <--wzgledna sciezka"
    fi

    if [[ "${FILE1}" = /* ]]; then
        echo -e "\tplik: ${FILE1} <--bezwzgledna sciezka"
    else
        echo -e "\tplik: ${FILE1} <--wzgledna sciezka"
    fi
     
else
    echo "Skrypt należy uruchomić z dwoma parametrami!"
    exit ${WRONG_PARAM_ERROR}
fi


if [[ ! -d "${DIRECTORY_1}" ]]; then
    echo -e "Katalog nie istnieje!\n"
    exit ${NO_DIRECTORY_ERROR}
fi

########################################################################################################
# +0.5 - Napisać skrypt, który w zadanym katalogu (1. parametr) usunie wszystkie uszkodzone dowiązania 
# symboliczne, a ich nazwy wpisze do pliku (2. parametr), wraz z dzisiejszą datą w formacie ISO 8601.
########################################################################################################

# ilosc plikow w folderze w ktorym sprawdzamy czy sa uszkodzone dowiazania symboliczne
COUNT=$(ls "${DIRECTORY_1}" | wc -w)

if [[ ${COUNT} -gt 0 ]]; then
    touch "${FILE1}"
    for FILE in "${DIRECTORY_1}"/*; do
        FILE_NAME_WITH_EXTENSION=${FILE##*/}

        # jesli nie istnieje plik to dowiazanie jest uszkodzone
        if [[ ! -e "${FILE}" ]]; then
            echo "${FILE_NAME_WITH_EXTENSION} jest uszkodzony - $(date --iso-8601)" >> ${FILE1}
            rm "${FILE}"
        fi
    done
fi


 