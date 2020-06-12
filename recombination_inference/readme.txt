Preparation files:
1. genomic files in fasta format (for step1)
2. nwk genome tree with outgroups pruned (for step5)
3. Kappa value (for step5 optional)

step1: generate whole genome alignment (WGA) file
s1.make_mauve_align.sh 

setp2: extract core local co-linear blocks (LCBs)
s2.get_coreLCB.sh

(step3-4 is optional if you only use clonalFrameML to calculate r/m and Rho/Theta)
step3: sort the WGA based on a reference genome (a complete genome is better)
s3.sort_xmfa_block.pl

step4: concatenate WGA based on a reference genome, the output is a fasta file
s4.conct_LCB.pl

step5: run clonalframeML
s5.clonalFrameML_recomb.sh

step6: get the r/m ratio from file *output/*out.em.txt
r/m = R/theta/(1/delta)*nu


Optinal steps: Estimate kappa (transition/transversion) with PhyML
This kappa value can be used as input of clonalFrameML, but the r/m and Rho/theta seem to be similar whethere you provide this parameter.
step6_1: get single copy orthologs gene families for interested strains
step6_2: generate amino acid alignments
step6_3: impose the pep alignments into DNA to get nuclaigns
step6_4: remove all gaps in nuclaigns
step6_5: concatenate nuclaigns and transform it into phylip format
step6_6: run PhyML, get the kappa from *phy_phyml_stats.txt
s6.phyml_roseo.sh

