#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/blastp_r2.%a.log

#Great work so far! We've identified CRESS orfs in the proteomes of many fungi, putative orfs in other assemblies, and predicted those orfs
#Now we better screen the new predictions to confirm those orfs and get counts of Cap and Rep

module load diamond

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

IFS=,
tail -n +2 tBLASTN/CRESS_Ascomycota_6_blastxHits.csv | sed -n ${N}p | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

INDIR=ncbi_dataset/$PHY/$SUBPHY
OUTNAME=$ACC.$GENUS.$SP
OUTDIR=Results/$PHY
DB=Queries/CRESS_SPROT.dmnd

mkdir -p $OUTDIR

#diamond blastp --db $DB -q $INDIR/$ACC/${OUTNAME}_CRESS.proteins.fasta --threads 8 --out $OUTDIR/${OUTNAME}.blastp_CRESS_Contigs.tsv --tmpdir $OUTDIR/tmp --outfmt 6 --evalue 0.00001 --max-hsps 1 

diamond blastp --db $DB -q $INDIR/$ACC/${OUTNAME}_CRESS.proteins.fasta --threads 8 --out $OUTDIR/${OUTNAME}.blastp_CRESS_Contigs.tsv --outfmt 6 --evalue 0.00001 --max-hsps 1 --max-target-seqs 1

#prodigal -i $INDIR/$ACC/${OUTNAME}.CRESS_scaffolds.fasta -o $INDIR/$ACC/${OUTNAME}_CRESS.gff -d $INDIR/$ACC/${OUTNAME}_CRESS.orfs.fasta -a $INDIR/$ACC/${OUTNAME}_CRESS.proteins.fasta -f gff -m -p meta

done
