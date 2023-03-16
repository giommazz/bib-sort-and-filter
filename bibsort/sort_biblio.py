################################################################
# This .sh script sorts .bib file by author using bibtool, 
#   then saves the sorted version to a new file.
# Arguments:
#    - input .bib file to be sorted
#    - optional output file name for the sorted bibliography
# Note: requires bibtexparser installed
################################################################

import bibtexparser

# Prompt the user for the input .bib file name
input_file = input('Enter the name of the input .bib file: ')
output_file = input('Enter the name of the output .bib file or press Enter (in this case, the sorted .bib file will be \"sorted_biblio.bib\"): ')

# Read the input .bib file
with open(input_file) as bibtex_file:
    bib_database = bibtexparser.load(bibtex_file)

# Sort the entries by author
def sort_by_author(entry):
    author = entry.get('author', '')
    if author:
        last_name = author.split(',')[-1].strip()
        return last_name.lower()
    else:
        return ''

bib_database.entries.sort(key=sort_by_author)

# Write the sorted entries to a new .bib file
if not output_file:
    output_file = 'sorted_biblio.bib'

with open(output_file, 'w') as bibtex_file:
    bibtexparser.dump(bib_database, bibtex_file)

print('Sorted entries written to ' + output_file)
