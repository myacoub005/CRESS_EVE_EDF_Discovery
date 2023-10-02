#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/download.log

module load ncbi_datasets

datasets download genome accession --inputfile ACC.txt --include protein,gff3,cds

unzip ncbi_dataset.zip
