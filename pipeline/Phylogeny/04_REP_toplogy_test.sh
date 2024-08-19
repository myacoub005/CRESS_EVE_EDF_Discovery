#!/bin/bash -l
#SBATCH -p epyc -N 1 -n 16 --mem 64gb --out topo_test.log

module load iqtree

TREES=EVE_trees_topo.treels
ALN=Fungi_REP.rmdup.tree.rename.1.aa.aln

iqtree2 -s $ALN -z $TREES -zb 10000 -au -n 0 --prefix EVES.test -m MFP

