#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/extract_REP_prots.%a.log

#Great work so far! We've identified CRESS orfs in the proteomes of many fungi, putative orfs in other assemblies, and predicted those orfs
#Now we better screen the new predictions to confirm those orfs and get counts of Cap and Rep

module load seqtk
module load BBMap

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
tail -n +2 metadata/Ascomycota_Blastp_and_prodigal_hits.csv | sed -n ${N}p | while read ROW GENUS PHY SUBPHY CLASS FAM SP STRAIN ACC NA
do

INDIR=ncbi_dataset/$PHY/$SUBPHY
OUTNAME=$ACC.$GENUS.$SP
OUTDIR=REP_Phylo/$PHY

mkdir -p $OUTDIR

grep "CRESS_REP" Results/$PHY/${OUTNAME}.blastp_CRESS_Contigs.tsv | cut -f1 > $OUTDIR/${OUTNAME}.REP.hits.txt
cat Results/$PHY/Ascomycota_TRUE_REP_hits.txt >> $OUTDIR/${OUTNAME}.REP.hits.txt

seqtk subseq $INDIR/$ACC/${OUTNAME}_CRESS.proteins.fasta $OUTDIR/${OUTNAME}.REP.hits.txt > $OUTDIR/${OUTNAME}_REP.aa.fasta

seqtk subseq $INDIR/$ACC/${OUTNAME}.protein.faa $OUTDIR/${OUTNAME}.REP.hits.txt >> $OUTDIR/${OUTNAME}_REP.aa.fasta

cat $OUTDIR/${OUTNAME}_REP.aa.fasta | sed -e 's/\[\([^]]*\)\]/\\replace{\1}/g' | sed 's/.1 .*replace/.1|/' > $OUTDIR/${OUTNAME}_REP.renamed.aa.fasta


#diamond blastp --db $DB -q $INDIR/$ACC/${OUTNAME}_CRESS.proteins.fasta --threads 8 --out $OUTDIR/${OUTNAME}.blastp_CRESS_Contigs.tsv --outfmt 6 --evalue 0.00001 --max-hsps 1 --max-target-seqs 1

done
