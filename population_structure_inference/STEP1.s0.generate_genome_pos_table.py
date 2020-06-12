#!/usr/bin/env python

# Input: *.genome (draft genome)
# This script will convert postions in concatenated seq to it's real position in the contig
# output: ref_genome.pos.table which has three columns: "contig_id contig_start"

import os
import sys


ref_genome = ""
with open("ref_genome.txt") as f:
    ref_genome = f.readline()[:-1]


cat_pos = 1
buff = ""
with open("%s.fasta"%ref_genome) as f:
    line = f.readline()
    while line:
	# read one contig
	contig = "%s_%s" % (ref_genome, line[:-1].split(" ")[0].split("_")[1])
	#length0 = int(line.split(" ")[2])
	length = 0 
	line = f.readline()
	while line and not line.startswith(">"):
	    length += len(line[:-1])
	    line = f.readline()
	# validate the contig length
	#if length != length0:
	#    print "Error: inconsistent length of contigs %s: %d and %d(taken)" % (contig, length0, length)
	# write to pos table
	buff += "%s\t%d\t%d\n" % (contig, cat_pos, cat_pos+length-1)
	cat_pos += length
cat_pos -= 1
	
with open("ref_genome.pos.table", "w") as f:
    f.write("#GenomeName=%s\n"% ref_genome)
    f.write("#GenomeTotalLength=%d\n"%cat_pos)
    f.write("#contig_id\tcontig_start\tcontig_end\n%s" % buff)
