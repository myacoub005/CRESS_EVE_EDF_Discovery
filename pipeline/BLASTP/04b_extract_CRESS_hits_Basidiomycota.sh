#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/extract_putative_hits.log

module load seqtk

PHYLUM=Ascomycota

CAP=CAP_tmp_hits/$PHYLUM
REP=REP_tmp_hits/$PHYLUM

mkdir -p $REP
mkdir -p $CAP

INDIR=ncbi_dataset/$PHYLUM

#Concatenate the proteomes to make extraction a little easier

cat $INDIR/*/*faa > ${PHYLUM}.all_prots.faa

## Get a litst of the CAP and REP hits to subset

cat BLASTP/CAP/$PHYLUM/* | cut -f1 > ${PHYLUM}.CAP_hits.txt
cat BLASTP/REP/$PHYLUM/* | cut -f1 > ${PHYLUM}.REP_hits.txt

# Now we can use those txt files to extract the putative REP/CAP hits
# Note, these are only putative hits. They need to still be compared against the larger proteome set

seqtk subseq ${PHYLUM}.all_prots.faa ${PHYLUM}.REP_hits.txt > $REP/${PHYLUM}.REP_hits.fa

seqtk subseq ${PHYLUM}.all_prots.faa ${PHYLUM}.CAP_hits.txt > $CAP/${PHYLUM}.CAP_hits.fa

