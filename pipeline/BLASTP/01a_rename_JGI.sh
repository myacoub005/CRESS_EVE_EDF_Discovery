#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/renameJGI.%a.log

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


INDIR=JGI_pep/pep
OUTDIR=JGI_pep/pep_renamed

mkdir -p $OUTDIR

IFS=,
tail -n +2 JGI_speciesnames.csv | sed -n ${N}p | while read ID GBK GENUS SP PHYLUM SUBPHY CLASS SUBCLASS FMLY
do

OUTNAME=$GENUS.$SP.JGI

cp $INDIR/$ID*.fasta $OUTDIR/$ACC/${OUTNAME}.protein.faa

done
