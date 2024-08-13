#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/RNA_coverage.%a.log

INDIR=RNAseq
cd $INDIR
COV=coverage

mkdir -p $COV

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

IFS=,
tail -n +2 RNAseq_metadata.tsv | sed -n ${N}p | while read SAMPLE REP FQ1 FQ2

do

#hisat2-build $GENOME $OUTDIR/G.rosea

#hisat2 -x $OUTDIR/G.rosea -1 $FQ1 -2 $FQ2 -S $OUTDIR/G.rosea.$REP.bam

samtools sort hisat/G.rosea.$REP.bam > hisat/G.rosea.$REP.sorted.bam

samtools mpileup hisat/G.rosea.$REP.sorted.bam | awk '{print $1"\t"$2"\t"$4}' > $COV/G.rosea.$REP.coverage.tsv

done
