#!/bin/bash

APP_NAME=AMD_small
NP=1
RUN="RAW"


echo \>\>\> STEP2.s1: preparing recfile ...
./STEP2.s1_1*.py
./STEP2.s1_2*.sh > log.STEP2.s1.txt

echo \>\>\> STEP2.s2: estimating partt Ne ...
./STEP2.s2_1*.py
./STEP2.s2_2*.sh > log.STEP2.s2.txt

echo \>\>\> STEP2.s3: averaging partt Ne ...
./STEP2.s3_1*.py
./STEP2.s3_2*.sh > log.STEP2.s3.Ne_and_mu.txt

echo \>\>\> STEP2.s4: estimating overall Ne ...
./STEP2.s4_1*.py
./STEP2.s4_2*.sh > log.STEP2.s4.txt

echo \>\>\> STEP2.s5: running chromocombine ...
./STEP2.s5*.sh > log.STEP2.s5.txt

