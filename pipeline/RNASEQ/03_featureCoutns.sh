#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/featurecounts.log

Rscript Rscripts/featureCounts.R
