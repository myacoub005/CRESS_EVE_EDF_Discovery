#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/make_query_loci.sh

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
tail -n +2 Orthology/Query_locations.csv | sed -n ${N}p | while read ACC SEQ PROT ID SP HIT START STOP LEFT RIGHT
do

python pipeline/scripts/test.py -i GCA_003550325.1.Gigaspora.rosea.gbff -seq $SEQ -l $LEFT -r $RIGHT -name $ID -o Orthology/query_loci
done
