#!/bin/bash
# Daniel Lesniewicz, 250996

# +0.5 – napisać skrypt, który pobiera 3 argumenty: 
# SOURCE_DIR, RM_LIST, TARGET_DIR o wartościach domyślnych: lab_uno, lab_uno /2remove, bakap
if [[ $# -eq 3 ]] || [[ $# -eq 0 ]]; then
    echo -e "Skrypt uruchomiono z trzema parametrami:"
    SOURCE_DIR=${1:-lab_uno}
    RM_LIST=${2:-lab_uno/2remove} 
    TARGET_DIR=${3:-bakap}

    echo -e "\tSOURCE_DIR: ${SOURCE_DIR}\n\tRM_LIST: ${RM_LIST}\n\tTARGET_DIR: ${TARGET_DIR}"
 
    if [[ $# -eq 0 ]]; then
    echo "Sa to parametry domyslne."
    fi

else
    echo "Skrypt należy uruchomić z trzema parametrami lub bez zadnego parametru!"
    exit 1
fi

 
# +0.5 – jeżeli TARGET_DIR nie istnieje, to go tworzymy
if [ ! -d "${TARGET_DIR}" ]; then
    echo -e "\nKatalog $TARGET_DIR NIE istnieje, zatem go stworzymy!\n"
    mkdir "${TARGET_DIR}"
else
    echo -e "\nKatalog $TARGET_DIR juz istnieje!\n"
fi


# +1.0 – iterujemy się po zawartości pliku RM_LIST i tylko jeżeli plik 
# o takiej nazwie występuje w katalogu SOURCE_DIR, to go usuwamy
    #  folder to tez plik - dlatego dalem OR'a ;)
TO_REMOVE_LIST=$(cat "${RM_LIST}")
echo "Usuwam plik:"
for LIST_ELEM in ${TO_REMOVE_LIST}; do
    if [[ -f "${SOURCE_DIR}/${LIST_ELEM}" ]] || [[ -d "${SOURCE_DIR}/${LIST_ELEM}" ]]; then
        echo -e "\t${LIST_ELEM}"
        rm -r "${SOURCE_DIR}/${LIST_ELEM}"
    fi

done


# +0.5 – jeżeli jakiegoś pliku nie ma na liście, ale jest plikiem, to przenosimy go do TARGET_DIR
# +0.5 – jeżeli jakiegoś  pliku nie ma na liście, ale jest katalogiem, to kopiujemy go do TARGET_DIR z zawartością
#   czyli: jeśli nie został usunięty w poprzednim kroku to wykonujemy wlasciwa operacje
echo " "
for FILE in ${SOURCE_DIR}/*; do
 
    if [[ -f ${FILE} ]]; then
        echo "Przenosze plik: ${FILE} do ${TARGET_DIR}"
        mv "${FILE}" "${TARGET_DIR}"
    fi

    if [[ -d ${FILE} ]]; then
        echo "Kopiuje plik - katalog: ${FILE} do ${TARGET_DIR}"
        cp -r "${FILE}" "${TARGET_DIR}"
    fi    
done

 
# +1.0  – jeżeli po zakończeniu operacji są jeszcze jakieś pliki w katalogu SOURCE_DIR to:
# piszemy np. „jeszcze coś zostało” na konsolę oraz
# jeżeli co najmniej 2 pliki, to wypisujemy: „zostały co najmniej 2 pliki”
# jeżeli więcej niż 4, to wypisujemy: „zostało więcej niż 4 pliki” (UWAGA: 4, to też więcej niż 2)
# jeżeli nie więcej, niż 4, ale co najmniej 2, to też coś piszemy
# Jeżeli nic nie zostało, to informujemy o tym słowami np. „tu był Kononowicz”
COUNT=$(ls "${SOURCE_DIR}" | wc -w)

if [[ ${COUNT} -gt 0 ]]; then
    echo -e "\nJeszcze cos zostalo! \nIlosc plikow (folderow) w ${SOURCE_DIR}: ${COUNT}"
    
    if [[ ${COUNT} -ge 2 ]]; then
        echo -e "\tZostaly co najmniej 2 pliki!"
    fi

    if [[ ${COUNT} -gt 4 ]]; then
        echo -e "\tZostaly wiecej niz 4 pliki!"
    fi

    if [[ ${COUNT} -ge 2 ]] && [[ ${COUNT} -le 4 ]]; then
        echo -e "\tZostaly 2, 3 lub 4 pliki!"
    fi

else
    echo -e "\nNic nie zostalo!"
fi


# +0.5 – wszystkie pliki w katalogu TARGET_DIR muszą mieć odebrane prawa do edycji
echo -e "\nOdebrano prawo do edycji plikowi"
for FILE in ${TARGET_DIR}/*; do
    chmod -w -R ${FILE} 
    echo -e "\t${FILE}"
    # odebranie prawa do zapisu (czyli edycji)
    # ew. mozna uzyc: chattr +i ${FILE}
done
  

# +0.5 – po wszystkich spakuj katalog TARGET_DIR i nazwij bakap_DATA.zip, 
# gdzie DATA to dzień uruchomienia skryptu w formacie RRRR-MM-DD
zip_file_name=bakap_"`date +"%Y-%m-%d"`"
echo -e "\nNazwa archiwum:\n\t ${zip_file_name}.zip"
zip -rq "${zip_file_name}.zip" "${TARGET_DIR}"