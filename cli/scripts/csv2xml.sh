#!/bin/bash

# Input and output files
INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [[ -z "$INPUT_FILE" ]]; then
    echo "Usage: $0 <input.csv> <output.xml>"
    exit 1
fi

if [[ -z "$OUTPUT_FILE" ]]; then
    echo "Usage: $0 <input.csv> <output.xml>"
    exit 1
fi

if [[ ! -f "$OUTPUT_FILE" ]]; then
    echo "Error: File not found!"
    exit 1
fi

# Check if the input file exists
if [[ ! -f $INPUT_FILE ]]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

# Start the XML output
echo '<?xml version="1.0" encoding="UTF-8"?>' > "$OUTPUT_FILE"
echo '<contacts>' >> "$OUTPUT_FILE"

# Read the CSV file line by line
IFS=","
HEADER=true
while read -r line; do
    # Handle headers
    if $HEADER; then
        HEADER=false
        # Save the headers into an array
        read -a headers <<< "$line"
        continue
    fi

    # Process data rows
    echo "  <contact>" >> "$OUTPUT_FILE"
    read -a fields <<< "$line"
    for i in "${!headers[@]}"; do
        # Strip whitespace from headers and fields
        header=$(echo "${headers[$i]}" | xargs)
        field=$(echo "${fields[$i]}" | xargs)
        # Write XML element
        echo "    <$header>$field</$header>" >> "$OUTPUT_FILE"
    done
    echo "  </contact>" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

# End the XML output
echo '</contacts>' >> "$OUTPUT_FILE"

echo "XML file created: $OUTPUT_FILE"