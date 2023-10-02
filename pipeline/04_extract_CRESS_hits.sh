#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/extract_putative_hits.log

module load seqtk

CAP=CAP_tmp_hits
REP=REP_tmp_hits

mkdir -p $REP
mkdir -p $CAP

INDIR=ncbi_dataset/data

cat $INDIR/*/*faa > all_prots.faa

seqtk subseq all_prots.faa REP_hits.txt > $REP/REP_hits.fa

seqtk subseq all_prots.faa CAP_hits.txt > $CAP/CAP_hits.fa

