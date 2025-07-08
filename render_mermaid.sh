#!/bin/bash

# Render Mermaid diagram script
# Converts .mmd files to PNG or SVG format using a Mermaid server

# Default values
OUTPUT_TYPE="png"
OUTPUT_DIR="$(pwd)"
SERVER_URL="http://localhost:80"
OUTPUT_NAME=""

# Function to show usage
show_usage() {
    cat <<EOF
Usage: $0 [OPTIONS] MMD_FILE

Render Mermaid diagram

Arguments:
  MMD_FILE              Path to Mermaid script file

Options:
  -t, --type TYPE       Output type (png or svg) [default: png]
  -o, --output-dir DIR  Output directory [default: current directory]
  -n, --name NAME       Output file name (without extension)
  -s, --server URL      Server URL [default: http://localhost:80]
  -h, --help           Show this help message

Examples:
  $0 diagram.mmd
  $0 -t svg -o output/ diagram.mmd
  $0 --name my_diagram --type png diagram.mmd
EOF
}

# Function to validate server URL
validate_server_url() {
    local url="$1"
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "Error: Server URL must start with http:// or https://" >&2
        exit 1
    fi
}

# Function to clean filename (replace spaces with underscores)
clean_filename() {
    echo "$1" | tr ' ' '_'
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    -t | --type)
        if [[ "$2" != "png" && "$2" != "svg" ]]; then
            echo "Error: Output type must be 'png' or 'svg'" >&2
            exit 1
        fi
        OUTPUT_TYPE="$2"
        shift 2
        ;;
    -o | --output-dir)
        OUTPUT_DIR="$2"
        shift 2
        ;;
    -n | --name)
        OUTPUT_NAME="$2"
        shift 2
        ;;
    -s | --server)
        SERVER_URL="$2"
        shift 2
        ;;
    -h | --help)
        show_usage
        exit 0
        ;;
    -*)
        echo "Error: Unknown option $1" >&2
        show_usage >&2
        exit 1
        ;;
    *)
        if [[ -z "$MMD_FILE" ]]; then
            MMD_FILE="$1"
        else
            echo "Error: Multiple input files specified" >&2
            exit 1
        fi
        shift
        ;;
    esac
done

# Check if input file is provided
if [[ -z "$MMD_FILE" ]]; then
    echo "Error: No input file specified" >&2
    show_usage >&2
    exit 1
fi

# Check if input file exists
if [[ ! -f "$MMD_FILE" ]]; then
    echo "Error: Input file '$MMD_FILE' not found" >&2
    exit 1
fi

# Validate server URL
validate_server_url "$SERVER_URL"

# Read Mermaid content from file
if ! MERMAID_CONTENT=$(cat "$MMD_FILE" 2>/dev/null); then
    echo "Error: Failed to read input file '$MMD_FILE'" >&2
    exit 1
fi

# Prepare URL with parameters
URL_WITH_PARAMS="${SERVER_URL}/generate?type=${OUTPUT_TYPE}"

# Create output directory if it doesn't exist
if ! mkdir -p "$OUTPUT_DIR" 2>/dev/null; then
    echo "Error: Failed to create output directory '$OUTPUT_DIR'" >&2
    exit 1
fi

# Determine output filename
if [[ -n "$OUTPUT_NAME" ]]; then
    OUTPUT_BASENAME="$OUTPUT_NAME"
else
    # Extract basename without extension
    OUTPUT_BASENAME=$(basename "$MMD_FILE" .mmd)
fi

# Clean filename and create full output path
OUTPUT_BASENAME=$(clean_filename "$OUTPUT_BASENAME")
OUTPUT_PATH="${OUTPUT_DIR}/${OUTPUT_BASENAME}.${OUTPUT_TYPE}"

# Make HTTP POST request using curl
if ! curl -s \
    -X POST \
    -H "Content-Type: text/plain" \
    -d "$MERMAID_CONTENT" \
    "$URL_WITH_PARAMS" \
    -o "$OUTPUT_PATH"; then
    echo "Error: Failed to connect to server or save output" >&2
    exit 1
fi

# Check if output file was created and has content
if [[ ! -s "$OUTPUT_PATH" ]]; then
    echo "Error: Output file is empty or was not created" >&2
    exit 1
fi

echo "Diagram saved to $OUTPUT_PATH"
