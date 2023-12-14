Scripts to filter and sort .bib files

# `fsbib.sh`

This script serves two purposes: 
* sort a `.bib` file based on the entry keys
* filter a `.bib` file based on the citations present in a `.tex` file. This returns a smaller `.bib` file, containing only the entries cited in the `.tex` file

Usage
1) `chmod u+x` to make this script executable
2) `/fsbib.sh [-fs] bibfile [texfile] [output_bibfile]`
