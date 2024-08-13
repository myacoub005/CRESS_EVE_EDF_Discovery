#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/Foxy_select_gggenomes.%a.log

module load bedtools
module load samtools

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
tail -n +2 Foxy_orthology/Foxy_int_regions.csv | sed -n ${N}p | while read EVE ACC SCAFF START END LEN BEG STOP

do

grep "$SCAFF" ncbi_dataset/Ascomycota/Pezizomycotina/$ACC/${ACC}.Fusarium.oxysporum.gff | cut -f1,2,3,4,5,7,9 > Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_scaffold.bed

grep "Gene;" Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_scaffold.bed | cut -f1,4,5,6,7 > Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_genes.bed

T=$(printf '\t')
header1=$SCAFF header2=$BEG header3=$STOP

# We need to make a subsetted bedfile for the start/stop locations we'll be comparing for the gggenomes analysis
echo "$header1$T$header2$T$header3" > Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_regions.bed 

echo "Great work! Now we will use bedtools to subset the genic regions by our new bedfile"

#bedtools intersect -a Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_regions.bed -b Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_genes.bed -wb > Foxy_orthology/Synteny_Comp/${ACC}_genes_INTregion.bed

bedtools intersect -a Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_genes.bed -b Foxy_orthology/Synteny_Comp/${ACC}.${EVE}_regions.bed -wb > Foxy_orthology/Synteny_Comp/${ACC}_genes_INTregion.bed

echo "Nice one! We have the subsetted bed files. Now we have to generate the subsetted genomic file for the minimap alignments"

samtools faidx ncbi_dataset/Ascomycota/Pezizomycotina/$ACC/${ACC}.Fusarium.oxysporum.genomic.fna $SCAFF:${BEG}-${STOP} > Foxy_orthology/Synteny_Comp/${ACC}.${SCAFF}_genomic.fasta

done

