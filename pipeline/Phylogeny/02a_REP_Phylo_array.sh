#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 32gb --out logs/fasttree.%a.log

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

#module load muscle
#module load iqtree
module load mafft
module load fasttree
module load seqkit

#seqkit rmdup < Query_Reps.aa.fasta > Query_Reps.rmdup.aa.fasta

#The names are a bit hard to decipher here so let's change the fasta headers a bit #

#cat $INDIR/${PHY}_REP.aa.fasta | sed -e 's/\[\([^]]*\)\]/\\replace{\1}/g' | sed 's/.1 .*replace/.1|/' > $INDIR/${PHY}_REP.aa.renamed.fasta

#cat REP_Phylo/Query_Reps.rmdup.aa.fasta $INDIR/${PHY}_REP.aa.renamed.fasta > $INDIR/${PHY}_REP.tree.aa.fasta

#seqkit rmdup < $INDIR/${PHY}_REP.tree.aa.fasta > $INDIR/${PHY}_REP.tree.rmdup.aa.fasta
seqkit rmdup < $INDIR/${PHY}_REP.tree.rmdup.aa.fasta > $INDIR/${PHY}_REP.tree.rmdup.1.aa.fasta

mafft --anysymbol $INDIR/${PHY}_REP.tree.rmdup.1.aa.fasta > $INDIR/${PHY}_REP.rmdup.tree.aa.aln

#muscle -align $INDIR/${PHY}_REP.tree.rmdup.aa.fasta -output $INDIR/${PHY}_REP.rmdup.tree.aa.aln

FastTreeMP -gamma -lg < $INDIR/${PHY}_REP.rmdup.tree.aa.aln > $INDIR/${PHY}_REP.fasttree

#iqtree2 -T AUTO -s $INDIR/${PHY}_REP.tree.aa.aln -alrt 1000 -m MFP

done

