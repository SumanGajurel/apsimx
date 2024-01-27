## Testing whether 

require(apsimx)

apsimx_options(warn.versions = FALSE,
               exe.path = "/Applications/APSIM2022.6.7044.0.app/Contents/Resources/bin/Models",
               examples.path = "/Applications/APSIM2022.6.7044.0.app/Contents/Resources/Examples")

run.insert <- get(".run.local.tests", envir = apsimx.options)

#### This does not work at the moment
run.insert <- FALSE

tmp.dir <- tempdir()
extd.dir <- system.file("extdata", package = "apsimx")
ex.dir <- auto_detect_apsimx_examples()

if(run.insert){
  
##   setwd("~/Dropbox/apsimx/tests")
  
  #### Test for wheat ####
  wheat <- get_apsimx_json(model = "Wheat", wrt.dir = tmp.dir)
  
  file.copy(file.path(ex.dir, "Wheat.apsimx"), tmp.dir)  
  
  insert_replacement_node("Wheat.apsimx", 
                          src.dir = tmp.dir, 
                          wrt.dir = tmp.dir,
                          rep.node = wheat)
  
  sim0 <- apsimx("Wheat-edited.apsimx", src.dir = tmp.dir)
  
  #### Test for maize ####
  maize <- get_apsimx_json(model = "Maize", wrt.dir = tmp.dir)
  
  file.copy(file.path(ex.dir, "Maize.apsimx"), tmp.dir)  
  
  insert_replacement_node("Maize.apsimx", 
                          src.dir = extd.dir, 
                          wrt.dir = tmp.dir,
                          rep.node = maize)
  
  sim1 <- apsimx("Maize-edited.apsimx", src.dir = tmp.dir)
  
  #### Test for soybean ####
  soybean <- get_apsimx_json(model = "Soybean", wrt.dir = tmp.dir)
  
  file.copy(file.path(ex.dir, "Soybean.apsimx"), tmp.dir)  
  
  insert_replacement_node("Soybean.apsimx", 
                          src.dir = extd.dir, 
                          wrt.dir = tmp.dir,
                          rep.node = soybean)
  
  sim2 <- apsimx("Soybean-edited.apsimx", src.dir = tmp.dir)
  
}