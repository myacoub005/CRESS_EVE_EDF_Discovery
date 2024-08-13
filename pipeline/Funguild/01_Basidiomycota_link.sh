#!/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/Funguild.Basidiomyota.log

OUTDIR=Funguild_
INDIR=Results/Basidiomycota

grep -Fvf $INDIR/Basidiomycota_All_Viral_positive_ACC.txt $OUTDIR/Basidiomycota_funguild..guilds_matched.txt > $OUTDIR/Basidiomycota_ViralNegatives.guilds.txt
grep -f $INDIR/Basidiomycota_All_Viral_positive_ACC.txt $OUTDIR/Basidiomycota_funguild..guilds_matched.txt > $OUTDIR/Basidiomycota_ViralPositives.guilds.txt

#cat Ascomycota_funguild.CRESS_pos.txt | cut -f6 | cut -d "-" -f2 | tr -d '|' | sort | uniq -c
