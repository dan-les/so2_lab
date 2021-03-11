#!/bin/bash
# Daniel Lesniewicz, 250996

# +0.5 – napisać skrypt, który pobiera 3 argumenty: 
# SOURCE_DIR, RM_LIST, TARGET_DIR o wartościach domyślnych: lab_uno, lab_uno /2remove, bakap
if [[ $# -eq 3 ]]; then
    echo "Skrypt uruchomiono z trzema (podanymi) parametrami."
    SOURCE_DIR=${1}
    RM_LIST=${2} 
    TARGET_DIR=${3}
 
elif [[ $# -eq 0 ]]; then
    echo "Skrypt uruchomiono z parametrami domyslnymi."
    SOURCE_DIR=${1:-lab_uno}
    RM_LIST=${2:-lab_uno/2remove} 
    TARGET_DIR=${3:-bakap}

else
    echo "Skrypt należy uruchomić z trzema parametrami lub bez zadnego parametru!"
    exit 1
fi

echo ""
# +0.5 – jeżeli TARGET_DIR nie istnieje, to go tworzymy
if [ ! -d ${TARGET_DIR} ]; then
    echo "Katalog $TARGET_DIR NIE istnieje, zatem go stworzymy!"
    mkdir ${TARGET_DIR}
else
    echo "Katalog $TARGET_DIR juz istnieje!"
fi

echo ""
# +1.0 – iterujemy się po zawartości pliku RM_LIST i tylko jeżeli plik 
# o takiej nazwie występuje w katalogu SOURCE_DIR, to go usuwamy
    #  folder to tez plik - dlatego dalem OR'a ;)

TO_REMOVE_LIST=$(cat "${RM_LIST}")
for LIST_ELEM in ${TO_REMOVE_LIST}; do
    if [[ -f ${SOURCE_DIR}/${LIST_ELEM} ]] || [[ -d ${SOURCE_DIR}/${LIST_ELEM} ]]; then
        echo "Usuwam plik: ${LIST_ELEM}"
        rm -r ${SOURCE_DIR}/${LIST_ELEM}
    fi

done

echo ""
# +0.5 – jeżeli jakiegoś pliku nie ma na liście, ale jest plikiem, to przenosimy go do TARGET_DIR
# +0.5 – jeżeli jakiegoś  pliku nie ma na liście, ale jest katalogiem, to kopiujemy go do TARGET_DIR z zawartością
#   czyli: jeśli nie został usunięty w poprzednim kroku to wykonujemy wlasciwa operacje

for FILE in ${SOURCE_DIR}/*; do
 
    if [[ -f ${FILE} ]]; then
        echo "Przenosze plik: ${FILE} do ${TARGET_DIR}"
        mv ${FILE} ${TARGET_DIR}
    fi

    if [[ -d ${FILE} ]]; then
        echo "Kopiuje plik - katalog: ${FILE} do ${TARGET_DIR}"
        cp -r ${FILE} ${TARGET_DIR}
    fi    
done

echo ""
# +1.0  – jeżeli po zakończeniu operacji są jeszcze jakieś pliki w katalogu SOURCE_DIR to:
# piszemy np. „jeszcze coś zostało” na konsolę oraz
# jeżeli co najmniej 2 pliki, to wypisujemy: „zostały co najmniej 2 pliki”
# jeżeli więcej niż 4, to wypisujemy: „zostało więcej niż 4 pliki” (UWAGA: 4, to też więcej niż 2)
# jeżeli nie więcej, niż 4, ale co najmniej 2, to też coś piszemy
# Jeżeli nic nie zostało, to informujemy o tym słowami np. „tu był Kononowicz”

COUNT=$(ls ${SOURCE_DIR} | wc -w)

if [[ ${COUNT} -gt 0 ]]; then
    echo "Jeszcze cos zostalo! Ilosc plikow w ${SOURCE_DIR}: ${COUNT}"
    
    if [[ ${COUNT} -ge 2 ]]; then
        echo "Zostaly co najmniej 2 pliki!"
    fi

    if [[ ${COUNT} -gt 4 ]]; then
        echo "Zostaly wiecej niz 4 pliki!"
    fi

    if [[ ${COUNT} -ge 2 ]] && [[ ${COUNT} -le 4 ]]; then
        echo "Zostaly 2, 3 lub 4 pliki!"
    fi

else
    echo "Nic nie zostalo!"
fi

echo ""
# +0.5 – wszystkie pliki w katalogu TARGET_DIR muszą mieć odebrane prawa do edycji
for FILE in ${TARGET_DIR}/*; do
    chmod -w -R ${FILE} 
    echo "Odebrano prawo do edycji plikowi ${FILE}!"
    # odebranie prawa do zapisu (czyli edycji)
    # ew. mozna uzyc: chattr +i ${FILE}
done
  
echo ""
# +0.5 – po wszystkich spakuj katalog TARGET_DIR i nazwij bakap_DATA.zip, 
# gdzie DATA to dzień uruchomienia skryptu w formacie RRRR-MM-DD

zip_file_name=bakap_"`date +"%Y-%m-%d"`"
echo "Nazwa archiwum: ${zip_file_name}.zip"
zip -r ${zip_file_name}.zip ${TARGET_DIR}