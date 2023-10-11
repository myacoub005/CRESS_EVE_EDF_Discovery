#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/subset_exon.%a.log

CPU=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPU=1
fi

N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi


INDIR=ncbi_dataset/data
OUTDIR=EVE_EXONS
INTRONS=INTRONS

mkdir -p $INTRONS

IFS=,
tail -n +2 ReferenceGenomes.csv | sed -n ${N}p | while read GENUS SP STRAIN BS BP ACC SIZE GC SCAFFOLDS CDS
do

OUTNAME=$ACC.$GENUS.$SP

$INDIR/$ACC/${OUTNAME}.exons.bed

bedtools intersect -a $INDIR/$ACC/${OUTNAME}.exons.bed -b $INDIR/${ACC}/${OUTNAME}.genes.bed -wa -wb > $OUTDIR/${ACC}.${HOST}.host.exons.bed

awk -F '\t' '{print $10}' $OUTDIR/${ACC}.${HOST}.host.exons.bed | sort | uniq -c > $OUTDIR/${ACC}.${HOST}.host.exons.counts.txt

awk '{print ($1 - 1) " " $2}' $OUTDIR/${ACC}.${HOST}.host.exons.counts.txt > $INTRONS/${ACC}.${HOST}.host.introns.counts.txt

done
