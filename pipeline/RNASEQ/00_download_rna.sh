#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/rna_fastq_dump.log

module load sratoolkit

OUTDIR=RNA_fastq

mkdir -p $OUTDIR

cd $OUTDIR

fastq-dump --split-files --origfmt --gzip SRR1979257	
fastq-dump --split-files --origfmt --gzip SRR1979256	
fastq-dump --split-files --origfmt --gzip SRR1979255

