#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/bedtools_nuc.%a.log

module load bedtools
module load samtools

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

IFS=,
tail -n +2 ReferenceGenomes.csv | sed -n ${N}p | while read GENUS SP STRAIN BS BP ACC SIZE GC SCAFFOLDS CDS
do

OUTNAME=$ACC.$GENUS.$SP

#mv $INDIR/$ACC/*genomic.fna $INDIR/$ACC/${OUTNAME}.genomic.fna

samtools faidx $INDIR/$ACC/*genomic.fna

bedtools makewindows -g $INDIR/$ACC/*genomic.fna.fai -w 50 > $INDIR/$ACC/${OUTNAME}.50w.bed

bedtools nuc -fi $INDIR/$ACC/*genomic.fna -bed $INDIR/$ACC/${OUTNAME}.50w.bed > $INDIR/$ACC/${OUTNAME}.GC_50.tsv

done
