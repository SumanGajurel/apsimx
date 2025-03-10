
require(apsimx)

run.test.slga.workflow <- get(".run.local.tests", envir = apsimx.options)
#### This takes too long for routine testing
run.test.slga.workflow <- FALSE

if(run.test.slga.workflow){
  
  ## Sample points within Australia
  lonlat <- c(151.8306, -27.4969)
  
  start <- Sys.time()
  slga1 <- get_slga_soil(lonlat = lonlat)
  (Sys.time() - start)
  
  slga1.sp <- get_slga_soil_profile(lonlat = lonlat)
  (Sys.time() - start)
  
  ### Testing the effectiveness of the 'xargs' option
  
  ### Testing the number of layers
  sp4 <- get_slga_soil_profile(lonlat = lonlat, fix = TRUE, xargs = list(nlayers = 5))
  (Sys.time() - start)
  
  if(length(sp4$soil$Depth) != 5){
    stop("Length of sp4$soil$Depth should be equal to 5")
  }
  
  ### Testing the soil.bottom argument
  sp5 <- get_slga_soil_profile(lonlat = lonlat, fix = TRUE, xargs = list(soil.bottom = 210))
  (Sys.time() - start)
  
  if(sum(sp5$soil$Thickness) * 1e-1 != 210){
    stop("Bottom of soil profile shuod be equal to 210")
  }
  
  ### Testing soil bottom and number of layers
  sp6 <- get_slga_soil_profile(lonlat = lonlat, fix = TRUE, xargs = list(nlayers = 7, soil.bottom = 210))
  (Sys.time() - start)
  
  if(sum(sp6$soil$Thickness) * 1e-1 != 210){
    stop("Bottom of soil profile shuod be equal to 210")
  }
  if(length(sp6$soil$Depth) != 7){
    stop("Length of sp6$soil$Depth should be equal to 7")
  }
  
  ### This still works
  sp7 <- get_slga_soil_profile(lonlat = lonlat, fix = TRUE, xargs = list(crops = "Canola"))
  (Sys.time() - start)
  
  if(sp7$crops != "Canola"){
    stop("sp7$crops should be 'Canola'")
  }
}
