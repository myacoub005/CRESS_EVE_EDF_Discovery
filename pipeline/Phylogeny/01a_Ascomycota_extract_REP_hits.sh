#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out rename.log

PHY=Ascomycota
INDIR=REP_PHYLO/$PHY

for f in $INDIR/*.faa; do sed -i "s/^>/>${f}_/" "$f"; done

