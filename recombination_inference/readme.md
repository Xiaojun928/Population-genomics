This pipeline can infer the recombination events and the Rho/theta, r/m ratio

**Input1**: whole-genome sequences of your strains (fasta file)
**Input2**: concatenation-based genome tree of your strains
**Output**: please see [here](https://github.com/xavierdidelot/clonalframeml/wiki)

Preparation files:
1. genomic files in fasta format (for step1)
2. nwk genome tree with outgroups pruned (for step5)
3. Kappa value (for step5 optional)

step1: generate whole genome alignment (WGA) file
> s1.make_mauve_align.sh

setp2: extract core local co-linear blocks (LCBs)
> s2.get_coreLCB.sh

(step3-4 is optional if you only use clonalFrameML to calculate Rho/Theta and r/m )
step3: sort the WGA based on a reference genome (a closed complete genome is better)
> s3.sort_xmfa_block.pl

step4: concatenate WGA based on a reference genome, the output is a fasta file
> s4.conct_LCB.pl

step5: run clonalframeML
> s5.clonalFrameML_recomb.sh

step6: get the r/m ratio from file *output/*out.em.txt

* r/m = Rho/theta/(1/delta)*nu 

