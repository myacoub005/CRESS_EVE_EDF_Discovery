#!/bin/bash -l
#SBATCH -p batch -N 1 -n 16 --mem 32gb --out logs/iqtree_Ascomycota.log

INDIR=REP_Phylo/REP_trees

module load muscle
module load iqtree

muscle -align REP_Phylo/REP_trees/out.fa -output $INDIR/Ascomycota.REP_phylogeny_input.aln
iqtree2 -T AUTO -s $INDIR/Ascomycota.REP_phylogeny_input.aln -alrt 1000 -m MFP

