#!/bin/bash
#SBATCH -p batch -N 1 -n 32 --mem 32gb --out logs/reformat_seqs.log

## The first step is to extract the TRUE REP and CAP sequences for phylogenetic tree building

module load seqtk

INDIR=Results

CAP=CAP_Phylo
REP=REP_Phylo

mkdir -p $REP
mkdir -p $CAP

#Concatenate the proteomes to make extraction a little easier

ALL_PROTS=all_prots.faa

# Now we can use the CAP and REP txt files to extract the putative REP/CAP hits

seqtk subseq all_prots.faa $INDIR/TRUE_REP_IDs.txt > $REP/REP_hits.fa

seqtk subseq all_prots.faa $INDIR/TRUE_CAP_IDs.txt > $CAP/CAP_hits.fa

cat Queries/Rep.prots.fasta | sed 's/>.*OS=/>/' | sed 's/ /_/g' | sed 's/_OX=.*//' > $REP/REPs_uniprot_renamed.fasta
cat Queries/Capsid.prots.fasta | sed 's/>.*OS=/>/' | sed 's/ /_/g' | sed 's/_OX=.*//' > $CAP/CAPs_uniprot_renamed.fasta

cat $REP/REP_hits.fa | sed -e 's/\[\([^]]*\)\]/\\replace{\1}/g' | sed 's/.1 .*replace/.1|/' > $REP/REP_hits_renamed.faa
cat $CAP/CAP_hits.fa | sed -e 's/\[\([^]]*\)\]/\\replace{\1}/g' | sed 's/.1 .*replace/.1|/' > $CAP/CAP_hits_renamed.faa

sed 's, ,_,g' -i $REP/REP_hits_renamed.faa
sed 's, ,_,g' -i $CAP/CAP_hits_renamed.faa

cat $CAP/CAPs_uniprot_renamed.fasta $CAP/CAP_hits_renamed.faa > $CAP/CAP_tree_prots.faa
cat $REP/REPs_uniprot_renamed.fasta $REP/REP_hits_renamed.faa > $REP/REP_tree_prots.faa
