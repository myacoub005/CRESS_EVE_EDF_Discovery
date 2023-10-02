#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/rename.%a.log

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

mv $INDIR/$ACC/*gff $INDIR/$ACC/${OUTNAME}.gff
mv $INDIR/$ACC/cds_from_genomic.fna $INDIR/$ACC/${OUTNAME}.cds.fasta
mv $INDIR/$ACC/protein.faa $INDIR/$ACC/${OUTNAME}.protein.faa

done
