#!/usr/bin/env bash

source .aocrc

LANGUAGE=${AOC_LANGUAGE:=Python}

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case $LANGUAGE in
    zig)
        # Valid command
        ;;
    *)
        echo "Error: Language: $LANGUAGE" unsupported >&2
        show_usage
        exit 2
        ;;
esac

DAY=${AOC_DAY:=""}
FORCE=false

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
echo "AOC_DAY=$DAY" > ${SCRIPT_DIR}/.aoc_current

echo "Some init stuff"