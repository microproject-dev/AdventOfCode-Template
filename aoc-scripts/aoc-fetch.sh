#!/usr/bin/env bash

DAY=${AOC_DAY:=""}
YEAR=${AOC_YEAR:=2024}
LANGUAGE=${AOC_LANGUAGE:=Python}

# Script directory
DIR=$1
shift

FORCE=""
WAIT=""

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

if [ -z "$LANGUAGE" ] 
then
    echo "Error: No language found in env or provided"
    exit 2
fi

if [ -z "$AOC_SESSION" ] 
then
    echo "Error: No session found in env"
    exit 2
fi

DAY_SLUG=$(printf "day%02d-%s" $DAY $LANGUAGE)

if [ ! -e  "$DIR/$DAY_SLUG" ]
then
    echo "$DAY_SLUG Does not exist. Aborting."
    exit 1
fi

echo "Creating input location"
if [ ! -e  "$DIR/$DAY_SLUG/input" ]
then
    mkdir $DAY_SLUG/input
fi

if [ -e  "$DIR/$DAY_SLUG/input/input.txt" ]
then
    if [ $FORCE ]
    then
        echo "$DIR/$DAY_SLUG/input/input.txt already exists, use of LETHAL FORCE AUTHORIZED"
        rm -f $DIR/$DAY_SLUG/input/input.txt
    else
        echo "$DIR/$DAY_SLUG/input/input.txt already exists, use of LETHAL FORCE NOT AUTHORIZED. Aborting."
        exit 1
    fi
fi

# Wait until puzzle is available (midnight EST on the given day)
    
# Puzzle releases at midnight EST (UTC-5, or UTC-4 during DST)
# For simplicity, we'll use EST (UTC-5) since AoC runs in December (no DST)
release_date="${YEAR}-12-$(printf "%02d" "$DAY")"

# Get release timestamp in EST
# We need to convert EST midnight to our local time
release_epoch=""
if date --version >/dev/null 2>&1; then
    # GNU date
    release_epoch=$(TZ="America/New_York" date -d "${release_date} 00:00:00" +%s 2>/dev/null)
else
    # BSD date (macOS)
    release_epoch=$(TZ="America/New_York" date -j -f "%Y-%m-%d %H:%M:%S" "${release_date} 00:00:00" +%s 2>/dev/null)
fi

if [[ -z "$release_epoch" ]]; then
    echo "Error: Could not calculate release time" >&2
    return 1
fi

now_epoch=$(date +%s)

# Calculate wait time
wait_seconds=$((release_epoch - now_epoch))

if [ $wait_seconds -gt 0 -a $WAIT ]
then
    # Format release time for display
    release_display=""
    if date --version >/dev/null 2>&1; then
        # GNU date
        release_display=$(date -d "@${release_epoch}" "+%B %d, %Y at %I:%M:%S %p %Z")
    else
        # BSD date
        release_display=$(date -r "${release_epoch}" "+%B %d, %Y at %I:%M:%S %p %Z")
    fi

    echo "Day ${DAY} not available yet."
    echo "Waiting until ${release_display}... ($wait_seconds)"
    echo "(Press Ctrl+C to cancel)"

    # Set up trap for clean exit on Ctrl+C
    trap 'echo ""; echo "Wait cancelled."; exit 130' INT

    # Sleep until release time
    sleep "$wait_seconds"

    echo "Release time reached! Attempting to fetch..."

    # Remove trap
    trap - INT
elif [ $wait_seconds -gt 0 ]
then
    echo "Likely too early, trying anyway"
fi

echo "Fetching input"
http_code=$(curl -s -w "%{http_code}" -H "Cookie: session=${AOC_SESSION}" \
    "https://adventofcode.com/$YEAR/day/$DAY/input" \
    -o $DIR/$DAY_SLUG/input/input.txt)

if [[ $http_code -eq 200 ]]; then
    # Check if we got actual content (not an error message)
    if [[ -s "$DIR/$DAY_SLUG/input/input.txt" ]] && ! grep -q "Please don't repeatedly request" "$DIR/$DAY_SLUG/input/input.txt"; then
        echo "Input fetched successfully!"
        exit 0
    fi
elif [[ $http_code -eq 404 ]]; then
    echo "Puzzle not available yet (404)."
    exit 2
elif [[ $http_code -eq 400 ]]; then
    echo "Bad request (400). Puzzle may not be released yet."
    exit 2
else
    echo "Received HTTP $http_code."
    exit 2
fi