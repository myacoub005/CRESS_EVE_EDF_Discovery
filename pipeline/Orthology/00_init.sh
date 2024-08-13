#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 32gb --out logs/Orthology_init.log

DB=Orthology/db
STRAINS=Orthology/strains
DMND=Orthology/DMND

mkdir -p $DB
mkdir -p $DMND
mkdir -p $STRAINS

CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
  CPU=1
fi

module load db-pfam
module load hmmer/3
module load cblaster
#module load diamond
module load parallel

#cp ncbi_dataset/data/GCA_003550325.1/GCA_003550325.1.Gigaspora.rosea.gbff $DB/GCA_003550325.1.Gigaspora.rosea.gbff

#ln -s ncbi_dataset/data/*/*.gbff $STRAINS/

#cp ncbi_dataset/data/*/*gbff $STRAINS/
#cp ncbi_dataset/data/*/*protein.faa $STRAINS/

parallel -j $CPU cblaster makedb {} -n $DMND/{/.}_ref ::: $(ls $STRAINS/*.gbff)
#parallel -j $CPU ./pipeline/scripts/gbk2pepfasta.py -i {} ::: $(ls $STRAINS/*.gbff)
