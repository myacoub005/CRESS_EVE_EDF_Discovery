#!/bin/bash
#SBATCH -p batch -N 1 -n 16 --mem 32gb --out logs/REP_phylo.fasttree.log

module load fasttree

INDIR=REP_Phylo
OUTDIR=$INDIR/REP_fasttree

mkdir -p $OUTDIR

#cat $INDIR/Query_Reps.80.rename.aa.fasta | sed 's/:/_/' | sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' > $INDIR/Query_Reps.80.rename.aa.faa

#cat $INDIR/Fungi_REP.aa.renamed.fasta $INDIR/Query_Reps.80.rename.aa.faa > $INDIR/Fungi_Rep_tree.aa.fasta

#cat $INDIR/Fungi_Rep_tree.aa.fasta | sed 's/:/_/' | sed 's/,/_/'| sed 's/>.*|/>/'| sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' | sed 's/[][]//g' > $INDIR/Fungi_Rep_tree.rename.aa.fasta

#seqkit rename -n $INDIR/Fungi_Rep_tree.rename.aa.fasta > $INDIR/Fungi_Rep_tree.rename.1.aa.fasta

#seqkit rmdup < $INDIR/Fungi_Rep_tree.rename.1.aa.fasta > $INDIR/Fungi_REP.tree.rmdup.aa.fasta

#mafft --anysymbol $INDIR/Fungi_REP.tree.rmdup.aa.fasta > $INDIR/Fungi_REP.rmdup.tree.aa.aln

#raxml-ng --all --msa $INDIR/Fungi_REP.rmdup.tree.aa.aln --model LG + F + G + I --tree pars{10} --bs-trees 1000 --log debug

cp $INDIR/Fungi_REP.rmdup.tree.aa.aln $OUTDIR/

cd $OUTDIR

#iqtree2 -T AUTO -s Fungi_REP.rmdup.tree.aa.aln -alrt 1000 -m MFP

FastTreeMP -gamma -lg < Fungi_REP.rmdup.tree.aa.aln > Fungi_REP.fasttree
