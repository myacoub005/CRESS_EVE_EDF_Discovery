#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/makedb.out

module load ncbi-blast
module load db-swissprot

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
fi

PHYLUM=Ascomycota
DB=BLASTDB
OUT=Queries
OUTDIR=Results/$PHYLUM

mkdir -p $OUTDIR
mkdir -p $DB
mkdir -p $OUT

CAP=CAP_tmp_hits/$PHYLUM/${PHYLUM}.CAP_hits.fa
REP=REP_tmp_hits/$PHYLUM/${PHYLUM}.REP_hits.fa

# We can just re-use the DBs we made in step 05. 

#cat $UNIPROT_DB/uniprot_sprot.fasta $OUT/Capsid.prots.fasta $OUT/Rep.prots.fasta > $OUT/CRESS_Uniprot_sprot.fasta

#makeblastdb -in $OUT/CRESS_Uniprot_sprot.fasta -dbtype prot -out $DB/UNIPROT_CRESS

blastp -query $REP -db $DB/UNIPROT_CRESS -outfmt 6 -evalue 0.00001 -max_hsps 1 -max_target_seqs 1 > $OUTDIR/${PHYLUM}.TRUE_REP.tsv

blastp -query $CAP -db $DB/UNIPROT_CRESS -outfmt 6 -evalue 0.00001 -max_hsps 1 -max_target_seqs 1 > $OUTDIR/${PHYLUM}.TRUE_CAP.tsv

#blastp -query $INDIR/$ACC/${OUTNAME}.protein.faa -db $DB/REP -outfmt 6 -evalue 0.00001 -max_hsps 1 -max_target_seqs 1 > $REP/$OUTNAME.tsv

