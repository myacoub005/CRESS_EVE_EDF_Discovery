#!/bin/bash
#SBATCH -p batch -N 1 -n 16 --mem 32gb --out logs/tblast.%a.log

module load ncbi-blast
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


QUERY=Queries

#diamond makedb --in $QUERY/CRESS_Uniprot_sprot.fasta -d $QUERY/CRESS_SPROT

IFS=,
tail -n +2 metadata/Collaborative_genomes_metadata.csv | sed -n ${N}p | while read PROVIDER ID GENUS SP PHY TECH
do

INDIR=Collaboration_genomes
OUTNAME=$PROVIDER.$GENUS.$SP
OUT=tBLASTN/$PHY

mkdir -p $OUT

tblastn -num_threads $CPUS -query $QUERY/CRESS_Uniprot_sprot.fasta -subject $INDIR/${ID} -evalue 0.00001 -outfmt 6 -max_hsps 1 -out $OUT/${OUTNAME}.out

#diamond blastx -d $QUERY/CRESS_SPROT -q $INDIR/${ID} --out $OUT/${OUTNAME}.dmnd.out --threads $CPUS

done
