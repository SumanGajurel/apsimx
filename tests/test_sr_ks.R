### Testing SR KS pedotransfer function

library(apsimx)
packageVersion("apsimx")
### Need versions 2.8.215 at least
library(ggplot2)

run.test.ks <- get(".run.local.tests", envir = apsimx.options)

### Motivating example from Ke Liu
### Australia is between 112 and 154 longitude
###          and between -10 and -44 latitude
if(run.test.ks){

  clay <- seq(1, 100, by = 5)
  sand <- seq(1, 100, by = 5)
  om <- seq(0, 15, by = 2)
  
  grd0 <- expand.grid(clay = clay, sand = sand, om = om)
  grd0$total <- grd0$clay + grd0$sand
  grd <- subset(grd0, total <= 100)
  dim(grd)
  grd$ks <- apsimx:::sr_ks(grd$clay, grd$sand, grd$om)
  summary(grd$ks)

  ### Extreme outlier, when clay = 1, sand = 81 and om = 6
  na.omit(grd[grd$ks > 13000, ])
  
  summary(grd[is.na(grd$ks), ])
  ## The function seems to work ok as long as clay is greater than 1
  summary(grd[grd$clay > 1,])
  
  grd2 <- subset(grd, clay > 1)
  
  ggplot(data = grd2, aes(x = clay, y = ks, color = sand)) + 
    facet_wrap(~om) + 
    geom_point()

}

if(FALSE){

  soil.grid <- matrix(c(145, 144, -35, -34), ncol = 2)
  sls.wm <- get_worldmodeler_soil_profile(lonlat = soil.grid)
  s.wm <- get_worldmodeler_soil_profile(lonlat = c(145.375, -35.625))
  plot(s.wm[[1]], property = "Carbon")
  plot(s.wm[[1]], property = "water")
  
  isl <- get_isric_soil_profile(lonlat = c(145.375, -35.625))
  isl$soil$KS
  
  plot(isl, property = "Carbon")
  plot(isl, property = "water")
  plot(isl, property = "KS")
  
  isl$soil[, c("KS", "ParticleSizeClay", "ParticleSizeSand", "Carbon")]
  isl$soil$KS
  isl.clay <- isl$soil$ParticleSizeClay
  isl.sand <- isl$soil$ParticleSizeSand
  isl.om <- isl$soil$Carbon * 2
  
  longs <- seq(114, 153, by = 5)
  isric.tmps <- vector('list', length = length(longs))
  for(i in seq_along(longs)){
    cat("Getting soil for longitude:", longs[i], "\n")
    isric.tmps[[i]] <- get_isric_soil_profile(lonlat = c(longs[i], -24.625))  
  }
  
  plot(isric.tmps[[1]], property = "KS")
  plot(isric.tmps[[1]], property = "KS")
  
  sapply(isric.tmps, FUN = \(x) range(x$soil$KS))
  
  apsimx:::sr_ks(isl.clay, isl.sand, isl.om)
  
  clay <- seq(1, 100, by = 5)
  sand <- seq(1, 100, by = 5)
  om <- seq(0, 15, by = 2)
  
  grd <- expand.grid(clay = clay, sand = sand, om = om)
  dim(grd)
  grd$ks <- apsimx:::sr_ks(grd$clay, grd$sand, grd$om)
  summary(ans)
  
  hist(grd$ks)
  
  na.omit(grd[grd$ks < 1, ])
  
  ggplot(data = grd, aes(x = clay, y = ks)) + 
    facet_wrap(~ om) + 
    geom_point()
  
  ggplot(data = grd, aes(x = sand, y = ks)) + 
    facet_wrap(~ om) + 
    geom_point()
  
  slg <- get_slga_soil_profile(lonlat = c(145.375, -35.625), fix = TRUE)
  slg$soil$KS
  
  plot(slg, property = "Carbon")
  plot(slg, property = "water")
  plot(slg, property = "KS")
}