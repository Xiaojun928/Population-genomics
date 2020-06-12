source("F:/collaboration/pipelines/Finestructure/FinestructureLibrary.R")
some.colors<-MakeColorYRP() # these are yellow-red-purple
some.colorsEnd<-MakeColorYRP(final=c(0.2,0.2,0.2)) # as above, but with a dark grey final for capped values
### Define our input files

setwd("F:/collaboration/Minglei/190731_re-analysis/06_finestructure/roseo")
#setwd("F:/collaboration/Danli/draft")
chunkfile<-"my_res.chunkcounts.out" ## chromopainter chunkcounts file
mcmcfile<-"my_res.mcmc.xml" ## finestructure mcmc file
treefile<-"my_res.mcmc.tree.xml" ## finestructure tree file
###### READ IN THE CHUNKCOUNT FILE
dataraw<-as.matrix(read.table(chunkfile,row.names=1,header=T,skip=1,check.names = F)) # read in the pairwise coincidence 

###### READ IN THE MCMC FILES
#mcmcxml<-xmlTreeParse(mcmcfile) ## read into xml format
#mcmcdata<-as.data.frame.myres(mcmcxml) ## convert this into a data frame

###### READ IN THE TREE FILES
treexml<-xmlTreeParse(treefile) ## read the tree as xml format
ttree<-extractTree(treexml) ## extract the tree into ape's phylo format
## If you dont want to plot internal node labels (i.e. MCMC posterior assignment probabilities)
## now is a good time to remove them via:
#     ttree$node.label<-NULL
## Will will instead remove "perfect" node labels
ttree$node.label[ttree$node.label=="1"] <-""
## And reduce the amount of significant digits printed:
ttree$node.label[ttree$node.label!=""] <-format(as.numeric(ttree$node.label[ttree$node.label!=""]),digits=2)

tdend<-myapetodend(ttree,factor=1) # convert to dendrogram format

fullorder<-labels(tdend) # the order according to the tree
#datamatrix<-dataraw[rev(fullorder),fullorder] #to make the diagonal from upper left to bottom right
datamatrix<-dataraw[fullorder,fullorder] #to make the diagonal from upper right to bottom left


#tmatmax<-1200 # cap the heatmap
tmpmat<-datamatrix 
#tmpmat[tmpmat>tmatmax]<-tmatmax # 

## Population averages
mapstate<-extractValue(treexml,"Pop") # map state as a finestructure clustering
mapstatelist<-popAsList(mapstate)
popmeanmatrix<-getPopMeanMatrix(datamatrix,mapstatelist)

tmpmat<-popmeanmatrix
library("RColorBrewer")
jet.colors <- colorRampPalette(c("blue", "#007FFF", "cyan",
                                 "yellow", "#FF7F00", "red"))
pdf(file="roseo_fs2.pdf",height=12,width=12)
#plotFinestructure(tmpmat,dimnames(tmpmat)[[1]],dend=tdend,cols=some.colorsEnd,cex.axis=0.6,edgePar=list(p.lwd=0,t.srt=90,t.off=-0.1,t.cex=0.8))
plotFinestructure(tmpmat,dimnames(tmpmat)[[1]],dend=tdend,cols=jet.colors(50),cex.axis=1.6,edgePar=list(p.lwd=0,t.srt=90,t.off=-0.1,t.cex=0.8))
dev.off()



##################################################################
## Finestructure R Example
## Author: Daniel Lawson (dan.lawson@bristol.ac.uk)
## For more details see www.paintmychromosomes.com ("R Library" page)
## Date: 14/02/2012
## Notes:
##    These functions are provided for help working with fineSTRUCTURE output files
## but are not a fully fledged R package for a reason: they are not robust
## and may be expected to work only in some very specific cases! USE WITH CAUTION!
## SEE FinestrictureLibrary.R FOR DETAILS OF THE FUNCTIONS
##
## Licence: GPL V3
## 
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.

##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.

##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.

source("FinestructureLibrary.R") # read in the R functions, which also calls the needed packages
setwd("F:/collaboration/Minglei/190731_re-analysis/06_finestructure/marino")
## make some colours
#some.colors<-MakeColorYRP() # these are yellow-red-purple
#some.colorsEnd<-MakeColorYRP(final=c(0.2,0.2,0.2)) # as above, but with a dark grey final for capped values

chunkfile<-"my_res.chunkcounts.out" ## chromopainter chunkcounts file
mcmcfile<-"my_res.mcmc.xml" ## finestructure mcmc file
treefile<-"my_res.mcmc.tree.xml" ## finestructure tree file
###### READ IN THE CHUNKCOUNT FILE
dataraw<-as.matrix(read.table(chunkfile,row.names=1,header=T,skip=1,check.names = F)) # read in the pairwise coincidence 

###### READ IN THE MCMC FILES
#mcmcxml<-xmlTreeParse(mcmcfile) ## read into xml format
#mcmcdata<-as.data.frame.myres(mcmcxml) ## convert this into a data frame

###### READ IN THE TREE FILES
treexml<-xmlTreeParse(treefile) ## read the tree as xml format
ttree<-extractTree(treexml) ## extract the tree into ape's phylo format
## If you dont want to plot internal node labels (i.e. MCMC posterior assignment probabilities)
## now is a good time to remove them via:
#     ttree$node.label<-NULL
## Will will instead remove "perfect" node labels
ttree$node.label[ttree$node.label=="1"] <-""
## And reduce the amount of significant digits printed:
ttree$node.label[ttree$node.label!=""] <-format(as.numeric(ttree$node.label[ttree$node.label!=""]),digits=2)

tdend<-myapetodend(ttree,factor=1) # convert to dendrogram format

fullorder<-labels(tdend) # the order according to the tree


########################
## COANCESTRY MATRIX

datamatrix<-dataraw[fullorder,fullorder] # reorder the data matrix

#tmatmax<-500 # cap the heatmap
tmpmat<-datamatrix 
#tmpmat[tmpmat>tmatmax]<-tmatmax # 
jet.colors <- colorRampPalette(c("blue", "#007FFF", "cyan",
                                  "yellow", "#FF7F00", "red"))
pdf(file="EastAsiaSimpleCoancestry.pdf",height=12,width=12)
plotFinestructure(tmpmat,dimnames(tmpmat)[[1]],dend=tdend,cols=jet.colors(50),cex.axis=1.5,edgePar=list(p.lwd=0,t.srt=90,t.off=-0.1,t.cex=0.8))
dev.off()

## Population averages
mapstate<-extractValue(treexml,"Pop") # map state as a finestructure clustering
mapstatelist<-popAsList(mapstate)
popmeanmatrix<-getPopMeanMatrix(datamatrix,mapstatelist)

#tmatmax<-500 # cap the heatmap
tmpmat<-popmeanmatrix
#tmpmat[tmpmat>tmatmax]<-tmatmax # 
pdf(file="marino_fs.pdf",height=12,width=12)
plotFinestructure(tmpmat,dimnames(tmpmat)[[1]],dend=tdend,cols=jet.colors(50),cex.axis=1.5,edgePar=list(p.lwd=0,t.srt=90,t.off=-0.1,t.cex=0.8))
dev.off()

