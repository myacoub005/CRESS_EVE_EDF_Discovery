#!/usr/bin/bash
#SBATCH -p short -N 1 -n 2 --mem 4gb --out logs/make_queryloci.log

module load cblaster

INDIR=Orthology
DB=$INDIR/db
OUTDIR=$INDIR/hmmsearch_results
STRAINS=$INDIR/strains
for domain in $(ls $DB/*.hmm); do
	pfam=$(basename $domain .hmm)
	for refgenome in $(ls $DB/*.gbff);
	do
		hmmout=$OUTDIR/$(basename $refgenome .gbff).pep.${pfam}.tab
		./pipeline/scripts/extract_locus_flank_gbk.py -i $refgenome -t $hmmout
		#./scripts/extract_locus_flank_gbk.py -i $refgenome -t $hmmout -g ignore.txt
	done
done
