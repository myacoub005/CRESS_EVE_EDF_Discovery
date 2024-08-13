#!/bin/bash
#SBATCH -p epyc -N 1 -n 16 --mem 64gb --out logs/Kaz_Tree.gappout.VTR10.5.log

module load seqkit
module load mafft
module load iqtree
module load trimal
#module load raxml-ng

INDIR=REP_Phylo
OUTDIR=$INDIR/rtREV+G+F/Untrimmed/Gappyout/VT+R10

mkdir -p $OUTDIR

#cat $INDIR/Query_Reps.80.rename.aa.fasta | sed 's/:/_/' | sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' > $INDIR/Query_Reps.80.rename.aa.faa

#cat $INDIR/Fungal_EVEs.aa.renamed.fasta $INDIR/Kazlauskas_Queries.aa.fasta > $INDIR/Fungi_Rep_tree.aa.fasta

#cat $INDIR/Fungi_Rep_tree.aa.fasta | sed 's/:/_/' | sed 's/,/_/'| sed 's/>.*|/>/'| sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' | sed 's/[][]//g' > $INDIR/Fungi_Rep_tree.rename.aa.fasta

#seqkit rename -n $INDIR/Fungi_Rep_tree.aa.fasta > $INDIR/Fungi_Rep_tree.rename.1.aa.fasta

#seqkit rmdup < $INDIR/Fungi_Rep_tree.rename.1.aa.fasta > $INDIR/Fungi_REP.tree.rmdup.aa.fasta

#mafft-linsi --anysymbol --leavegappyregion --ep 0.123 $INDIR/Fungi_REP.tree.rmdup.aa.fasta > $INDIR/Fungi_REP.rmdup.tree.aa.aln

#trimal -gt 0.2 -in $INDIR/Fungi_REP.rmdup.tree.aa.aln -out $INDIR/Fungi_REP.rmdup.tree.aa.trimmed.aln

#trimal -gappyout -in $INDIR/Fungi_REP.rmdup.tree.rename.aa.aln -out $OUTDIR/Fungi_REP.rmdup.tree.aa.gappyout.aln

#iqtree2 -T AUTO -s Fungi_REP.rmdup.tree.aa.aln -alrt 1000 -m MFP

cp $INDIR/Fungi_REP.rmdup.tree.aa.aln $OUTDIR/

cd $OUTDIR

#seqkit rename -n Fungi_REP.rmdup.tree.aa.gappyout.aln > Fungi_REP.rmdup.tree.aa.gappyout.rename.aln

iqtree2 -T AUTO -s Fungi_REP.rmdup.tree.aa.aln -B 1000 -m VT+R10

#raxml-ng --all --msa Fungi_REP.rmdup.tree.aa.trimmed.1.aln --model PROTGTR --tree pars{10} --bs-trees 350
