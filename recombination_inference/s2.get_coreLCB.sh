#!/bin/bash

#usage: ./s1.get_coreLCB.sh
#note: the XMFA file includes filesystem path references to the original aligned sequences.
#      stripSubsetLCBs tries to read in those sequences, 
#      so the input xfma file should be located at the same path like the directory is. 
#      Otherwise, Exception FileNotOpened thrown from Unknown()  in gnFileSource.cpp 67


## for cluster in ShenZhen
/yourpath/mauve_snapshot_2015-02-13/stripSubsetLCBs mauve_out.xmfa mauve_out.xmfa.bbcols coreLCB.xmfa 500 16

#Usage: stripSubsetLCBs <input xmfa> <input bbcols> <output xmfa> [min LCB size] [min genomes] [randomly subsample to X kb]

