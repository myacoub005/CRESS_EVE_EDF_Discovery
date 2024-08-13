#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/EVE_GC.%a.log

module load bedtools

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


IFS=,
tail -n +2 metadata/Ascomycota_CRESS_POS_ACC.csv | sed -n ${N}p | while read PHY SUBPHY ACC
do

OUTDIR=GC_Content/$PHY
INDIR=ncbi_dataset/$PHY/$SUBPHY
BED=GC_Content/$PHY/EVE_locations.bed

bedtools nuc -fi $INDIR/$ACC/${ACC}*genomic.fna -bed $BED > $OUTDIR/${ACC}.nuc.txt

done
