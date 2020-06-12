#!/bin/bash
APP_NAME=FN_small
RUN="RAW"
NP=4

ClonalFrameML Roseovairus_pruned.nwk concate_coreLCB.fasta core_wga.out -emsim 100

R CMD BATCH '--args core_wga.out' cfml_results.R
mkdir coreWGA_output
mv *.em.txt *.labelled_tree.newick *.pdf *.xls ./coreWGA_output/

