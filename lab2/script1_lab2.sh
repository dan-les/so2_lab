#!/bin/bash -eu
# Daniel Lesniewicz, 250996

NO_DIRECTORY_ERROR=1
NO_PARAM_ERROR=2
 
if [[ $# -eq 2 ]]; then
    echo -e "Skrypt uruchomiono z dwoma parametrami:"
    DIRECTORY_1=${1}
    DIRECTORY_2=${2} 

    if [[ "${DIRECTORY_1}" = /* ]]; then
        echo -e "\tkatalog 1: ${DIRECTORY_1} <--bezwzgledna sciezka"
    else
        echo -e "\tkatalog 1: ${DIRECTORY_1} <--wzgledna sciezka"
    fi

    if [[ "${DIRECTORY_2}" = /* ]]; then
        echo -e "\tkatalog 2: ${DIRECTORY_2} <--bezwzgledna sciezka"
    else
        echo -e "\tkatalog 2: ${DIRECTORY_2} <--wzgledna sciezka"
    fi
     
else
    echo "Skrypt należy uruchomić z dwoma parametrami!"
    exit ${NO_PARAM_ERROR}
fi


if [[ ! -d "${DIRECTORY_1}" ]] || [[ ! -d "${DIRECTORY_2}" ]]; then
    echo -e "Ktorys z podanych katalogow nie istnieje!\n"
    exit ${NO_DIRECTORY_ERROR}
fi

#########################################################################

# 3.0: Napisać skrypt, który przyjmuje 2 parametry – 2 ścieżki do katalogów.
# Z zadanego katalogu nr 1 wypisać wszystkie pliki po kolei, wraz z informacją:
# - czy jest to katalog
# - czy jest to dowiązanie symboliczne
# - czy plik regularny.
    # Następnie (lub równolegle) utworzyć w katalogu nr 2 dowiązania symboliczne 
    # do każdego pliku regularnego i katalogu z katalogu nr 1, dodając "_ln" przed 
    # rozszerzeniem, np. magic_file.txt -> magic_file_ln.txt
echo -e "\nZawartosc pliku: "

 

for FILE in "${DIRECTORY_1}"/*; do

    FILE_NAME_WITH_EXTENSION=${FILE##*/}
    FILE_EXTENSION=${FILE_NAME_WITH_EXTENSION##*.}
    FILE_NAME=${FILE_NAME_WITH_EXTENSION%.*}

    if [[ -d "${FILE}" ]]; then
        echo -e "\t${FILE} - katalog"

        if [[ ! "${DIRECTORY_1}" = /* ]];then # w zaleznosci od rodzaju podanej sciezki (wzgledna/bezwzgledna)
            ln -s "${PWD}/${FILE}" "${DIRECTORY_2}/${FILE_NAME}_ln"
        else
            ln -s "${FILE}" "${DIRECTORY_2}/${FILE_NAME}_ln"
        fi    

    elif [[ -L "${FILE}" ]]; then
        echo -e "\t${FILE} - dowiazanie symboliczne"

    elif [[ -f "${FILE}" ]]; then
        echo -e "\t${FILE} - plik regulary"

        if [[ ! "${DIRECTORY_1}" = /* ]];then # w zaleznosci od rodzaju podanej sciezki (wzgledna/bezwzgledna)
            ln -s "${PWD}/${FILE}" "${DIRECTORY_2}/${FILE_NAME}_ln.${FILE_EXTENSION}"
        else
            ln -s "${FILE}" "${DIRECTORY_2}/${FILE_NAME}_ln.${FILE_EXTENSION}"
        fi
    fi

done

