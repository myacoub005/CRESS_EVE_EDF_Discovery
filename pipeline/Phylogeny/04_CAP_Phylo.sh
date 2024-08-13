#!/bin/bash
#SBATCH -p epyc -N 1 -n 32 --mem 64gb --out logs/CAP_phylo.log

#module load cd-hit
#module load muscle
module load iqtree

INDIR=CAP_Phylo
OUTDIR=$INDIR/TREE

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
fi

#mkdir -p $OUTDIR

#cd-hit -i $INDIR/Query_Caps.protein.fasta -o $INDIR/Query_Caps.80.aa.fasta -c 0.8 -n 5 

#cat $INDIR/*protein.faa $INDIR/Query_Caps.80.aa.fasta > $INDIR/Fungi_CAP.tree.protein.faa

# With spaces, hashtags, etc these names are a god damn nightmare for tree building. Let's fix these.

#cat $INDIR/Fungi_CAP.tree.protein.faa | sed 's/ /_/' |sed 's/:/_/' | sed 's/,/_/'| sed 's/>.*|/>/'| sed 's@^>[^\[]*\[\([^\]*\)]$@>\1@g' | sed 's/[][]//g' | sed 's/{}{}//g' | sed 's/ /_/' | sed 's/#.*//' > $INDIR/Fungi_CAP.tree.renamed.protein.faa

#sed 's, ,_,g' -i $INDIR/Fungi_CAP.tree.renamed.protein.faa

#seqkit rename -n $INDIR/Fungi_CAP.tree.renamed.protein.faa > $INDIR/Fungi_CAP.tree.renamed.1.protein.faa

#seqkit rmdup < $INDIR/Fungi_CAP.tree.renamed.1.protein.faa > $INDIR/Fungi_CAP.tree.rmdup.protein.faa

#Now let's align the sequences to prep for Phylo analysis. Names shoudl be okay now that we renamed things
#muscle -align $INDIR/Fungi_CAP.tree.rmdup.protein.faa -output $OUTDIR/Fungi_CAP.tree.rmdup.protein.faa.aln

iqtree2 -T AUTO -s $OUTDIR/Fungi_CAP.tree.rmdup.protein.faa.aln -alrt 1000 -m MFP
