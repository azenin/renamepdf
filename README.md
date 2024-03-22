# Rename academic paper PDF to "Title - Author - year.pdf"

This script automatically extracts bibliographic information from scientific paper PDF file and renames the file as `Title - Author - year.pdf`

## Installation and requirements

- Should work on any Linux or Mac
- Install [cb2bib](https://www.molspaces.com/cb2bib/doc/installation/)

## Usage
```bash
chmod +x rename-paper.sh
./rename-paper.sh <input_file_or_file_mask>
```

Example:
```bash
./rename-paper.sh *.pdf
```

Before: `s42003-019-0290-0.pdf`

After: `Identification of 12 genetic loci associated with human healthspan. - A. Zenin - 2019.pdf`

## Known issues

1) The script can't precess BioRxiv papers and skipping them
2) The script can't precess Scientific Reports papers and skipping them
3) Sometimes paper title might be missing
