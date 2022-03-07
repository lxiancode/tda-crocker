
# this function is for "homologydata", output of function "turnIntervalsIntoGrid"

smoothBC <- function(homologydata,numEpsilons) {

  # Figure out which dimensions and what times we are dealing with
  dimensions = unique(homologydata$dimension)

  # alpha values
  alp = seq(0, 0.17, by = 0.01)

  # Set up data
  epsilons = seq(from=0,to=0.35,length=numEpsilons)
  times <- unique(homologydata$t)
  sm_bettiData <- NULL

  for (thisDimension in 0:max(dimensions)) {

    for (thisAlp in alp) {

      for (thisTime in times) {

        snapshot <- subset(homologydata, dimension==thisDimension & t==thisTime)

        res1 <- meshgrid(snapshot$birth,epsilons)
        res2 <- meshgrid(snapshot$death,epsilons)
        BIRTH <- res1$X
        start <- res1$Y - thisAlp
        start[start<0] = 0

        DEATH <- res2$X
        end <- res2$Y + thisAlp

        counts <- rowSums((BIRTH <= start) & (DEATH >= end))

        bettiRep <- seq(thisDimension,thisDimension,length=length(epsilons))
        timeRep <- seq(thisTime,thisTime,length=length(epsilons))
        alpRep <- seq(thisAlp,thisAlp,length=length(epsilons))

        sm_bettiData <- rbind(sm_bettiData,cbind(alpRep, timeRep, bettiRep, epsilons, counts))
      }
    }
  }
  sm_bettiData <- as.data.frame(sm_bettiData)
  names(sm_bettiData) <- c("alpha", "t","dimension","epsilon","betticount")
  return(sm_bettiData)
}
