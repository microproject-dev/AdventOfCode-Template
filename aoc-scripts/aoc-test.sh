#!/usr/bin/env bash

DAY=${AOC_DAY:=""}
LANGUAGE=${AOC_LANGUAGE:=Python}

# Script directory
DIR=$1
shift

PART_A=""
PART_B=""

# Parse remaining options
while [[ $# -gt 0 ]]; do
    case $1 in
        --day)
            DAY="$2"
            shift 2
            ;;
        --lang)
            LANGUAGE="$2"
            shift 2
            ;;
        --partA)
            PART_A=true
            shift
            ;;
        --partB)
            PART_B=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            exit 2
            ;;
    esac
done

if [ -z "$DAY" ] 
then
    echo "Error: No day found in env or provided"
    exit 2
fi

if [ -z "$LANGUAGE" ] 
then
    echo "Error: No language found in env or provided"
    exit 2
fi

source $DIR/aoc-scripts/aoc-${LANGUAGE}-functions.sh

echo "AOC_DAY=$DAY" > ${DIR}/.aoc_current
echo "AOC_LANGUAGE=$LANGUAGE" >> ${DIR}/.aoc_current

DAY_SLUG=$(printf "day%02d-%s" $DAY $LANGUAGE)

if [ ! -e  "$DIR/$DAY_SLUG" ]
then
    echo "$DAY_SLUG Does not exist. Aborting."
    exit 1
fi

if [ -z "$PART_A" -a -z "$PART_B" ]
then
    test_solution $DAY_SLUG all
elif [ $PART_A ]
then
    test_solution $DAY_SLUG partA
elif [ $PART_B ]
then
    test_solution $DAY_SLUG partB
fi