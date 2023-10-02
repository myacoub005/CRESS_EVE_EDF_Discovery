#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/tblastX.%a.out

module load ncbi-blast

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
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
DB=BLASTDB
OUT=BLASTP

IFS=,
tail -n +2 ReferenceGenomes.csv | sed -n ${N}p | while read GENUS SP STRAIN BS BP ACC SIZE GC SCAFFOLDS CDS
do

OUTNAME=$ACC.$GENUS.$SP

mkdir -p $DB
mkdir -p $OUT

blastp -query $INDIR/$ACC/${OUTNAME}.protein.faa -db $DB/UNIPROT_CRESS -outfmt 6 -max_hsps 1 -max_target_seqs 1 > $OUT/$OUTNAME.tsv

done
