#!/bin/bash -l 
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/Foxy.%a.log

module load minimap2
module load samtools

OUTDIR=Foxy_orthology
mkdir -p $OUTDIR

#Find the locations of the viral EVEs in the gff files

grep "KAH7200673.1" ncbi_dataset/Ascomycota/Pezizomycotina/GCA_020744455.1/GCA_020744455.1.Fusarium.oxysporum.gff | cut -f1,4,5 > $OUTDIR/Foxy_REP_hits.txt
grep "KAI3572956.1" ncbi_dataset/Ascomycota/Pezizomycotina/GCA_023509805.1/GCA_023509805.1.Fusarium.oxysporum.gff | cut -f1,4,5 >> $OUTDIR/Foxy_REP_hits.txt
grep "KAJ0129885.1" ncbi_dataset/Ascomycota/Pezizomycotina/GCA_026229875.1/GCA_026229875.1.Fusarium.oxysporum.gff | cut -f1,4,5 >> $OUTDIR/Foxy_REP_hits.txt

#Find the 2kb window up and downstream of the EVE integrants

awk -v s=2000 '{print $1, $2-s, $2, $3, $3+s}' $OUTDIR/Foxy_REP_hits.txt >> $OUTDIR/Foxy_REP_loci.txt

# Make a metadata file for the Fusarium oxysporum rep hits
# These first 3 are the ones with EVEs

head -n 1 metadata/Ascomycota_NCBI_metadata.csv > $OUTDIR/Foxy_Query_ACC.csv
grep "GCA_020744455.1" metadata/Ascomycota_NCBI_metadata.csv >> $OUTDIR/Foxy_Query_ACC.csv
grep "GCA_023509805.1" metadata/Ascomycota_NCBI_metadata.csv >> $OUTDIR/Foxy_Query_ACC.csv
grep "GCA_026229875.1" metadata/Ascomycota_NCBI_metadata.csv >> $OUTDIR/Foxy_Query_ACC.csv

#Generate the Query metadata file 

grep "oxysporum" metadata/Ascomycota_NCBI_metadata.csv >> $OUTDIR/Foxy_Query_ACC.csv

#Now we should extract the flanks of the viral regions so we can try to find them in the other Fusarium genomes

samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/GCA_020744455.1/GCA_020744455.1*.genomic.fna JAHEWL010000030.1:370155-372155 > $OUTDIR/GCA_020744455.1_left_flank.fasta
samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/GCA_020744455.1/GCA_020744455.1*.genomic.fna JAHEWL010000030.1:372835-374835 > $OUTDIR/GCA_020744455.1_right_flank.fasta

samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/GCA_023509805.1/GCA_023509805.1*.genomic.fna JAKELM010000019.1:65393-67393 > $OUTDIR/GCA_020744455.1_left_flank.fasta
samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/GCA_023509805.1/GCA_023509805.1*.genomic.fna JAKELM010000019.1:68118-70118 > $OUTDIR/GCA_020744455.1_right_flank.fasta

samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/GCA_026229875.1/GCA_026229875.1*.genomic.fna JACWCA010001204.1:6208-8208 > $OUTDIR/GCA_026229875.1_left_flank.fasta
samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/GCA_026229875.1/GCA_026229875.1*.genomic.fna JACWCA010001204.1:8933-10933 > $OUTDIR/GCA_026229875.1_right_flank.fasta


#xargs samtools faidx $INDIR/$ACC/${OUTNAME}.genomic.fna < $OUT/${OUTNAME}.CRESS_Scaffolds.txt > $INDIR/$ACC/${OUTNAME}.CRESS_scaffolds.fasta
