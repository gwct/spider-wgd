#Libraries
library(mixtools)
library(tidyverse)

#Set working directory
setwd("./")

#Function for plotting fit mixture model from: https://www.stat.cmu.edu/~cshalizi/uADA/12/lectures/ch20.pdf
plot.normal.components <- function(mixture,component.number,...) {
  curve(mixture$lambda[component.number] *
          dnorm(x,mean=mixture$mu[component.number],
                sd=mixture$sigma[component.number]), add=TRUE, ...)
}

#Get a list of the species codes to latin names
spec <- read.csv("Species_List.csv",header=FALSE,sep="\t")

#For each file in the working directory
data=list()
mypath <- list.files(path=".", pattern="final") 
x=0
for(file in mypath){
 #if (grepl("TURTI", file)){
      x=x+1
        
      #Get the code and latin name
      name=strsplit(file, split='_',fixed=TRUE)
      name=name[[1]][4]
      species=spec[spec$V2==name,][1]
      
      #Read the Ks data and convert to a vector
      ks <- read.csv(file,header=FALSE)
      ks.vector <- na.omit(unlist(ks))
      ks <- ks.vector[ks.vector > 0.001 & ks.vector < 5]
      
      #Find the best number of components
      ks_boot <- boot.comp(ks, max.comp=10, mix.type="normalmix",
                             maxit=400, epsilon=1e-2)
    
      #Plot the Ks values as a histogram
      par(mfrow = c(1, 1)) 
      plot(hist(ks,breaks=101,xlim = c(0.1,5)),col="dodgerblue3",border="grey",
          xlab="Synonymous Divergence (Ks)", ylab="Density of Gene Duplicates",
          main=species,
          font.main=4, font.lab=1, font.sub=1,
          cex.main=2, cex.lab=1.5, cex.sub=1.5, cex.axis=1.5)
      
      #Add in the mixture model
      comp=0
      while (comp==0){
        Ks_k3 = c()
        try(Ks_k3 <- normalmixEM(ks,k=length(ks_boot$log.lik),maxit=1000,epsilon=0.01))
        if (is.null(Ks_k3)==FALSE){comp=1}
      }
      #Sort and prepare the data for that species
      tmp =  Ks_k3$mu
      tmp = sort(tmp)
      i = length(tmp)
      while(i <= 6) {
        i=i+1
        tmp[[i]] <- "0"
      }
      data[x]=list(c(name,tmp))
      
      #Plot an abline for the median value of each model
      for (i in Ks_k3$mu){
        abline(v = i, col="red", lwd=2, lty=2)
      }
      sapply(1:length(ks_boot$log.lik),plot.normal.components,mixture=Ks_k3,lwd=2)
      
      #Save as a pdf
      dev.print(pdf, paste(name, ".pdf", sep = ""))

 # }
}

#Convert data from list to data frame and save to file
data2=list()
x = 0
for (tmp in data) {  
  x=x+1    
  i = length(tmp)
  while(i <= 6) {
    i=i+1
    tmp[[i]] <- "0"
  }
  data2[x] <- list(tmp)
  print(tmp)
  
  
}

data2 <- as.data.frame(do.call(rbind, data2))
write.csv(data2, file="chel_mix_data.csv",row.names=FALSE)
