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

#Add CAP and REP Identifiers to the fasta files

perl -pi -e "s/^>/>CRESS_CAPSID-/g" $OUT/Capsid.prots.fasta
perl -pi -e "s/^>/>CRESS_REP-/g" $OUT/Rep.prots.fasta

makeblastdb -in $OUT/Capsid.prots.fasta -dbtype prot -out $DB/CAP
makeblastdb -in $OUT/Rep.prots.fasta -dbtype prot -out $DB/REP

#blastp -query CAP_hits.fasta -db $DB/UNIPROT_CRESS -outfmt 6 -max_hsps 1 -max_target_seqs 1 > $OUT/Blastp.out
