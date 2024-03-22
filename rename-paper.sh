#!/bin/bash

TMP=/tmp/rename-paper.bib
BIORXIV_MISID="Transcriptional profiling of lung cell populations in idiopathic pulmonary arterial hypertension."
SCIREP_MISID="Charge transport mechanism in networks of armchair graphene nanoribbons."
MAX_TITLE_LENGHT=150

# Function to display usage information
usage() {
    echo -e "\n++++++++++++ Usage: $(basename "$0") <input_file_mask>"
    echo -e "++++++++++++ Example: $(basename "$0") '*.pdf'\n"
    exit 1
}

process_file() {

    rm -f "$TMP"
    # Get bib information and save to $TMP
    cb2bib --doc2bib "$1" "$TMP" --sloppy
    
    # Extract title, first author and year using sed and awk
    local title
    title=$(sed -n 's/^\s*title\s*=\s*{{\(.*\)}}.*/\1/p' "$TMP")
    local author
    author=$(sed -n 's/\s*author\s*=\s*{\(.*\)}.*/\1/p' "$TMP" | awk -F' and ' '{print $1;}')
    local year
    year=$(sed -n 's/^\s*year\s*=\s*{\(.*\)}.*/\1/p' "$TMP")
    
    if [[ "$title" == "$BIORXIV_MISID" ]]; then
        echo -e "\n++++++++++++ Possibly BioRxiv paper, skipping\n"
        return
    fi
    
    if [[ "$title" == "$SCIREP_MISID" ]]; then
        echo -e "\n++++++++++++ Possibly Scientifc Reports paper, skipping\n"
        return
    fi
    
    local new_name
    new_name=$(dirname "$1")/"${title:0:MAX_TITLE_LENGHT} - $author - $year.pdf"
    
    if [[ -f "$new_name" ]]; then
        echo -e "\n++++++++++++ File ""$new_name"" already exists, skipping\n"
        return
    fi

    echo -e "\n++++++++++++ Renaming ""$1"" to ""$new_name""\n"
    mv "$1" "$new_name"
}

# Main function to iterate over input files
main() {
    # Check if input files are provided
    if [ $# -eq 0 ]; then
        usage
    fi
    
    # Iterate over input files
    for file in "$@"; do
        # Check if the file exists
        if file -b --mime-type "$file" | grep -q "application/pdf"; then
            process_file "$file"
        else
            echo -e "\n++++++++++++ Not a PDF file, skipping: $file\n"
        fi
    done
}

main "$@"
