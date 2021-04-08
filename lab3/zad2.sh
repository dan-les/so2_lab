#!/bin/bash -eu
# Daniel Lesniewicz, 250996

# Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą. 
# Wyniki zapisz na standardowe wyjście błędów.
echo "----- 1 -----"
cat ./data/yolo.csv | cut -d ',' -f1,2,3 2> /dev/null | grep -P "[13579],"

# Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99. N
# ie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). Wyniki zapisz na standardowe wyjście błędów
echo "----- 2 -----"
cat ./data/yolo.csv | cut -d ',' -f3,7 2> /dev/null | grep '$2.99[B,M]\|$5.99[B,M]\|$9.99[B,M]'

# Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze. 
# Wyniki zapisz na standardowe wyjście błędów"
echo "----- 3 -----"
cat ./data/yolo.csv | cut -d ',' -f6 2> /dev/null | grep -P "^[0-9]\.[0-9]\.[0-9]{1,3}\.[0-9]{1,3}"