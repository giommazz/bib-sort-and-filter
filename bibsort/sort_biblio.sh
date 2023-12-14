########################################################
#   Usage
#   1) `chmod u+x` to make this script executable
#   2) ./fsbib.sh [-fs] bibfile [texfile] [output_bibfile]"
########################################################

# This bash script can
#   a) parse a .tex file to retrieve the cited .bib entries, and filter a big .bib file to only show the cited entries
#   b) sorts .bib files (by key, using `bibtool`)
# Inputs:
#   - input .tex file to be sorted
#   - optional output file name for the sorted bibliography
#

#!/bin/bash

# Function to display usage instructions
show_usage() {
    echo "Usage: $0 [options] bibfile [texfile] [output_bibfile]"
    echo "Options:"
    echo "  -f    Filter only"
    echo "  -s    Sort only"
    echo "  -fs   Filter and sort (same as -sf)"
}

# Function to filter the bibliography
filter_bib() {
    grep -o '\\cite{[^}]*}' "$texfile" | cut -d '{' -f2 | tr -d '}' | sort | uniq > cited_keys.txt
    awk -F'{' 'NR==FNR { keys[$1]; next } /^@/ { key = $2; key = substr(key, 1, index(key, ",") - 1); printEntry = (key in keys) } { if (printEntry) print }' cited_keys.txt "$bibfile" > "$outputfile"
    rm cited_keys.txt
    echo "Filtered bibliography file saved as $outputfile"
}

# Function to sort the bibliography
sort_bib() {
    # Check if bibtool is installed
    if ! command -v bibtool > /dev/null; then
        echo "Error: bibtool is not installed or not in your PATH. Please run"
        echo "    sudo apt-get update"
        echo "    sudo apt-get install bibtool"
        echo ""
        exit 1
    fi

    # Sort using bibtool
    bibtool -s --sort.format="{%N($author)}" -i "$bibfile" -o "$outputfile"
    echo "Sorted bibliography file saved as $outputfile"
}

# Check for minimum number of arguments
if [ "$#" -lt 2 ]; then
    show_usage
    exit 1
fi

# Parse options
option=$1
bibfile=$2
texfile=${3:-""} # Optional .tex file
outputfile=${4:-"new_bib.bib"} # Default output file name if not provided

case $option in
    -f)
        if [ -z "$texfile" ]; then
            echo "Error: .tex file is required for filtering."
            show_usage
            exit 1
        fi
        filter_bib
        ;;
    -s)
        sort_bib
        ;;
    -fs|-sf)
        if [ -z "$texfile" ]; then
            echo "Error: .tex file is required for filtering."
            show_usage
            exit 1
        fi
        filter_bib
        sort_bib
        ;;
    *)
        echo "Invalid option: $option"
        show_usage
        exit 1
        ;;
esac

exit 0
