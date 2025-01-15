#!/bin/bash
input_file="$1"

if [[ -z "$input_file" ]]; then
    echo "Usage: ./split_vcards.sh <filename.vcf>"
    exit 1
fi

if [[ ! -f "$input_file" ]]; then
    echo "Error: File not found!"
    exit 1
fi

output_dir="split_vcards"
mkdir -p "$output_dir"

csplit -z -f "$output_dir/vcard_" -b "%03d.vcf" "$input_file" '/^BEGIN:VCARD/' '{*}'

echo "vCards split into $output_dir directory."