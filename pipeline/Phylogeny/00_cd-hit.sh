#!/bin/bash
#SBATCH -p batch -N 1 -n 16 --mem 32gb --out logs/cdhit.log

## We have a library for each of the CRESS virus Families ##

## We should cluster them together and rename and remove redundancies ##

module load cd-hit
module load seqkit

INDIR=Queries
OUTDIR=REP_Phylo

cat $INDIR/Viral_Families/*/*Rep*.renamed.* > $OUTDIR/Query_Reps.aa.fasta

cd-hit -i $OUTDIR/Query_Reps.aa.fasta -o $OUTDIR/Query_Reps.80.aa.fasta -c 0.8 -n 5 -M 16000 –d 0 -T 8

seqkit rename -n $OUTDIR/Query_Reps.80.aa.fasta > $OUTDIR/Query_Reps.80.rename.aa.fasta

