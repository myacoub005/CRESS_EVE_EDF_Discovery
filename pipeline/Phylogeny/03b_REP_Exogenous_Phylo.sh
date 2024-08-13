#!/bin/bash
#SBATCH -p epyc -N 1 -n 32 --mem 64gb --out logs/REP_Exogenous_phylo_MFP.log

module load iqtree
module load mafft
module load seqkit

INDIR=REP_Phylo
OUTDIR=$INDIR/REP_CRESS_Tree

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
fi

mkdir -p $OUTDIR

#cat $INDIR/Query_Reps.80.rename.aa.fasta | sed 's/:/_/' | sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' > $INDIR/Query_Reps.80.rename.aa.faa

#cat $INDIR/Fungi_REP.aa.renamed.fasta $INDIR/Query_Reps.80.rename.aa.faa > $INDIR/Fungi_Rep_tree.aa.fasta

#cat $INDIR/Fungi_Rep_tree.aa.fasta | sed 's/:/_/' | sed 's/,/_/'| sed 's/>.*|/>/'| sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' | sed 's/[][]//g' > $INDIR/Fungi_Rep_tree.rename.aa.fasta

#seqkit rename -n $INDIR/Fungi_Rep_tree.rename.aa.fasta > $INDIR/Fungi_Rep_tree.rename.1.aa.fasta

seqkit rmdup < $INDIR/Query_Reps.80.aa.fasta > $INDIR/Exogenous.rmdup.aa.fasta

mafft --anysymbol $INDIR/Exogenous.rmdup.aa.fasta > $OUTDIR/Exogenous_CRESS_Reps.80.aa.fasta.aln

#raxml-ng --all --msa $INDIR/Fungi_REP.rmdup.tree.aa.aln --model LG + F + G + I --tree pars{10} --bs-trees 1000 --log debug

#cp $INDIR/Fungi_REP.rmdup.tree.aa.aln $OUTDIR/

cd $OUTDIR

iqtree2 -T AUTO -s Exogenous_CRESS_Reps.80.aa.fasta.aln -alrt 1000 -m MFP
