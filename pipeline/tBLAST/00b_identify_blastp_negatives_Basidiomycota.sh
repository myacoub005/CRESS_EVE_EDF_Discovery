#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/ID_negatives.log

# We need to extract a list of genomes where EVEs are not identified in the annotation
# We'll call this list Viral_negatives.csv

PHYLUM=Basidiomycota
METADATA=metadata

cut -d "," -f2 Results/$PHYLUM/${PHYLUM}_EVE_hits.csv > Results/$PHYLUM/${PHYLUM}_Assemblies_with_CRESS_Hits.txt
cat Results/Basidiomycota/Basidiomycota_Assemblies_with_CRESS_Hits.txt | sort | uniq > Results/$PHYLUM/${PHYLUM}_Assemblies_with_CRESS_Hits_NR.txt
#cut -d "," -f1 Results/TRUE_CAP_Blastp_hits.csv >> Results/Assemblies_with_CRESS_Hits.txt
cut -d "," -f5 $METADATA/Basidiomycota_NCBI_ACC.csv > $METADATA/${PHYLUM}_ACC.txt

grep -Fxvf Results/$PHYLUM/${PHYLUM}_Assemblies_with_CRESS_Hits_NR.txt $METADATA/Basidiomycota_ACC.txt > Results/$PHYLUM/${PHYLUM}_Viral_negatives.txt

grep -f Results/$PHYLUM/${PHYLUM}_Viral_negatives.txt $METADATA/Basidiomycota_NCBI_ACC.csv > Results/$PHYLUM/${PHYLUM}_Viral_Negatives.csv

#subset the metadata to hunt for Eves in the genomes without Blastp hits

grep -f Results/Basidiomycota/Basidiomycota_Viral_negatives.txt metadata/Basidiomycota_NCBI_ACC.csv > metadata/Basidiomycota_NCBI_ACC_BlastpNegatives.csv
