##the chr_len and pls_len should be modified based on your data

C1.snp <- read.table("C1_SNP_pos.txt")[,1]
C2.snp <- read.table("C2_SNP_pos.txt")[,1]
C1C2.snp <- read.table("C1C2_SNP_pos.txt")[,1]

snp.dens.plot <- function(input.snp)
{
  snp <- as.numeric(input.snp)
  chr_len <- 3177654
  
  k <- 10000
  end <- 3290000
  internal <- seq(1, end+k, k)
  #head(internal)
  #tail(internal)
  head(snp)
  
  x <- cut(snp, breaks = internal)
  #head(x)
  #tail(x)
  head(table(x))
  
  
  ### Delete the 0 SNP in the plot
  ### Plot the SNP group by group (continous coordinate)
  y <- as.data.frame(table(x))
  #head(y)
  #tail(y)
  y$mid <- internal[-1]-1 - k/2
  
  y <- y[y$Freq!=0, ]
  #head(y)
  #tail(y)
  #plot(y$mid, y$Freq, type= 'l')
  
  z <- list()
  j <- 0
  df <- y[1, c('mid', 'Freq')]
  for (i in seq(2, nrow(y), 1)) {
    
    if (y$mid[i]-y$mid[i-1] != k) {
      j <- j+1
      z[[j]] <- df
      df <- data.frame()
    }
    df <- rbind(df, y[i, c('mid', 'Freq')])
    
  }
  # last test
  j <- j+1
  z[[j]] <- df
  
  length(z)
  
  #plot(y$mid, y$Freq, ylim= c(0, 1500), xlim= c(0, 3500000), type= 'n', ylab= 'Number of SNPs', xlab= '')
  plot(y$mid, y$Freq, ylim= c(0, 800), xlim= c(0, 3500000), type= 'n', axes=F,
       ylab= 'Number of SNPs', xlab= '', 
       #yaxs= 'i', xaxs= 'i',
       frame.plot = T)
  axis(side= 1, at= seq(0, 3500000, 500000), labels = seq(0, 3.5, 0.5))
  axis(side= 2, at= seq(0, 800,100), las= 1)
  for (i in (seq(length(z)))) {
    points(z[[i]], type= 'l')
    #  points(z[[i]], pch= '.', cex= 0.5, col= 'blue')
    #  points(z[[i]], pch= 3, cex= 2)
  }
  abline(v= chr_len, lty= 2) 
}

pdf(file = "SNP_dens_plot.pdf",height = 8,width = 6)
par(mfrow=c(3,1))
snp.dens.plot(C1.snp)
for (i in 1:length(C1.snp))
{
  points(C1.snp[i],1,pch=3)
}
snp.dens.plot(C2.snp)
snp.dens.plot(C1C2.snp)

rec.region <- read.table("rec_regions.pos.txt",sep="\t")
rec.col <- rgb(0,0,1,alpha = 0.2)
for(i in 1:dim(rec.region)[1])
{
  rect(rec.region[i,1], -100, rec.region[i,2], 900, density = NULL, angle = 45,
       col = rec.col, border = NA, lty = par("lty"), lwd = par("lwd"))
}
#### genes with anomalously large dS
ds <- read.table('ds_chr_genes.txt', sep= '\t', as.is=T)
ds2 <- read.table('ds_pls_genes.txt', sep= '\t', as.is = T)
str(ds)
str(ds2)
chr_len <- 3177654
ds2$V2 <- ds2$V2 + chr_len
ds2$V3 <- ds2$V3 + chr_len

ds3 <- rbind(ds, ds2)
ds.mid <- (ds3$V2 + ds3$V3)/2
## mark the position of dS genes
axis(side= 1, at = ds.mid, col.ticks = 'red', tcl= 0.3, labels = F, lwd= 0.2)

dev.off()
