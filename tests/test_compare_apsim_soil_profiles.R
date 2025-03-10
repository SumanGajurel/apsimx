### Testing the performance of the compare_apsim_soil_profile function
### It should be more robust

require(apsimx)
require(ggplot2)

apsimx_options(warn.versions = FALSE)

run.compare.soils <- get(".run.local.tests", envir = apsimx.options)

if(run.compare.soils){
  sp1 <- get_ssurgo_soil_profile(lonlat = c(-93, 42), fix = TRUE)
  sp2 <- get_ssurgo_soil_profile(lonlat = c(-92, 41), fix = TRUE)
  # Individual plots
  plot(sp1[[1]], property = "water")
  plot(sp2[[1]], property = "water")
  plot(sp1[[1]], property = "texture")
  plot(sp2[[1]], property = "texture")
  plot(sp1[[1]], property = "Carbon")
  plot(sp2[[1]], property = "Carbon")
  # Compare them
  cmp0 <- compare_apsim_soil_profile(sp1[[1]], sp2[[1]], labels = c("sp1", "sp2"))
  # Plot the variables
  plot(cmp0)
  plot(cmp0, property = "DUL")
  plot(cmp0, property = "Carbon")
  plot(cmp0, property = "BD")
  plot(cmp0, property = "ParticleSizeClay")
  plot(cmp0, property = "ParticleSizeSilt")
  plot(cmp0, property = "ParticleSizeSand")
}

### Compare soils with different rows
if(run.compare.soils){
  ### SSURGO
  sp1 <- get_ssurgo_soil_profile(lonlat = c(-93, 42), fix = TRUE)
  class(sp1[[1]])
  ### SoilGrids
  sp2 <- get_isric_soil_profile(lonlat = c(-92, 42), fix = TRUE)
  class(sp2)
  ### WorldModeler
  sp3 <- get_worldmodeler_soil_profile(lonlat = c(-92, 42))
  class(sp3[[1]])
  # Compare them
  cmp <- compare_apsim_soil_profile(sp1[[1]], sp2, sp3[[1]], merge.wide = FALSE,
                                    labels = c("ssurgo", "SoilGrids", "WorldModeler"))
  
  # Plot the variables
  plot(cmp)
  plot(cmp, soil.var = "DUL")
  plot(cmp, soil.var = "Carbon")
  plot(cmp, soil.var = "LL15")

}