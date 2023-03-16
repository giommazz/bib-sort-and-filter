########################################################
#   1) run chmod u+x to make this script executable
#   2) ./sort_biblio.sh
########################################################
:`
This .sh script sorts .bib file by author using `bibtool`, then saves the sorted version to a new file. 
Inputs: 
    - 1: input .bib file to be sorted
    - 2: (optional) output file name for the sorted bibliography
`

#! /bin/bash

echo "This script will sort a .bib file of your choice in alphabetical order.\n\n"

# check if bibtool is installed, i.e., available in the current shell environment
if ! command -v bibtool > /dev/null; then
    # print error message to standard error (>&2) and include instructions to install bibtool using sys package manager
    echo "Error: bibtool is not installed or not in your PATH. Please install it by\n\tsudo apt-get update\n\tsudo apt-get install bibtool\n(or using your package manager)." >&2
    exit 1
fi

echo "This script will sort a .bib file of your choice in alphabetical order.\n\n"

# check if argument is empty OR number of arguments is greater than 2 (script name and two expected arguments)
if [ "$1" == "" ] || [ $# -gt 2 ]; then
    echo 'Error: Specify .bib file you want to sort!'
    echo 'Usage: ./sort_biblio.sh <input_bib_file> [output_bib_file]'
    exit 1
fi

echo Sorting bibliography file

# use bibtool to sort .bib file (1) by author, and write result to new file `sorted_biblio.bib`
bibtool -s --sort.format="%N(author)" "$1" > sorted_biblio.bib


# if bibtool returns success status `$? -eq 0`
if [ $? -eq 0 ]; then
    # remove unsorted file
    rm "$1"
    # rename `sorted_biblio.bib` to output file specified by $2
    mv sorted_biblio.bib "$2"
    echo "Sorted bibliography file saved as $2"
else
    echo "Error: Failed to sort bibliography file $1"
fi

exit 0
