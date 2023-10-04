#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/tblast.%a.log

#module load ncbi-blast
module load diamond

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
OUT=tBLASTN/DIAMOND
QUERY=Queries

mkdir -p $OUT

diamond makedb --in $QUERY/CRESS_Uniprot_sprot.fasta -d $QUERY/CRESS_SPROT

IFS=,
tail -n +2 Viral_Negatives.csv | sed -n ${N}p | while read GENUS SP STRAIN BS BP ACC SIZE GC SCAFFOLDS CDS
do

OUTNAME=$ACC.$GENUS.$SP

mv $INDIR/$ACC/*genomic.fna $INDIR/$ACC/${OUTNAME}.genomic.fna

#tblastn -num_threads $CPUS -query $QUERY/Capsid.prots.fasta -subject $INDIR/$ACC/${OUTNAME}.genomic.fna -evalue 0.00001 -outfmt 6 -max_hsps 1 -max_target_seqs 1 -out $OUT/${OUTNAME}.out

diamond blastx -d $QUERY/CRESS_SPROT -q $INDIR/$ACC/${OUTNAME}.genomic.fna --out $OUT/${OUTNAME}.dmnd.out --threads $CPUS

done
