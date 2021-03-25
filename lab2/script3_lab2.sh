#!/bin/bash -eu
# Daniel Lesniewicz, 250996

NO_DIRECTORY_ERROR=1
WRONG_PARAM_ERROR=2
 
if [[ $# -eq 1 ]]; then
    echo -e "Skrypt uruchomiono z jednym parametrem:"
    DIRECTORY_1=${1} 

    if [[ "${DIRECTORY_1}" = /* ]]; then
        echo -e "\tkatalog 1: ${DIRECTORY_1} <--bezwzgledna sciezka"
    else
        echo -e "\tkatalog 1: ${DIRECTORY_1} <--wzgledna sciezka"
    fi
 
else
    echo "Skrypt należy uruchomić z jednym parametrami!"
    exit ${WRONG_PARAM_ERROR}
fi


if [[ ! -d "${DIRECTORY_1}" ]]; then
    echo -e "Katalog nie istnieje!\n"
    exit ${NO_DIRECTORY_ERROR}
fi

#########################################################################

# +1.0 - Napisać skrypt, który w zadanym katalogu (jako parametr) każdemu:
# - plikowi regularnemu z rozszerzeniem .bak odbierze uprawnienia do edytowania dla właściciela i innych
# - katalogowi z rozszerzeniem .bak (bo można!) pozwoli wchodzić do środka tylko innym
# - w katalogach z rozszerzeniem .tmp pozwoli każdemu tworzyć i usuwać jego pliki
# - plikowi z rozszerzeniem .txt będą czytać tylko właściciele, edytować grupa właścicieli, 
#   wykonywać inni. Brak innych uprawnień
# - pliki regularne z rozszerzeniem .exe wykonywać będą mogli wszyscy, ale zawsze wykonają się 
#   z uprawnieniami właściciela (można przetestować na 
#   skompilowanym https://github.com/szandala/SO2/blob/master/lab2/suid.c)


for FILE in "${DIRECTORY_1}"/*; do
    FILE_NAME_WITH_EXTENSION=${FILE##*/}
    FILE_EXTENSION=${FILE_NAME_WITH_EXTENSION##*.}

 
    if [[ -f "${FILE}" ]] ; then
        if [[ ${FILE_EXTENSION} == "bak" ]]; then
            # odebranie prawa do zapisu i czytania czyli edycji dla wszystkich
            chmod -666 ${FILE}
        fi
        if [[ ${FILE_EXTENSION} == "txt" ]]; then
            # - plikowi z rozszerzeniem .txt będą czytać tylko właściciele, edytować grupa właścicieli, 
            #   wykonywać inni. Brak innych uprawnień
            #       czyli rozumiem to tak, ze grupa moze tylko edytowac czyli zapisywac i czytac
            chmod -777 ${FILE}
            chmod +466 ${FILE}
        fi

        if [[ ${FILE_EXTENSION} == "exe" ]]; then
            chmod +111 ${FILE}
        fi
    fi

    if [[ -d "${FILE}" ]]; then
        if [[ ${FILE_EXTENSION} == "bak" ]]; then
            # odebranie prawa do wchodzenia do srodka wlascicielowi, a pozwolenie innym
            chmod -400  ${FILE}
            chmod +044  ${FILE}
        fi
    fi

    
 
 
done



 