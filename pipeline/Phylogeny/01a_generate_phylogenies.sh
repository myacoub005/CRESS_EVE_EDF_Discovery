#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/iqtreeCAP.log

module load iqtree
module load muscle

TREES=iqtree
CAP=CAP_Phylo
REP=REP_Phylo

mkdir -p $TREES

mv $CAP/CAP_tree_prots.faa $TREES/CAP_tree_prots.faa
mv $REP/REP_tree_prots.faa $TREES/REP_tree_prots.faa

for t in $TREES/CAP_tree_prots.faa; do

if [ ! -s ${t}.fasaln ]; then
	muscle -align $TREES/CAP_tree_prots.faa -output $TREES/CAP_tree_prots.faa.fasaln
fi

iqtree2 -T AUTO -s $TREES/CAP_tree_prots.faa.fasaln -alrt 1000 -m MFP

done
