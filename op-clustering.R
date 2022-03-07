
# Sep 15, 2021
# Goal: order parameter clustering analysis for Experiment 2
# Eta = 0.01, 0.1, 1

library(TDA)
library(readr)
library(pracma)
library(ggplot2)
library(reshape)
library(stringi)
library(kmed)
library(cluster)
library(graphics)
library(stats)
library(factoextra)
library(raster)
library(plotrix)
rev_heat_color = function(x) rev(heat.colors(x))


varop_matrix = cbind(var_op_eta_001, var_op_eta_01, var_op_eta_1)

distM_varop_c2 = as.matrix(dist(t(varop_matrix), method = "euclidean", diag = FALSE, upper = FALSE))

r1<-raster(nrow=300, ncol=300, xmn=0, xmx=300, ymn=0, ymx=300)
brk = seq(1, 12000, by = 300)
colnum = length(brk)-1

r1[] <- distM_varop_c2
rev_heat_color = function(x) rev(heat.colors(x))
plot(r1, breaks = brk, col = rev_heat_color(colnum), legend = T, box = T, legend.shrink = 1, legend.width = 1)
title(main = "Distance Matrix of var(theta), Exp 2", font.main = 4)

result <- pam(distM_varop_c2, k = 3)

# the number of datasets clustered per group
datagroup = as.data.frame(result$cluster)
colnames(datagroup) <- "cluster"
datagroup$name <- 1:300
datagroup$eta <- c(rep(1,100),rep(2,100),rep(3,100))

# the number of datasets in clusters
table(result$cluster)

# the center of each cluster
result$id.med

paraGroupNum = NULL
for (i in 1:length(result$id.med)) {
  cluster = result$id.med[i]
  if (nchar(cluster) < 3) {
    paraGroupNum = 1
    datagroup$Newcluster[datagroup$cluster==i] = paraGroupNum
  } else {
    fdigit = substr(cluster, 1, 1)
    paraGroupNum = as.numeric(fdigit)+1
    datagroup$Newcluster[datagroup$cluster==i] = paraGroupNum
  }
}

# number of datasets in new clusters
table(datagroup$Newcluster)

# accuracy
mean(datagroup$eta == datagroup$Newcluster)
