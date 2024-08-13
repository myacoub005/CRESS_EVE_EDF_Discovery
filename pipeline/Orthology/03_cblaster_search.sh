#!/bin/bash
#SBATCH -p short -N 1 -n 48 --mem 64gb --out logs/cblaster_search.log

module load cblaster
module load parallel

# define a function we will use
run_cblaster() {
	db=$1
	qfile=$2
	outfile=$3

	if [ ! -f $outfile.count.txt ]; then
		cblaster search -m local -db $db -qf $qfile -mi 60 -mh 2 \
			-o $outfile.count.txt -ode "," -bde "," -b $outfile.binary.txt
	fi
}

export -f run_cblaster

CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
  CPU=1
fi

INDIR=Orthology
STRAINS=strains
OUT=$INDIR/results/cblaster

mkdir -p $OUT
parallel -j $CPU mkdir -p $OUT/{/.} ::: $(ls $INDIR/strains/*.gbff)

for q in $(ls $INDIR/query_loci/*.gbk)
do
	qname=$(basename $q .gbff)
	parallel -j $CPU run_cblaster $INDIR/DMND/{/.}_ref.dmnd $q $OUT/{/.}/${qname} ::: $(ls $INDIR/strains/*.gbff)

done
