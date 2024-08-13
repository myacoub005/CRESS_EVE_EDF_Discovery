#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/rna_fastq_dump.log

module load sratoolkit

OUTDIR=RNAseq

mkdir -p $OUTDIR

REF=$OUTDIR/ref

FASTQ=$OUTDIR/fastq

mkdir $FASTQ
cd $FASTQ

#fastq-dump --split-files --origfmt --gzip SRR1979257	
#fastq-dump --split-files --origfmt --gzip SRR1979256	
#fastq-dump --split-files --origfmt --gzip SRR1979255
fastq-dump --split-files --origfmt --gzip SRR1979264
fastq-dump --split-files --origfmt --gzip SRR1979265
fastq-dump --split-files --origfmt --gzip SRR1979266

cd ..

mkdir -p $REF

cp ncbi_dataset/data/GCA_003550325.1/GCA_003550325.1_ASM355032v1_genomic.fna $REF/
