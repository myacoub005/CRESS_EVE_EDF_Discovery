#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/hmmsearch.REP.%a.log

module load hmmer/3

CPU=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPU=1
fi

N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

IFS=,
tail -n +2 metadata/Phyla.csv | sed -n ${N}p | while read PHY NA
do

INDIR=REP_Phylo/$PHY
OUTDIR=REP_Domains/$PHY
HMM_DIR=HMMs

mkdir -p $OUTDIR

#for file in *.hmm; do dir=$(echo $file | cut -d. -f1); mkdir -p $OUTDIR/$dir; mv $file $dir; done

for i in *.hmm; do hmm=$(echo $i | cut -d. -f1); 

cp $INDIR/${PHY}*seqkit*.fasta  $OUTDIR/${PHY}_Rep.fasta
esl-sfetch --index $OUTDIR/${PHY}_Rep.fasta
hmmsearch --domtbl $OUTDIR/$hmm.domtbl -E 1e-5 $i $OUTDIR/${PHY}_Rep.fasta > $OUTDIR/$hmm.hmmsearch

done
done
