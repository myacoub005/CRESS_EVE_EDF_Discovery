#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/download.log

module load ncbi_datasets

#For the ncbi genome assemblies you need to go to taxonomy browser, select the groups of organsisms (in this case fungi), select genomes, and download the table

cd Foxy_orthology

datasets download genome accession --inputfile Foxy_ACC.txt --include cds

unzip ncbi_dataset.zip
