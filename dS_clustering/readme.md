This pipeline identifies outlier genes subjected to recombination with divergent lineages. 
Please refer to [Sun Y, Luo H. Homologous Recombination in Core Genomes Facilitates Marine Bacterial Adaptation. Appl Environ Microbiol 2018](https://pubmed.ncbi.nlm.nih.gov/29572211/) for more details


**software**: YN00 programe from [PAML](http://evomics.org/resources/software/molecular-evolution-software/paml/)

**Input**: nulceotide alignments of single-copy core genes

**Output**: multiple clusters of genes and corresponding mean/median ds values


In case that the genomes are not compelete (e.g SAG), we may have limited single-copy core gene families. One possible solution is to employ missing data imputation on the dS matrix. [Here](https://www.r-bloggers.com/2019/06/intoducing-clustimpute-a-new-approach-for-k-means-clustering-with-build-in-missing-data-imputation/), the author provided a fantastic way to do this.
