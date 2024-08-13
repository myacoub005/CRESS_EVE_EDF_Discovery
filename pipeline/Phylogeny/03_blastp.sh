#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/makedb.%a.out

module load ncbi-blast

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
fi

Q=Queries

#cat $Q/*REP.aa.fasta > $Q/CRESS_REP_library.aa.fasta

#makeblastdb -in $Q/Bacilladnaviridae_REP.aa.fasta -dbtype prot -out $Q/REP_Bacilladnaviridae

IFS=,
tail -n +2 metadata/Phyla.csv | sed -n ${N}p | while read PHY NA
do

INDIR=REP_Phylo/$PHY

blastp -query $INDIR/${PHY}_REP.aa.fasta -db $Q/REP_families -outfmt 6 -max_hsps 1 -max_target_seqs 1 -evalue 0.00001 > $INDIR/${PHY}_REP_families.tree.blastp.out
done
