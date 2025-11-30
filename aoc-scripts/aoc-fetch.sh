#!/usr/bin/env bash

YEAR=${AOC_YEAR:=2024}

FORCE=false
WAIT=false

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
        --wait)
            WAIT=true
            shift
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            show_usage
            exit 2
            ;;
    esac
done

if [ -z "$DAY" ] 
then
    echo "Error: No day found in env or provided"
    exit 2
fi

echo "Some fetching stuff"