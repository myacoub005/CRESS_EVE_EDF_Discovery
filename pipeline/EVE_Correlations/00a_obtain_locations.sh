#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/Ascomycota_obtain_locations.%a.log

OUTDIR=GC_Content/Ascomycota
mkdir -p $OUTDIR

grep -f GC_Content/Ascomycota_IDs.txt ./ncbi_dataset/Ascomycota/*tina/*/*gff | cut -d ":" -f2 > $OUTDIR/EVE_locations.gff3

awk '$3 == "gene"' $OUTDIR/EVE_locations.gff3| cut -f1,4,5 > $OUTDIR/EVE_locations.bed
