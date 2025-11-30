#!/usr/bin/env bash

LANGUAGE=${AOC_LANGUAGE:=Python}

# Script directory
DIR=$1
shift

source $DIR/aoc-scripts/aoc-${LANGUAGE}-functions.sh

DAY=${AOC_DAY:=""}
FORCE=""

# Parse remaining options
while [[ $# -gt 0 ]]; do
    case $1 in
        --day)
            DAY="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            exit 2
            ;;
    esac
done

if [ -z "$DAY" ] 
then
    echo "Error: No day specified on init"
    show_usage
    exit 2
fi

if [ -z "$LANGUAGE" ] 
then
    echo "Error: No language found in env or provided"
    exit 2
fi

# Export parsed values for subscripts
echo "AOC_DAY=$DAY" > ${DIR}/.aoc_current

DAY_SLUG=$(printf "day%02d-%s" $DAY $LANGUAGE)

if [ -e  "$DIR/$DAY_SLUG" ]
then
    if [ $FORCE ]
    then
        echo "$DAY_SLUG already exists, use of LETHAL FORCE AUTHORIZED"
        rm -rf $DIR/$DAY_SLUG
    else
        echo "$DAY_SLUG already exists, use of LETHAL FORCE NOT AUTHORIZED. Aborting."
        exit 1
    fi
fi

echo "Creating $DAY_SLUG"
mkdir $DIR/$DAY_SLUG

echo "Running language specific initialization"

configure_template $DAY_SLUG $DIR/templates/template-${LANGUAGE}