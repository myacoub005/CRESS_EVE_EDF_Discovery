#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/prodigal.%a.log

#Let's try to extract the hits so we can annotate these scaffolds? May be better than trying for the whole genome

module load samtools
module load prodigal

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
tail -n +2 tBLASTN/EDF_BLASTX_CRESS_positive_ACCs.csv | sed -n ${N}p | while read GENUS SP STRAIN BS BP ACC SIZE GC SCAFFOLD CDS PHY
do

INDIR=ncbi_dataset/$PHY
OUTNAME=$ACC.$GENUS.$SP
OUT=tBLASTN/DIAMOND/$PHY

mkdir -p $OUT

#tblastn -num_threads $CPUS -query $QUERY/Capsid.prots.fasta -subject $INDIR/$ACC/${OUTNAME}.genomic.fna -evalue 0.00001 -outfmt 6 -max_hsps 1 -max_target_seqs 1 -out $OUT/${OUTNAME}.out

grep "CRESS" $OUT/${OUTNAME}.dmnd.out | cut -f1 | sort | uniq > $OUT/${OUTNAME}.CRESS_Scaffolds.txt

xargs samtools faidx $INDIR/$ACC/${OUTNAME}.genomic.fna < $OUT/${OUTNAME}.CRESS_Scaffolds.txt > $INDIR/$ACC/${OUTNAME}.CRESS_scaffolds.fasta

prodigal -i $INDIR/$ACC/${OUTNAME}.CRESS_scaffolds.fasta -o $INDIR/$ACC/${OUTNAME}_CRESS.gff -d $INDIR/$ACC/${OUTNAME}_CRESS.orfs.fasta -a $INDIR/$ACC/${OUTNAME}_CRESS.proteins.fasta -f gff -m -p meta

done
