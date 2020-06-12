require(NbClust)
require(dplyr)
require(tidyr)

ds_mtx <- read.table("dS_summary_wo_out.txt", as.is= T, header=T,check.names = F,
                     row.names = 1)
#test each K-determination methods, not all of them are applicable for the dataset
index.list <- c("kl", "ch", "hartigan","scott", "marriot", "trcovw", "tracew",
                "friedman","rubin", "cindex", "db", "silhouette", "duda","pseudot2", 
                "beale", "ratkowsky",
                "ball", "ptbiserial", "gap", "frey", "mcclain", "gamma","gplus","tau",
                "dunn", "hubert", "sdindex", 
                "dindex", "sdbw","ccc")

#ds_mtx <- ds_mtx[-1688,]
#Test each method to see if it's available for your dataset,
#available one will be included into index.list2
NbClust(ds_mtx[,-1], distance = 'euclidean',
        min.nc = 2, max.nc = 10, method = 'kmean',
        index= 'hubert')$Best.nc


##############Thermococcus_guaymasensis############################
index.list <- c("kl", "ch", "hartigan","cindex", "db", "silhouette", "duda","pseudot2", 
                "beale","ball", "ptbiserial", "gap", "frey", "mcclain",
                "dunn", 'hubert', "sdindex", 'dindex', "sdbw")
nb.roseo <- c()
for(i in index.list)
{
  a <- NbClust(ds_mtx[,-1], distance = 'euclidean',
               min.nc = 2, max.nc = 10, method = 'kmean',
               index= i)$Best.nc[1]
  print(i)
  print(a)
  nb.roseo <- c(nb.roseo,a)
}


###slower than for loop
#nb.roseo <- lapply(index.list, function(i)
#  NbClust(ds_mtx[,-1], distance = 'euclidean',
#          min.nc = 2, max.nc = 10, method = 'kmean',
#          index= i)$Best.nc)
table(nb.roseo)

pdf("K_votes_Roseovarius.pdf")
barplot(table(nb.roseo),main = "guaymasensis",xlab = 'K value', ylab = "# indices surpporting the number of clusters")
dev.off()



############cluster by K means method #########
roseo.kmean <- kmeans(ds_mtx, 2) #k=2 is determined from above results
table(roseo.kmean$cluster)
ds_mtx$cluster <- paste0('c', roseo.kmean$cluster)

# for each cluster, calculate the statistics (median; mean+-sd) for each genome pair
ds_mtx %>% gather(key= 'pair', value= 'dS', 1:120) %>%   ##2:529 column is dS value
  group_by(pair,cluster) %>%
  summarise(median= median(dS), mean= mean(dS), sd= sd(dS)) -> meandS
  #write.csv("Sulfurovum_cluster.csv")

meandS <- as.data.frame(meandS)
C1_mean_dS <- meandS[which(meandS[,2]=="c1"),]
C2_mean_dS <- meandS[which(meandS[,2]=="c2"),]
#for cluster1 mean
mean(C1_mean_dS[which(C1_mean_dS[,1] %in% rownames(pair.order)[1:3]),4])  #within C1
mean(C1_mean_dS[which(C1_mean_dS[,1] %in% rownames(pair.order)[43:120]),4])  #within C2
mean(C1_mean_dS[which(C1_mean_dS[,1] %in% rownames(pair.order)[4:42]),4])  #between C1_C2

#for cluster2 mean
mean(C2_mean_dS[which(C2_mean_dS[,1] %in% rownames(pair.order)[1:3]),4])  #within C1
mean(C2_mean_dS[which(C2_mean_dS[,1] %in% rownames(pair.order)[43:120]),4])  #within C2
mean(C2_mean_dS[which(C2_mean_dS[,1] %in% rownames(pair.order)[4:42]),4])  #between C1_C2


#for cluster1 median
median(C1_mean_dS[which(C1_mean_dS[,1] %in% rownames(pair.order)[1:3]),3])  #within C1
median(C1_mean_dS[which(C1_mean_dS[,1] %in% rownames(pair.order)[43:120]),3])  #within C2
median(C1_mean_dS[which(C1_mean_dS[,1] %in% rownames(pair.order)[4:42]),3])  #between C1_C2

#for cluster2 median
median(C2_mean_dS[which(C2_mean_dS[,1] %in% rownames(pair.order)[1:3]),3])  #within C1
median(C2_mean_dS[which(C2_mean_dS[,1] %in% rownames(pair.order)[43:120]),3])  #within C2
median(C2_mean_dS[which(C2_mean_dS[,1] %in% rownames(pair.order)[4:42]),3])  #between C1_C2


ds_mtx %>% 
  select(famid, cluster) %>%
  group_by(cluster) %>% 
  write.csv("Roseovarius_cluster_gene.csv")

ds_mtx %>% filter(cluster == 'c2') %>% write.csv("176genes.csv")
ds_mtx %>% filter(cluster == 'c1') %>% write.csv("kukulkanii_cluster1_40genes.csv")

ds_mtx %>% filter(cluster == 'c1') -> ds_c1
library(pheatmap)
pheatmap(as.matrix(ds_c1[,2:79]),cluster_rows = F)



clade <- read.table("genome_clade.txt",sep = "\t",stringsAsFactors = F)
###order the column based on genome pairs
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

#ds_mtx <- read.table("identity_summary194.txt", as.is= T, header=T,check.names = F,
 #                    row.names = 1)

##get wanted genome pairs in dS.df by intersecting two groups of genome pair
pairs.wanted <- intersect(gnm.pairs,colnames(ds_mtx))
pair.order <- pair.to.label[pairs.wanted,]
pair.order <- pair.order[order(pair.order[,2]),]

ordered.dS <- ds_mtx[,row.names(pair.order)]
ordered.dS <- rbind(ordered.dS,as.character(pair.order[,2]))
#row.names(ordered.dS)[2561] <- "class_label" ## 1more rows
#diff <- setdiff(rownames(ordered.dS),rownames(ds_mtx))
write.table(ordered.dS,file = "ordered_dS_wo_out.txt",sep = "\t",quote = F)
write.table(ordered.dS,file = "ordered_identOG914.txt",sep = "\t",quote = F)
