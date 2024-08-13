#!/bin/bash
#SBATCH -p short -N 1 -n 15 --mem 16gb --out logs/get_lengths.%a.log

module load seqkit

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
tail -n +2 metadata/Phyla.csv | sed -n ${N}p | while read PHY NA
do

INDIR=REP_Phylo/$PHY
OUTDIR=AA_Lengths/$PHY

mkdir -p $OUTDIR

#seqkit fx2tab --length --name --header-line  $INDIR/CAP_tree_prots.faa > $OUTDIR/CAP_lengths.tab

seqkit fx2tab --length --name --header-line  $INDIR/${PHY}*seqkit*.fasta > $OUTDIR/${PHY}_REP_lengths.tab
done
