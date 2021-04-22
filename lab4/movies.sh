#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-y YEAR\n\tSearch movies made after the YEAR"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m\033[0m" >&2  #NAPRAWIC!!!
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


function query_year () {
    # Returns list of movies from ${1} with ${2} in year slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}
    local CURRENT_YEAR=$(date +'%Y')
    local COUNTER=${QUERY}

    local RESULTS_LIST=()
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
    # TODO: replace first line of equals signs

    # TODO: change 'Author:' into <Author>
    # TODO: change others too

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

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



#ANY_ERRORS=false   #POPRAWIC
FILE_4_SAVING_RESULTS=result
while getopts ":hd:t:y:a:f:x" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
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
        FILE_4_SAVING_RESULTS=${OPTARG}
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=${OPTARG}
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        # ANY_ERRORS=true   #POPRAWIC
        exit 1
        ;;
  esac
done

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

 
GIVEN_YEAR=${QUERY_YEAR}
if ${SEARCHING_YEAR:-false}; then
    MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${GIVEN_YEAR}")
fi



if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo "Found 0 movies :-("
    exit 0
fi

if ${SAVE_FILE:-false}; then

    echo "${FILE_4_SAVING_RESULTS}"
     
    FILE=results.txt
    if [[ ${FILE_4_SAVING_RESULTS: -4} == ".txt" ]]; then
        FILE=${FILE_4_SAVING_RESULTS}

    elif [[ ! ${FILE_4_SAVING_RESULTS: -4} == ".txt" ]]; then
        FILE="${FILE_4_SAVING_RESULTS}.txt"
    fi

    echo "${FILE}"

    # FILE_EXTENSION=${FILE_NAME_WITH_EXTENSION##*.}
    # if [[ ! -n ${FILE_4_SAVING_RESULTS} ]]; then
    # FILE="results.txt"

    # elif [[ ${FILE_4_SAVING_RESULTS} == "" ]]; then
    # FILE="${FILE_NAME}.txt"

    # else
    # FILE="${FILE_4_SAVING_RESULTS}"
    # fi
 

    #echo ${FILE_4_SAVING_RESULTS2}
    print_movies "${MOVIES_LIST}" "raw" > "${FILE}"
fi


# if [[ "${FILE_4_SAVING_RESULTS:-""}" == "" ]]; then
#         print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
#     else
#         # TODO: add XML option
#         print_movies "${MOVIES_LIST}" "raw" | tee "${FILE_4_SAVING_RESULTS}"
        
# fi

print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"


