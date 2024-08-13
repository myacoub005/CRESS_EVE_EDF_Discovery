#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/Foxy_minimap.log

module load minimap2

INDIR=Foxy_orthology/Synteny_Comp

cat $INDIR/*fasta > $INDIR/Foxy_Int_regions.fasta

minimap2 -X -N 50 -p 0.1 -c $INDIR/Foxy_Int_regions.fasta $INDIR/Foxy_Int_regions.fasta > $INDIR/Foxy_Int_regions.paf

cat $INDIR/*_INTregion.bed > $INDIR/Foxy_Int_regions.bed


