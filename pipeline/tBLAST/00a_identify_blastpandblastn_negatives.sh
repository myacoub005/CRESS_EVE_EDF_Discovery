#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/ID_negatives.log

# We need to extract a list of genomes where EVEs are not identified in the annotation
# We'll call this list Viral_negatives.csv

cut -d "," -f1 Results/TRUE_REP_Blastp_hits.csv > Results/Assemblies_with_CRESS_Hits.txt
cut -d "," -f1 Results/TRUE_CAP_Blastp_hits.csv >> Results/Assemblies_with_CRESS_Hits.txt
cut -d "," -f6 ReferenceGenomes.csv > ACC.txt

grep -Fxvf Results/Non-redundant_ALL_CRESS_hits.txt ACC.txt > TRUE_Viral_negatives.txt

grep -f TRUE_Viral_negatives.txt ReferenceGenomes.csv > TRUE_Viral_Negatives.csv


