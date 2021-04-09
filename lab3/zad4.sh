#!/bin/bash -eu
# Daniel Lesniewicz, 250996

# "Zadanie dla chętnich: napisz jednolinijkowca, któy klonuje (robi echo) repozytoria z ludzie.csv, po SSH, do katalogow imie_nazwisko (malymi literami). Zwróccie uwagę, że niektóre repozytoria mają '.git' inne nie, to trzeba zunifikować! (dam za to +0.5)"

 for REPO in $(cat data/ludzie.csv | sed 1d | cut -d',' -f1,3 | sed 's|http*://github.com/|git@github.com:|' | sed 's|https://github.com/|git@github.com:|' | sed 's| |_|' | sed 's|.*,|\L&|g'); do
    echo "Klonuje po SSH [do_folderu,adres]: ${REPO}";
 done