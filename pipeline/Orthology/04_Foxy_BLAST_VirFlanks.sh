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

IFS=,
tail -n +2 Foxy_orthology/Foxy_Query_ACC.csv | sed -n ${N}p | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

INDIR=ncbi_dataset/Ascomycota/$SUBPHY/$ACC
OUTDIR=Foxy_orthology/$ACC
OUTNAME=$ACC.$GENUS.$SP
QUERY=Foxy_orthology/Synteny_Comp/JAOQAX010000044.1:1211-1999.fasta

mkdir -p $OUTDIR

makeblastdb -in $INDIR/${OUTNAME}.genomic.fna -dbtype nucl -out $OUTDIR/${OUTNAME}.blastdb

blastn -query $QUERY -db $OUTDIR/${OUTNAME}.blastdb -max_hsps 1 -qcov_hsp_perc 95 -out $OUTDIR/${OUTNAME}.Virflank_blast6.out -outfmt 6

done

