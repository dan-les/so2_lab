#!/bin/bash -eu
# Daniel Lesniewicz, 250996

# We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/
echo "----- 1 -----"
for FILE in "data/groovies"/*; do
     FILE_CONTENT=$(cat ${FILE} | sed -i 's|\$HEADER\$|/temat/|g' ${FILE})
     # -i <-- w tym samem pliku
     #  g <-- nie tylko pierwsze wystpienie
     echo "Przetorzony plik: ${FILE}"
done


# We wszystkich plikach w katalogu ‘groovies’ po każdej linijce z 'class' dodać 'String marker = '/!@$%/"'
echo "----- 2 -----"
for FILE in "data/groovies"/*; do
     FILE_CONTENT=$(cat ${FILE} | sed -i 's|.*class.*|&\n    String marker = "/!@$%/"|' ${FILE})
     # *POPRAWIC* !!!!!!!!!!!! nwm czy taki string ma byc????
     echo "Przetorzony plik: ${FILE}"
done


# We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'
echo "----- 3 -----"
for FILE in "data/groovies"/*; do
    FILE_CONTENT=$(cat ${FILE} | sed -i '/Help docs:/d' ${FILE})
    # d <-- delete line
    echo "Przetorzony plik: ${FILE}"
done