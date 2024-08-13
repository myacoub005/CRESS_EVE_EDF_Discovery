#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/tblast.%a.log

module load minimap2

CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
    CPUS=2
fi

N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

#diamond makedb --in $QUERY/CRESS_Uniprot_sprot.fasta -d $QUERY/CRESS_SPROT

IFS=,
tail -n +2 Foxy_orthology/Foxy_Query_ACC.csv | sed -n ${N}p | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

INDIR=ncbi_dataset/Ascomycota/$SUBPHY/$ACC
OUTDIR=Foxy_orthology/$ACC
OUTNAME=$ACC.$GENUS.$SP

mkdir -p $OUTDIR

minimap2 $INDIR/${OUTNAME}.genomic.fna Foxy_orthology/GCA_020744455.1_flanks.fasta > $OUTDIR/${OUTNAME}._GCA_020744455.1.paf --secondary=no
minimap2 $INDIR/${OUTNAME}.genomic.fna Foxy_orthology/GCA_026229875.1_flanks.fasta > $OUTDIR/${OUTNAME}._GCA_026229875.1.paf --secondary=no

grep ">" $INDIR/${OUTNAME}.genomic.fna -c > $OUTDIR/${OUTNAME}.scaffold_counts.txt

done
