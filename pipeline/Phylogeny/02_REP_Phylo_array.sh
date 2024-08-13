#!/bin/bash -l
#SBATCH -p batch -N 1 -n 32 --mem 64gb --out logs/iqtree.%a.log

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
tail -n +2 metadata/Phyla.csv | sed -n ${N}p | while read PHY NA
do

INDIR=REP_Phylo/$PHY

module load muscle
module load iqtree

#The names are a bit hard to decipher here so let's change the fasta headers a bit #

cat $INDIR/${PHY}_REP.aa.fasta | sed -e 's/\[\([^]]*\)\]/\\replace{\1}/g' | sed 's/.1 .*replace/.1|/' > $INDIR/${PHY}_REP.aa.renamed.fasta

cat REP_Phylo/Query_Reps.aa.fasta $INDIR/${PHY}_REP.aa.renamed.fasta > $INDIR/${PHY}_REP.tree.aa.fasta

muscle -align $INDIR/${PHY}_REP.tree.aa.fasta -output $INDIR/${PHY}_REP.tree.aa.aln
iqtree2 -T AUTO -s $INDIR/${PHY}_REP.tree.aa.aln -alrt 1000 -m MFP

done
