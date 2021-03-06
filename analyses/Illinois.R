# Illinois.R

dir.create("~/ncov/state_rILI")
region <- as.character(unique(dat$region))

dat <- read.csv("analyses/ili-data/state-data-2020-03-13.csv")
good.regions <- c(1:length(regions))
bad.regions <- c(10, 31, 40, 53, 54)

for(r in good.regions[-bad.regions]){
  IL.ind <- which(dat$region == region[r])
  IL <- dat[IL.ind, ]
  
  # IL[226:234,]
  
  ord <- order(IL$year, IL$week)
  IL <- IL[ord, ]
  
  date.vec <- as.Date(x = paste(IL$year, IL$week, "1", sep = "-"), format = "%Y-%U-%u")
  na.date <- which(is.na(date.vec))
  IL <- IL[-na.date, ]
  IL$date <- as.Date(x = paste(IL$year, IL$week, "1", sep = "-"), format = "%Y-%U-%u")
  table(IL$week)
  
  start.ind <- which(IL$week==29)
  
  
  # plot(x = date.vec, y = IL$rili_minus, type = "l")
  png(paste0("~/ncov/state_rILI/", region[r], '_rILI.png'))
  
  plot(x = tail(date.vec, 34), y = tail(IL$rili_minus, 34), type = "l", col = 2,
       ylim = c(min(IL$rili_minus, na.rm = TRUE),
                max(IL$rili_minus, na.rm = TRUE)),
       xlab = "Date", ylab = "% ILI visits",
       main = paste0(region[r], "'s rILI Seasonality"))
  
  for(i in 1:length(start.ind)){
    temp.ind <- start.ind[i]:(start.ind[i] + 33)
    lines(x = tail(date.vec, 34), y = IL$rili_minus[temp.ind], col = "gray")
  }
  lines(x = tail(date.vec, 34), y = tail(IL$avg_rili_minus1, 34), lwd = 2)
  lines(x = tail(date.vec, 34), y = tail(IL$rili_minus, 34), type = "l", col = 2, lwd = 2)
  legend("topleft", legend=c("2019-2020", "Seasonal Average", "Previous Years"),
         col=c("red", "black", "gray"), lty=1, cex=0.8)
  
  dev.off()
}
