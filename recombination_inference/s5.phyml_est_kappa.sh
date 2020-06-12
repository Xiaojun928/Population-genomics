#!/bin/bash
#This step will estimate the [kappa](https://en.wikipedia.org/wiki/Mutation_bias#Transition-transversion_bias) parameter, i.e. transition/transversion bias
using [PhyML](https://github.com/stephaneguindon/phyml)

phyml-mpi -i roseo_concat.phy -q -d nt -m HKY85 -c 4 -t e 

#The input *.phy can be performed following these steps
#step1: get single copy orthologs gene families for interested strains
#step2: generate amino acid alignments
#step3: impose the pep alignments into DNA to get nuclaigns
#step4: remove all gaps in nuclaigns
#step5: concatenate nuclaigns and transform it into phylip format

