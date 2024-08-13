#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/SamToBam.%a.log

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

module load samtools

INDIR=RNAseq

cd $INDIR

OUTDIR=hisat

mkdir -p $OUTDIR

IFS=,
tail -n +2 RNAseq_metadata.tsv | sed -n ${N}p | while read SAMPLE REP FQ1 FQ2
do

samtools view -h -bS $OUTDIR/$SAMPLE.$REP.sam > $OUTDIR/$SAMPLE.$REP.bam

done
