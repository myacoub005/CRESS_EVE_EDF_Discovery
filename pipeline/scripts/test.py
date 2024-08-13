#!/usr/bin/env python3
from Bio import SeqIO
import os, argparse, re, time

# Usage:
#   extract_gbk_regions.py -i input.gbk -seq scaffold_id -l left_position(bp) -r right_position(bp) -name EVE1

parser = argparse.ArgumentParser(description="Subset a GBK file on a desired region")
parser.add_argument('-i','--input',help='Input GenBank file',required=True)

parser.add_argument('-l','--left',help='Left flank cut-off for subset',required=True)

parser.add_argument('-r','--right',help='Right flank cut-off for subset',required=True)

parser.add_argument('-o','--outdir',help='Output folder',
                    default="query_loci",
                    required=False)

parser.add_argument('-seq','--seqname',help='name of scaffold',required=True)

parser.add_argument('-name','--outname',help='Output name',required=True)

parser.add_argument('--ext',help='Outfile extension',
                    required=False, default=".gbk")

args = parser.parse_args()

record_dict = SeqIO.index(args.input, "genbank")
#print(record_dict)

chrom1 = record_dict[args.seqname]

print(chrom1)

left = int(args.left)
right = int(args.right)

chrom1_subseq = chrom1[left:right]

outfile = "%s.gbk" % args.outname

SeqIO.write(chrom1_subseq,outfile, "gb")
