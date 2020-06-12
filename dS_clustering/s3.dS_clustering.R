require(NbClust)
require(dplyr)
require(tidyr)

ds_mtx <- read.table("dS_summary.txt", as.is= T, header=T,check.names = F,
                     row.names = 1)

###order the column based on genome pairs
clade <- read.table("genome_clade.txt",sep = "\t",stringsAsFactors = F)
##generate the genome pairs and assign class label to genome pair
gnm.pairs <- c()
labels <- c()
k <- 1
for(i in 1:dim(clade)[1])
{
  for(j in 1:dim(clade)[1])
  {
    gnm.pair <- paste(clade[i,1],clade[j,1],sep = "__")
    label <- paste(sort(c(clade[i,2],clade[j,2])),collapse = "_")
    gnm.pairs <- c(gnm.pairs,gnm.pair)
    labels <- c(labels,label)
  }
}

pair.to.label <- data.frame(gnm.pairs,labels)
rownames(pair.to.label) <- gnm.pairs

##get interested genome pairs in dataframe by intersecting two groups of genome pair
pairs.wanted <- intersect(gnm.pairs,colnames(ds_mtx))
pair.order <- pair.to.label[pairs.wanted,]
pair.order <- pair.order[order(pair.order[,2]),]

ordered.dS <- ds_mtx[,row.names(pair.order)]
#ordered.dS <- rbind(ordered.dS,as.character(pair.order[,2]))

#write.table(ordered.dS,file = "ordered_dS.txt",sep = "\t",quote = F)


#The list of K-determination methods
index.list0 <- c("kl", "ch", "hartigan","scott", "marriot", "trcovw", "tracew",
                "friedman","rubin", "cindex", "db", "silhouette", "duda","pseudot2", 
                "beale", "ratkowsky",
                "ball", "ptbiserial", "gap", "frey", "mcclain", "gamma","gplus","tau",
                "dunn", "hubert", "sdindex", 
                "dindex", "sdbw","ccc")


#Not all  K-determination methods are applicable for the dataset
#So, test each method to see if it's applicable for your dataset,
#applicable one will be included into index.list
for (i in index.list0)
{
 NbClust(ordered.dS, distance = 'euclidean',
        min.nc = 2, max.nc = 10, method = 'kmean',
        index= i)$Best.nc 
}


##############Applicable methods for the test dataset######################
index.list <- c("kl", "ch", "hartigan","cindex", "db", "silhouette", "duda","pseudot2", 
                "beale","ball", "ptbiserial", "gap", "frey", "mcclain",
                "dunn", 'hubert', "sdindex", 'dindex', "sdbw")
nb.roseo <- c()
for(i in index.list)
{
  a <- NbClust(ordered.dS, distance = 'euclidean',
               min.nc = 2, max.nc = 10, method = 'kmean',
               index= i)$Best.nc[1]
  print(i)
  print(a)
  nb.roseo <- c(nb.roseo,a)
}

table(nb.roseo)

pdf("K_votes.pdf") ##plot the votes number for each K value
barplot(table(nb.roseo),main = "guaymasensis",xlab = 'K value', ylab = "# indices surpporting the number of clusters")
dev.off()



############cluster by K means method #########
roseo.kmean <- kmeans(ordered.dS, 2) #k=2 is determined from above results
table(roseo.kmean$cluster)
ordered.dS$cluster <- paste0('c', roseo.kmean$cluster)

# for each cluster, calculate the statistics (median; mean+-sd) for each genome pair
ordered.dS %>% gather(key= 'pair', value= 'dS', 1:(dim(ordered.dS)[2]-1)) %>%   ##2:529 column is dS value
  group_by(pair,cluster) %>%
  summarise(median= median(dS), mean= mean(dS), sd= sd(dS)) -> meandS

meandS <- as.data.frame(meandS)
C1_mean_dS <- meandS[which(meandS[,2]=="c1"),]
C2_mean_dS <- meandS[which(meandS[,2]=="c2"),]

#for cluster1 mean
R1.pairs <- rownames(pair.order[which(pair.order$labels=="C1_C1"),])
R2.pairs <- rownames(pair.order[which(pair.order$labels=="C2_C2"),])
R1.R2.pairs <- rownames(pair.order[which(pair.order$labels=="C1_C2"),])

mean(C1_mean_dS[which(C1_mean_dS[,1] %in% R1.pairs),4])  #within clade R-I
mean(C1_mean_dS[which(C1_mean_dS[,1] %in% R2.pairs),4])  #within clade R-II
mean(C1_mean_dS[which(C1_mean_dS[,1] %in% R1.R2.pairs),4])  #between clade R-I and Clade R-II

#for cluster2 mean
mean(C2_mean_dS[which(C2_mean_dS[,1] %in% R1.pairs),4])  #within clade R-I
mean(C2_mean_dS[which(C2_mean_dS[,1] %in% R2.pairs),4])  #within clade R-II
mean(C2_mean_dS[which(C2_mean_dS[,1] %in% R1.R2.pairs),4])  #between clade R-I and Clade R-II


#for cluster1 median
median(C1_mean_dS[which(C1_mean_dS[,1] %in% R1.pairs),3])  #within Clade R-I
median(C1_mean_dS[which(C1_mean_dS[,1] %in% R2.pairs),3])  #within Clade R-II
median(C1_mean_dS[which(C1_mean_dS[,1] %in% R1.R2.pairs),3])  #between clade R-I and Clade R-II

#for cluster2 median
median(C2_mean_dS[which(C2_mean_dS[,1] %in% R1.pairs),3])  #within Clade R-I
median(C2_mean_dS[which(C2_mean_dS[,1] %in% R2.pairs),3])  #within Clade R-II
median(C2_mean_dS[which(C2_mean_dS[,1] %in% R1.R2.pairs),3])  #between clade R-I and Clade R-II


##write the dS for interested gene cluster, "c*" is determined by the mean/median ds of each cluster
ordered.dS %>% filter(cluster == 'c2') %>% write.csv("outlier_genes.csv")

