# Sep 15, 2021
# Goal: compute order parameters (the variance of the angles is same as the magnitude of the mean of the velocity vectors)
# Eta = 0.01

# for every eta, there are 100 datasets
# for every eta, output an order matrix, 2000 x 100

var_op_eta_001 = NULL
for (i in 1:100) {

  # Input file
  infile = paste0("/Users/xianl/Downloads/eta=0.01/data", sprintf("%03d",i),".csv")
  infile_load = read.csv(infile, header = FALSE)

  colnames(infile_load)[1] <- "t"

  order = NULL
  var_t = NULL

  out <- system.time(
    for (j in 1:2000) {
      timesubset = subset(infile_load, t == j)
      heading = timesubset[,4]
      vx = cos(heading)
      vy = sin(heading)
      R2 = (sum(vx))^2 + (sum(vy))^2
      variance = 1-sqrt(R2)/300
      var_t = c(var_t, variance)
    }
  )
  var_op_eta_001 = cbind(var_op_eta_001, var_t)

  print(i)
  print(out)
}

save(var_op_eta_001, file = "var_op_eta_001.RData")
