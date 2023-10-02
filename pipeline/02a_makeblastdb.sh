#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/makedb.out

module load ncbi-blast
module load db-swissprot

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
fi


DB=BLASTDB
OUT=Queries

mkdir -p $DB
mkdir -p $OUT

#cat $UNIPROT_DB/uniprot_sprot.fasta $OUT/Capsid.prots.fasta $OUT/Rep.prots.fasta > $OUT/CRESS_Uniprot_sprot.fasta

makeblastdb -in $OUT/Capsid.prots.fasta -dbtype prot -out $DB/CAP
makeblastdb -in $OUT/Rep.prots.fasta -dbtype prot -out $DB/REP

#blastp -query CAP_hits.fasta -db $DB/UNIPROT_CRESS -outfmt 6 -max_hsps 1 -max_target_seqs 1 > $OUT/Blastp.out
