#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/hisat2_G.rosea.%a.log

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

module load hisat2

INDIR=RNAseq

cd $INDIR

GENOME=ref/GCA_003550325.1_ASM355032v1_genomic.fna
OUTDIR=hisat

mkdir -p $OUTDIR

IFS=,
tail -n +2 RNAseq_metadata.tsv | sed -n ${N}p | while read SAMPLE REP FQ1 FQ2

do

#hisat2-build $GENOME $OUTDIR/G.rosea

hisat2 -x $OUTDIR/G.rosea -1 $FQ1 -2 $FQ2 -S $OUTDIR/$SAMPLE.$REP.sam

done
