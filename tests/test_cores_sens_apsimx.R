## Script to test cores functionality

require(apsimx)

apsimx_options(warn.versions = FALSE)

run.test.two.cores.sns <- FALSE

if(run.test.two.cores.sns){

    tmp.dir <- tempdir()
    setwd(tmp.dir)
    ex.dir <- auto_detect_apsimx_examples()

    file.copy(file.path(ex.dir, "Wheat.apsimx"), ".")
  
    pp1 <- inspect_apsimx("Wheat.apsimx", src.dir = ".", 
                           node = "Manager", parm = list("SowingFertiliser", 1))
    pp1 <- paste0(pp1, ".Amount")
  
    pp2 <- inspect_apsimx("Wheat.apsimx", src.dir = ".", 
                           node = "Manager", parm = list("SowingRule1", 9))
    pp2 <- paste0(pp2, ".Population")
  
    ## The names in the grid should (partially) match the parameter path names
    grd <- expand.grid(Fertiliser = c(50, 100, 150), Population = c(100, 200, 300))
  
    ## This takes 2-3 minutes
    system.time(sns0 <- sens_apsimx(file = "Wheat.apsimx", 
                                    src.dir = ".",
                                    parm.paths = c(pp1, pp2),
                                    grid = grd))
    ## date        user  system  elapsed 
    ## 2022-11-22   215        8     125 (2.08 minutes)
  
    ## The two core simulation seems to work when number of simulations are even for n - 1
    system.time(sns1 <- sens_apsimx(file = "Wheat.apsimx", 
                                    src.dir = ".",
                                    parm.paths = c(pp1, pp2),
                                    grid = grd,
                                    cores = 2))

    ## Make sure that data.frames are the same
    
    ## date        user system elapsed
    ## 2022-11-22   292     11    100 (1.67 minutes. It takes 84% of the time compared to 1 core)
    
    ## Are the results identical?
    is.it.zero <- sum(colSums(sns0$grid.sims - sns1$grid.sims))
    if(is.it.zero > 0.5)
      stop("Results are not identical when cores = 1 and cores = 2")
    
    ## Testing having uneven number of simulations to parallelize
    grd2 <- grd[1:8, ]
    
    system.time(sns2 <- sens_apsimx(file = "Wheat.apsimx", 
                                    src.dir = ".",
                                    parm.paths = c(pp1, pp2),
                                    grid = grd2,
                                    cores = 2))
    
    nrow.sns2 <- nrow(sns2$grid.sims)
    ## Compare results
    is.it.zero <- sum(colSums(sns1$grid.sims[1:8,] - sns2$grid.sims))
    
    if(is.it.zero > 0.5)
      stop("Results are not identical when cores = 1 and cores = 2")
  
}

run.test.more.cores.sns <- FALSE


if(run.test.more.cores.sns){
  
  tmp.dir <- tempdir()
  setwd(tmp.dir)
  ex.dir <- auto_detect_apsimx_examples()
  
  file.copy(file.path(ex.dir, "Wheat.apsimx"), ".")
  
  pp1 <- inspect_apsimx("Wheat.apsimx", src.dir = ".", 
                        node = "Manager", parm = list("SowingFertiliser", 1))
  pp1 <- paste0(pp1, ".Amount")
  
  pp2 <- inspect_apsimx("Wheat.apsimx", src.dir = ".", 
                        node = "Manager", parm = list("SowingRule1", 9))
  pp2 <- paste0(pp2, ".Population")
  
  ## The names in the grid should (partially) match the parameter path names
  grd <- expand.grid(Fertiliser = c(50, 100, 150), Population = c(100, 200, 300))
  
  system.time(sns3 <- sens_apsimx(file = "Wheat.apsimx", 
                                 src.dir = ".",
                                 parm.paths = c(pp1, pp2),
                                 grid = grd,
                                 cores = 3))
  
  ## Compare results
  is.it.zero <- sum(colSums(sns1$grid.sims - sns3$grid.sims))
  
  if(is.it.zero > 0.5)
    stop("Results are not identical when cores = 2 and cores = 3")
  
  grd2 <- grd[1:8, ]

  system.time(sns4 <- sens_apsimx(file = "Wheat.apsimx", 
                                  src.dir = ".",
                                  parm.paths = c(pp1, pp2),
                                  grid = grd2,
                                  cores = 3))
  
  ## Compare results
  is.it.zero <- sum(colSums(sns2$grid.sims - sns4$grid.sims))
  
  if(is.it.zero > 0.5)
    stop("Results are not identical when cores = 2 and cores = 3 (smaller grid)")
  
  ## Trying more cores
  system.time(sns5 <- sens_apsimx(file = "Wheat.apsimx", 
                                  src.dir = ".",
                                  parm.paths = c(pp1, pp2),
                                  grid = grd,
                                  cores = 4))
  
  is.it.zero <- sum(colSums(sns1$grid.sims - sns5$grid.sims))
  
  if(is.it.zero > 0.5)
    stop("Results are not identical when cores = 3 and cores = 4")
  
  
}

## Testing the 'save' feature

run.test.save.cores.sns <- FALSE

if(run.test.save.cores.sns){
  
  tmp.dir <- tempdir()
  setwd(tmp.dir)
  ex.dir <- auto_detect_apsimx_examples()
  
  file.copy(file.path(ex.dir, "Wheat.apsimx"), ".")
  
  pp1 <- inspect_apsimx("Wheat.apsimx", src.dir = ".", 
                        node = "Manager", parm = list("SowingFertiliser", 1))
  pp1 <- paste0(pp1, ".Amount")
  
  pp2 <- inspect_apsimx("Wheat.apsimx", src.dir = ".", 
                        node = "Manager", parm = list("SowingRule1", 9))
  pp2 <- paste0(pp2, ".Population")
  
  ## The names in the grid should (partially) match the parameter path names
  grd <- expand.grid(Fertiliser = c(50, 100, 150), Population = c(100, 200, 300))
  
  ## This takes 2-3 minutes
  system.time(sns01 <- sens_apsimx(file = "Wheat.apsimx", 
                                  src.dir = ".",
                                  parm.paths = c(pp1, pp2),
                                  grid = grd,
                                  save = TRUE))
  
  ## This takes 2-3 minutes
  system.time(sns02 <- sens_apsimx(file = "Wheat.apsimx", 
                                  src.dir = ".",
                                  parm.paths = c(pp1, pp2),
                                  grid = grd,
                                  save = "wheat_int_results.csv"))
  
}