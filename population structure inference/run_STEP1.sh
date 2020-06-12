#!/bin/bash
APP_NAME=AMD_small
NP=1
RUN="RAW"

#echo \>\>\> Generating genome pos table ...
#./generate_genome_pos_table.py

#echo \>\>\> STEP1.s1.rename_xmfa_header ...
#./STEP1.s1.*.py

#echo \>\>\> STEP1.s2.extract_seq_of_target_genomes ...
#./STEP1.s2.*.py

#echo \>\>\> STEP1.s3.parse_biallelic_SNP_to_phase_file ...
#./STEP1.s3.*.py

echo \>\>\> STEP1.s4.validate_phase_file ...
./STEP1.s4.*.py

