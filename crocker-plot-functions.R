
# load libraries
library("TDA")
library("pracma")
library("ggplot2")
library("parallel")
library("doParallel")

cluster <- makeCluster(34, type="PSOCK") # Chad's code
registerDoParallel(cluster)
getDoParWorkers()

# functions

getIntervals <- function(mydata,L,mymaxdimension,mymaxscale,thistime){
  # takes in a time slice
  # normalizes to 1
  mydata$x <- mydata$x/L#*2*pi
  mydata$y <- mydata$y/L#*2*pi
  mydata$theta <- mydata$theta/(2*pi)
  xgrid <- meshgrid(mydata$x,mydata$x)
  ygrid <- meshgrid(mydata$y,mydata$y)
  thetagrid <- meshgrid(mydata$theta,mydata$theta)
  M1 <- pmin(abs(xgrid$X - xgrid$Y),1 - abs(xgrid$X - xgrid$Y))^2
  M2 <- pmin(abs(ygrid$X - ygrid$Y),1 - abs(ygrid$X - ygrid$Y))^2
  M3 <- pmin(abs(thetagrid$X -thetagrid$Y),1 - abs(thetagrid$X - thetagrid$Y))^2
  M <- sqrt(M1+M2+M3)
  # create the distance matrix M

  results = ripsDiag(X = M, dist = "arbitrary", maxdimension = mymaxdimension, maxscale = mymaxscale, library = "GUDHI", printProgress = FALSE)

  results <- results$diagram
  return(data.frame(t = rep(thistime,nrow(results)), dimension = results[,1], birth = results[,2], death = results[,3]))
  # creates interval data
}



turnIntervalsIntoGrid <- function(homologydata, numEpsilons) {
  # Figure out which dimensions and what times we are dealing with
  dimensions = unique(homologydata$dimension)

  # Set up data
  deaths <- homologydata$death
  epsilons = seq(from = 0,
                 to = 0.35,
                 length = numEpsilons)
  times <- unique(homologydata$t)
  bettiData <- NULL
  for (thisDimension in 0:max(dimensions)) {
    for (thisTime in times) {
      snapshot <-
        subset(homologydata, dimension == thisDimension &
                 t == thisTime)
      res1 <- meshgrid(snapshot$birth, epsilons)
      res2 <- meshgrid(snapshot$death, epsilons)
      BIRTH <- res1$X
      EPS <- res1$Y
      DEATH <- res2$X
      counts <- rowSums((BIRTH <= EPS) & (DEATH >= EPS))
      bettiRep <-
        seq(thisDimension, thisDimension, length = length(epsilons))
      timeRep <- seq(thisTime, thisTime, length = length(epsilons))
      bettiData <-
        rbind(bettiData, cbind(timeRep, bettiRep, epsilons, counts))
    }
  }

  bettiData <- as.data.frame(bettiData)
  names(bettiData) <- c("t", "dimension", "epsilon", "betticount")
  return(bettiData)
}


contourGenerator = function(bettiData, dim, maxYlim) {
# generate crocker plots

  p <- ggplot(subset(bettiData, bettiData$whichbetti == dim), aes(x = time, y = epsilon, z = betticount)) + geom_contour( breaks = c(1,2,3,4,5), aes(colour=..level..)) +
    theme_bw() +
    scale_colour_gradientn(limits = c(1,5), colours = rainbow(5), guide = "legend") +
    scale_x_continuous(expand = c(0,0)) +
    ylim(0, maxYlim) +
    guides(colour = guide_legend(override.aes = list(size = 4))) + labs(x = "Simulation time t", y = "Proximity Parameter e")

  return(p)

}
