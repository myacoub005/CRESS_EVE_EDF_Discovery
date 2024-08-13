#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/GC.%a.log

module load BBMap

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
tail -n +2 metadata/Basidiomycota_CRESS_NEG_ACC.csv | sed -n ${N}p | while read PHY ACC
do

INDIR=ncbi_dataset/$PHY/$ACC
OUTDIR=SIZE/$PHY/CRESS_NEG/$ACC

mkdir -p $OUTDIR

#grep -v '^>' $INDIR/$ACC*genomic.fna | wc -m > $OUTDIR/${ACC}_size.txt

stats.sh $INDIR/$ACC*genomic.fna > $OUTDIR/stats.txt

done
