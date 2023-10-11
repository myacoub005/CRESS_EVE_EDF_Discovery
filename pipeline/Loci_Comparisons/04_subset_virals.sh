#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/subset_virals.%a.out

module load ncbi-blast

INDIR=ncbi_dataset/data

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

#REP_BLASTP,EVE,Host,ID

SAMP=NCBI_EVE_hits.csv

cut -f3 $SAMP -d "," > Viral_gene_IDs.txt

IFS=,
tail -n +2 NCBI_EVE_hits.csv | sed -n ${N}p | while read ACC PROT EVE HOST FUNCT

do

grep -f Viral_gene_IDs.txt $INDIR/$ACC/*genes.bed >> $INDIR/${ACC}/${ACC}.${HOST}.Viral_genes.bed
done
