#!/bin/bash
#SBATCH -p epyc -N 1 -n 16 --mem 64gb --out logs/Kaz_Tree_trimmed.log

module load seqkit
module load mafft
module load iqtree
module load trimal

INDIR=REP_Phylo
OUTDIR=$INDIR/REP_Phylo/Phylogeny_Constraint

mkdir -p $OUTDIR

#cat $INDIR/Query_Reps.80.rename.aa.fasta | sed 's/:/_/' | sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' > $INDIR/Query_Reps.80.rename.aa.faa

#cat $INDIR/Fungal_EVEs.aa.renamed.fasta $INDIR/Kazlauskas_Queries.aa.fasta > $INDIR/Fungi_Rep_tree.aa.fasta

#cat $INDIR/Fungi_Rep_tree.aa.fasta | sed 's/:/_/' | sed 's/,/_/'| sed 's/>.*|/>/'| sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' | sed 's/[][]//g' > $INDIR/Fungi_Rep_tree.rename.aa.fasta

#seqkit rename -n $INDIR/Fungi_Rep_tree.aa.fasta > $INDIR/Fungi_Rep_tree.rename.1.aa.fasta

seqkit rmdup < $INDIR/Kazlauskas_Queries.aa.fasta > $INDIR/Kazlauskas_Queries.rmdup.aa.fasta

seqkit rename -n $INDIR/Kazlauskas_Queries.rmdup.aa.fasta > $OUTDIR/CRESS.aa.rename.aa.fasta

mafft-linsi --anysymbol --leavegappyregion --ep 0.123 $OUTDIR/CRESS.aa.rename.aa.fasta > $OUTDIR/CRESS.aa.rename.aa.fasta.aln

trimal -gt 0.2 -in $OUTDIR/CRESS.aa.rename.aa.fasta.aln -out $OUTDIR/CRESS.aa.rename.aa.fasta.trimmed.aln

cd $OUTDIR

iqtree2 -T AUTO -s CRESS.aa.rename.aa.fasta.trimmed.aln -alrt 1000 -m rtREV+G+F
