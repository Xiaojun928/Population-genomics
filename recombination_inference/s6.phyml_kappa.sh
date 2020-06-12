#!/bin/bash
APP_NAME=FN_small
RUN=RAW
NP=4

phyml-mpi -i roseo_concat.phy -q -d nt -m HKY85 -c 4 -t e 
