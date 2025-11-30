source .aocrc

LANGUAGE=${AOC_LANGUAGE:=Python}

PART_A=false
PART_B=false

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

echo "Some testings stuff"