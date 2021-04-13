#!/bin/bash -eu
# Daniel Lesniewicz, 250996

# Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą. 
# Wyniki zapisz na standardowe wyjście błędów.
echo "----- 1 -----"
cat ./data/yolo.csv | sed 1d | cut -d',' -f1,2,3 | grep -E "^[0-9]{0,}[13579]," 1>&2

# Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99. N
# ie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). Wyniki zapisz na standardowe wyjście błędów
echo "----- 2 -----"
cat ./data/yolo.csv | sed 1d | cut -d',' -f3,7 | grep -E '\$[259]\.[9]{2}[BM]' 1>&2

# Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze. 
# Wyniki zapisz na standardowe wyjście błędów"
echo "----- 3 -----"
cat ./data/yolo.csv | sed 1d | cut -d',' -f6 | grep -E "^[0-9]\.[0-9]\.[0-9]{1,3}\.[0-9]{1,3}" 1>&2