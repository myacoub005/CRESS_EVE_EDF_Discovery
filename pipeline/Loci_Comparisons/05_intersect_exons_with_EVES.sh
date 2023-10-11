#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/merge_exons_EVEs.%a.log

module load bedtools

OUTDIR=EVE_EXONS
mkdir -p $OUTDIR
INDIR=ncbi_dataset/data
INTRONS=INTRONS

mkdir -p $INTRONS

#intersect viral genes with exons to get number of exons per virus

#echo -e "chr\tstart\tstop\tcolumn\tcolumn1\tstrand\tstart1\tstop1\tcommas\tcolumn3\tMethylation\tscaffold\tgstart\tgend\tTE_ID" | cat - $OUTDIR/JEL423_TEs_5mC.bed > JEL423_TE_genes_5mC.bed

IFS=,
tail -n +2 NCBI_EVE_hits.csv | sed -n ${N}p | while read ACC PROT EVE HOST FUNCT

do

bedtools intersect -a $INDIR/$ACC/*.exons.bed -b $INDIR/${ACC}/${ACC}.${HOST}.Viral_genes.bed -wa -wb > $OUTDIR/${ACC}.${HOST}.EVE_exons.bed

awk -F '\t' '{print $10}' $OUTDIR/${ACC}.${HOST}.EVE_exons.bed | sort | uniq -c > $OUTDIR/${ACC}.${HOST}.EVE_exons.counts.txt

awk '{print ($1 - 1) " " $2}' $OUTDIR/${ACC}.${HOST}.EVE_exons.counts.txt > $INTRONS/${ACC}.${HOST}.EVE.introns.counts.txt

done
