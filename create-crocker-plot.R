
L = 25
mymaxdimension = 1
mymaxscale = 0.35
timevals <- seq(0, 2000, by = 10)
numepsilon = 50

for (i in 1:100) {

  #Input file
  infile = paste0("/Users/lxian/Desktop/Vicsek_Analysis/eta_001/Data/data",sprintf("%03d",i),".csv")
  infile_load = read.csv(infile, header = FALSE)

  # Interval dataframe
  outfileInterval = paste0("/Users/lxian/Desktop/Vicsek_Analysis/eta_001/Interval_Data/intData",sprintf('%03d',i), ".RData")

  # CROCKER dataframe for distance matrix
  outfileBettiData = paste0("/Users/lxian/Desktop/Vicsek_Analysis/eta_001/Betti_Data/bettiData",sprintf('%03d',i), ".RData")

  colnames(infile_load) <- c("t","x","y","theta")

  # create Interval Data
  myclock <- system.time(
    homologydata <- foreach(thistime = timevals, .combine='rbind', .packages = c("pracma","TDA")) %dopar% {
      mydata = subset(infile_load,t==thistime,select=c("x","y","theta"))
      # in data001, find a subset of data001, t = thistime
      # only want 3 variabes, the last 3 columns
      newdata <- getIntervals(mydata,L,mymaxdimension,mymaxscale,thistime)
      # use "getIntervals" function, run "ripsDiag" function for "thistime" one time slice in times
    }
    # rbind all (outputs of "getIntervals") "newdata", call it "homologydata"
  )
  save(homologydata, file = outfileInterval)

  # create Betti Data
  griddata <- turnIntervalsIntoGrid(homologydata, numepsilon)
  colnames(griddata) <- c("time", "whichbetti", "epsilon", "betticount")

  save(griddata, file = outfileBettiData)

  print(i)
  print(myclock)

}
