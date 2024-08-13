#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/TEF1_blastx.%a.log

module load diamond
module load seqtk

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

INDIR=Foxy_orthology/ncbi_dataset/data

diamond makedb --in Foxy_orthology/TEF1a.aa.fa -d Foxy_orthology/TEF1a

#mkdir ncbi_dataset/Ascomycota

IFS=,
tail -n +2 Foxy_orthology/Foxy_Query_ACC.csv | sed -n ${N}p | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

OUTDIR=$INDIR/$ACC

OUTNAME=$ACC.$GENUS.$SP.$STRAIN

diamond blastx -d Foxy_orthology/TEF1a -q $OUTDIR/${OUTNAME}.cds.fasta --out Foxy_orthology/${OUTNAME}.tef1.dmnd.out --threads $CPU --evalue 0.00001 --max-hsps 1 --id 50

cat Foxy_orthology/${OUTNAME}.tef1.dmnd.out | cut -f1 > Foxy_orthology/${OUTNAME}.tef1.txt

seqtk subseq $OUTDIR/${OUTNAME}.cds.fasta Foxy_orthology/${OUTNAME}.tef1.txt > $OUTDIR/${OUTNAME}.tef1.cds.fasta

sed -i "s/lcl/${OUTNAME}/" $OUTDIR/${OUTNAME}.tef1.cds.fasta

done
