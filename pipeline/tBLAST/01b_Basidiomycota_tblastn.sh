#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/tblast.%a.log

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

OUT=tBLASTN/DIAMOND
QUERY=Queries

mkdir -p $OUT

#diamond makedb --in $QUERY/CRESS_Uniprot_sprot.fasta -d $QUERY/CRESS_SPROT

IFS=,
tail -n +2 metadata/Basidiomycota_NCBI_ACC_BlastpNegatives.csv | sed -n ${N}p | while read GENUS PHY SP STR ACC NA
do

INDIR=ncbi_dataset/Basidiomycota/$ACC
OUTDIR=tBLASTN/DIAMOND/$PHY
OUTNAME=$ACC.$GENUS.$SP

mkdir -p $OUTDIR

#tblastn -num_threads $CPUS -query $QUERY/CRESS_Uniprot_sprot.fasta -subject $INDIR/${OUTNAME}.genomic.fna -evalue 0.00001 -outfmt 6 -max_hsps 1 -max_target_seqs 1 -out $OUTDIR/${OUTNAME}.out

diamond blastx -d $QUERY/CRESS_SPROT -q $INDIR/${OUTNAME}.genomic.fna --out $OUTDIR/${OUTNAME}.dmnd.out --threads $CPUS --evalue 0.00001 --range-culling -F 1

done
