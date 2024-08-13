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


INDIR=ncbi_dataset/Basidiomycota
DB=BLASTDB
CAP=BLASTP/CAP
REP=BLASTP/REP

IFS=,
tail -n +2 metadata/Basidiomycota_NCBI_ACC.csv | sed -n ${N}p | while read GENUS PHY SP STR ACC NA
do

OUTNAME=$ACC.$GENUS.$SP

OUTCAP=$CAP/$PHY
OUTREP=$REP/$PHY

mkdir -p $DB
mkdir -p $OUTCAP
mkdir -p $OUTREP

blastp -query $INDIR/$ACC/${OUTNAME}.protein.faa -db $DB/CAP -outfmt 6 -evalue 0.00001 -max_hsps 1 -max_target_seqs 1 > $OUTCAP/$OUTNAME.tsv

blastp -query $INDIR/$ACC/${OUTNAME}.protein.faa -db $DB/REP -outfmt 6 -evalue 0.00001 -max_hsps 1 -max_target_seqs 1 > $OUTREP/$OUTNAME.tsv

done
