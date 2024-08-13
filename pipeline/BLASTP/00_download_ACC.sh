#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/download.log

module load ncbi_datasets

#For the ncbi genome assemblies you need to go to taxonomy browser, select the groups of organsisms (in this case fungi), select genomes, and download the table

datasets download genome accession --inputfile ACC.txt --include protein,gff3,gbff,genome

unzip ncbi_dataset.zip

# Also get JGI genomes for additional screen

mkdir -p JGI_pep

cd JGI_pep

ln -s /bigdata/stajichlab/shared/projects/1KFG/2021/JGI_freeze_2021-08-31/pep
