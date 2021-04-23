#!/bin/bash -eu
# Daniel Lesniewicz, 250996

# =====================================================================
#   Wykonane zostaly wszystkie zadania (shellcheck nie zwraca bledow)
# =====================================================================

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-y YEAR\n\tSearch movies made after the YEAR"
    echo -e "-R QUERY\n\tSearch movies that contains QUERY in plot"
    echo -e "-i \n\tIgnore letter size in searching by plot (param: -R)"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    # Displays error as red font
    echo -e "\e[31m\033[1m${1}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)

    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    local RESULTS_LIST=()

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    local RESULTS_LIST=()

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_plot() {
    # Returns list of movies from ${1} with ${2} in plot slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    local -r IGNORE_SIZE=${3}
    local RESULTS_LIST=()

    if ${IGNORE_SIZE}; then  
        for MOVIE_FILE in ${MOVIES_LIST}; do
            if grep "| Plot" "${MOVIE_FILE}" | grep -qE -i "${QUERY}"; then
                RESULTS_LIST+=( "${MOVIE_FILE}" )
            fi
        done
    else   
        for MOVIE_FILE in ${MOVIES_LIST}; do
            if grep "| Plot" "${MOVIE_FILE}" | grep -qE "${QUERY}"; then
                RESULTS_LIST+=( "${MOVIE_FILE}" )
            fi
        done
    fi
    echo "${RESULTS_LIST[@]:-}"
}

function query_year () {
    # Returns list of movies from ${1} which are more recent than the YEAR given in ${2}
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    local CURRENT_YEAR
    local COUNTER=${QUERY}
    local RESULTS_LIST=()
    CURRENT_YEAR=$(date +'%Y')

    for MOVIE_FILE in ${MOVIES_LIST}; do
        while [ "${COUNTER}" -le "${CURRENT_YEAR}" ] ; do
            COUNTER=$((COUNTER + 1 ))
            if grep "| Year" "${MOVIE_FILE}" | grep -q "${COUNTER}"; then
                RESULTS_LIST+=( "${MOVIE_FILE}" )
            fi
        done
        COUNTER=${QUERY}
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_xml_format () {
    local -r FILENAME=${1}
    local TEMP
    TEMP=$(cat "${FILENAME}")

    # append tag before each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+)/\0 <\/\1>/' | sed -r 's/: //g' | sed -r 's/\|.* <\//\t</g')
    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')
    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')
    # TODO: replace first line of equals signs (in fact the second line) with <movie>
    TEMP=$(echo "${TEMP}" | sed '2s/===*/<movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

IGNORE_LETTER_SIZE=false

while getopts ":hd:t:ya:R:if::x" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        IS_D_USES=true
        MOVIES_DIR=${OPTARG}
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;

    y)
        SEARCHING_YEAR=true
        QUERY_YEAR=${OPTARG}
        ;;
    f)
        SAVE_FILE=true
        FILE_4_SAVING_RESULTS=${OPTARG:-result.txt}
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=${OPTARG}
        ;;
    R)
        SEARCHING_PLOT=true
        QUERY_PLOT=${OPTARG}
        ;;
    i)
        IGNORE_LETTER_SIZE=true
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        exit 1
        ;;
  esac
done

if ${IS_D_USES:-false}; then
    echo  "You use -d options"
    if [[ -d ${MOVIES_DIR} ]]; then
        echo  "This is a directory"
    else
        echo "This is NOT a directory"
    fi
else 
    echo  "You have to use -d option"
    exit 1
fi
echo "----------------------------------------"
 

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi
 
if ${SEARCHING_YEAR:-false}; then
    GIVEN_YEAR=${QUERY_YEAR}
    MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${GIVEN_YEAR}")
fi

if ${SEARCHING_PLOT:-false}; then
    MOVIES_LIST=$(query_plot "${MOVIES_LIST}" "${QUERY_PLOT}" "${IGNORE_LETTER_SIZE}")
fi

if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo -e "Found 0 movies :-("
    exit 0
fi

if ${SAVE_FILE:-false}; then
    if [[ ${FILE_4_SAVING_RESULTS: -4} == ".txt" ]]; then
        FILE=${FILE_4_SAVING_RESULTS}

    elif [[ ! ${FILE_4_SAVING_RESULTS: -4} == ".txt" ]]; then
        FILE="${FILE_4_SAVING_RESULTS}.txt"
    fi
fi

if [[ "${FILE:-""}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" | tee "${FILE}"   
fi




