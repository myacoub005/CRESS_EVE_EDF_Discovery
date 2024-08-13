#!/bin/bash -l
#SBATCH -p batch -N 1 -n 16 --mem 32gb --out logs/iqtree_TEF1.log

INDIR=Foxy_orthology

OUTDIR=$INDIR/TEF1_PHY

mkdir -p $OUTDIR

cat $INDIR/ncbi_dataset/data/*/*.tef1.cds.fasta > $OUTDIR/Foxy_tef1.fasta

module load muscle
module load iqtree

muscle -align $OUTDIR/Foxy_tef1.fasta -output $OUTDIR/Foxy_tef1.aln
iqtree2 -T AUTO -s $OUTDIR/Foxy_tef1.aln -alrt 1000 -m MFP
