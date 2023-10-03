#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/extract_putative_hits.log

module load seqtk

CAP=CAP_tmp_hits
REP=REP_tmp_hits

mkdir -p $REP
mkdir -p $CAP

INDIR=ncbi_dataset/data

#Concatenate the proteomes to make extraction a little easier

cat $INDIR/*/*faa > all_prots.faa

## Get a litst of the CAP and REP hits to subset

cat BLASTP/CAP/* | cut -f1 > CAP_hits.txt
cat BLASTP/REP/* | cut -f1 > REP_hits.txt

# Now we can use those txt files to extract the putative REP/CAP hits
# Note, these are only putative hits. They need to still be compared against the larger proteome set

seqtk subseq all_prots.faa REP_hits.txt > $REP/REP_hits.fa

seqtk subseq all_prots.faa CAP_hits.txt > $CAP/CAP_hits.fa

