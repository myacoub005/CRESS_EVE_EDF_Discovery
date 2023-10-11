#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/get_introns.%a.log

module load samtools
module load bedtools

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

mv $INDIR/$ACC/*genomic.fna $INDIR/$ACC/${OUTNAME}.genomic.fna

samtools faidx $INDIR/$ACC/${OUTNAME}.genomic.fna

awk 'OFS="\t" {print $1, "0", $2}' $INDIR/$ACC/${OUTNAME}.genomic.fna | sort -k1,1 -k2,2n > $INDIR/$ACC/${OUTNAME}.chromSizes.bed

cat $INDIR/$ACC/${OUTNAME}.gff | awk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k4,4n -k5,5n"}' > $INDIR/$ACC/${OUTNAME}.sorted.gff 

bedtools complement -i $INDIR/$ACC/${OUTNAME}.sorted.gff -g chromSize > intergenic_sorted.bed

awk 'OFS="\t", $1 ~ /^#/ {print $0;next} {if ($3 == "exon") print $1, $4-1, $5}' $INDIR/$ACC/${OUTNAME}.sorted.gff > $INDIR/$ACC/${OUTNAME}.exon_sorted.bed

bedtools complement -i <(cat $INDIR/$ACC/${OUTNAME}.exon_sorted.bed intergenic_sorted.bed | sort -k1,1 -k2,2n) -g chromSizes.txt > intron_sorted.bed
