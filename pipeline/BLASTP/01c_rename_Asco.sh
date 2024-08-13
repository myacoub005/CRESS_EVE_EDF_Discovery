#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/rename.%a.log

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

INDIR=ncbi_dataset/data

#mkdir ncbi_dataset/Ascomycota

IFS=,
tail -n +2 metadata/Ascomycota_7_NCBI_ACC.csv | sed -n ${N}p | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

OUTDIR=ncbi_dataset/Ascomycota/$SUBPHY/$ACC
mkdir -p $OUTDIR

OUTNAME=$ACC.$GENUS.$SP

mv $INDIR/$ACC/*gff $OUTDIR/${OUTNAME}.gff
mv $INDIR/$ACC/cds_from_genomic.fna $OUTDIR/${OUTNAME}.cds.fasta
mv $INDIR/$ACC/protein.faa $OUTDIR/${OUTNAME}.protein.faa
mv $INDIR/$ACC/*genomic.fna $OUTDIR/${OUTNAME}.genomic.fna
done
