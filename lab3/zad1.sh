#!/bin/bash -eu
# Daniel Lesniewicz, 250996

# "+2.0
# Znajdź w pliku access_log zapytania, które mają frazę ""denied"" w linku
# *POPRAWIC* !!!!!!!!!!!!!!!!!!
echo "fraza denied w linku"
#c at ./data/access_log | grep -P ' /[a-z0-9A-Z_?=%^&*()@#$\-\./]* ' | grep denied

# Znajdź w pliku access_log zapytania typu POST
echo -e "\nzapytania typu POST"
# cat ./data/access_log |  grep "POST "

# Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
echo -e "\nzapytania z IP: 64.242.88.10"
# cat ./data/access_log | grep -P "^64\.242\.88\.10 "

# Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
echo -e "\nzapytania  NIEWYSŁANE z adresu IP tylko z FQDN"
OCTET="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
# cat ./data/access_log | grep -Pv "^${OCTET}\.${OCTET}\.${OCTET}\.${OCTET}"

# Znajdź w pliku access_log unikalne zapytania typu DELETE
echo -e "\nunikalne zapytania typu DELETE"
# cat ./data/access_log | grep  "DELETE" | sort -u

# Znajdź unikalnych 10 adresów IP w access_log"
echo -e "\nZnajdź unikalnych 10 adresów IP w access_log"
OCTET="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
# cat ./data/access_log | grep -Po "${OCTET}\.${OCTET}\.${OCTET}\.${OCTET}" | sort -u
# *POPRAWIC* !!!!!!!!!!!! teraz sa wszystkie 