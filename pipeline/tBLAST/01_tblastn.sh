#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/tblast.%a.log

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
OUT=tBLASTN/CAP
QUERY=Queries

mkdir -p $OUT

IFS=,
tail -n +2 Viral_Negatives.csv | sed -n ${N}p | while read GENUS SP STRAIN BS BP ACC SIZE GC SCAFFOLDS CDS
do

OUTNAME=$ACC.$GENUS.$SP

mv $INDIR/$ACC/*genomic.fna $INDIR/$ACC/${OUTNAME}.genomic.fna

tblastn -num_threads $CPUS -query $QUERY/Capsid.prots.fasta -subject $INDIR/$ACC/${OUTNAME}.genomic.fna -evalue 0.00001 -outfmt 6 -max_hsps 1 -max_target_seqs 1 -out $OUT/${OUTNAME}.out

done
