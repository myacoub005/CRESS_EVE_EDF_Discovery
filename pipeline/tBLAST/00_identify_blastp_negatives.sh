#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/ID_negatives.log

# We need to extract a list of genomes where EVEs are not identified in the annotation
# We'll call this list Viral_negatives.csv

cut -d "," -f1 Results/TRUE_REP_Blastp_hits.csv > Results/Assemblies_with_CRESS_Hits.txt
cut -d "," -f1 Results/TRUE_CAP_Blastp_hits.csv >> Results/Assemblies_with_CRESS_Hits.txt
cut -d "," -f6 ReferenceGenomes.csv > ACC.txt

grep -Fxvf Results/Assemblies_with_CRESS_Hits.txt ACC.txt > Viral_negatives.txt

grep -f Viral_negatives.txt ReferenceGenomes.csv > Viral_Negatives.csv


