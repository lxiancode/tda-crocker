
# creates crocker plots, which can be turned in to a crocker stack along the dimension of alpha

for (i in alp) {
  image_title = paste0("CROCKER Plot of alpha = ", i, ", b0")
  image_subtitle = "dataset100, eta = 0.02"
  snapshot <- subset(sm_bettiData, alpha == i)
  cont = contourGenerator(snapshot, dim = 0, maxYlim = 0.4, image_tit = image_title, image_subtit = image_subtitle)
  j = sub("\\.", "", i)
  k = as.numeric(j)
  filename = paste0("/Users/lxian/Desktop/Vicsek_Analysis/eta_002/eta_002_al_", sprintf("%03d",k),"_contour_d0", ".png")
  ggsave(filename, plot = last_plot(), width = 50, height = 25, units = "cm")
}
