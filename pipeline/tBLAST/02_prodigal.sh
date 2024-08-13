#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/prodigal.%a.log

#Okay so we've identified viral ORFs and putative viral Orfs in the assemblies of other fungi
#Let's try to predict viral ORFs in the blastx positive genomes
#Then we'll repeat the blastp searches

#split CRESS_blastx_Counts.csv -l 2000 CRESS_blastx_Counts.csv 

module load prodigal

CPU=$SLURM_CPUS_ON_NODE
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

SAMPLEFILE=tBLASTN/DIAMOND/Ascomycota/CRESS_Ascomycota_3_blastxHits.csv


IFS=,
tail -n +2 $SAMPLEFILE | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

OUTDIR=ncbi_dataset/$PHY/$SUBPHY/$ACC

OUTNAME=$ACC.$GENUS.$SP

prodigal -i $OUTDIR/${OUTNAME}.genomic.fna -o $OUTDIR/${OUTNAME}.gff -d $OUTDIR/${OUTNAME}.orfs.fasta -a $OUTDIR/${OUTNAME}.proteins.fasta -f gff -m

done
