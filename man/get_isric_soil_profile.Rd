% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_isric_soil_profile.R
\name{get_isric_soil_profile}
\alias{get_isric_soil_profile}
\title{Generate a synthetic APSIM soil profile from the ISRIC soil database}
\usage{
get_isric_soil_profile(
  lonlat,
  statistic = c("mean", "Q0.5"),
  soil.profile,
  find.location.name = TRUE,
  fix = FALSE,
  verbose = TRUE,
  check = TRUE,
  physical = c("default", "SR"),
  xargs = NULL
)
}
\arguments{
\item{lonlat}{Longitude and latitude vector (e.g. c(-93, 42)).}

\item{statistic}{default is the mean}

\item{soil.profile}{a soil profile to fill in in case the default one is not appropriate}

\item{find.location.name}{default is TRUE. Use either maps package or photon API to find Country/State.
If you are running this function many times it might be better to set this to FALSE.}

\item{fix}{whether to fix compatibility between saturation and bulk density (default is FALSE).}

\item{verbose}{argument passed to the fix function.}

\item{check}{whether to check the soil profile (default is TRUE)}

\item{physical}{whether soil physical properties are obtained from the data base or through \sQuote{SR}, Saxton and Rawls pedotransfer functions.}

\item{xargs}{additional arguments passed to \code{\link{apsimx_soil_profile}} or \sQuote{apsimx:::approx_soil_variable} function. At the moment these are:
\sQuote{soil.bottom}, \sQuote{crops}, and \sQuote{nlayers} for the first function and \sQuote{method} for the second function.}
}
\value{
it generates an object of class \sQuote{soil_profile}.
}
\description{
Retrieves soil data from the ISRIC global database and converts it to an APSIM soil_profile object
}
\details{
Source: https://www.isric.org/ \cr
Details: https://www.isric.org/explore/soilgrids/faq-soilgrids \cr

Pedotransfer functions: Saxton and Rawls, 2006. Soil Water Characteristic Estimates by Texture and Organic Matter for Hydrologic Solutions.
Soil Sci. Soc. Am. J. 70:1569–1578. \cr

TODO: need to look into how this is done in APSIM NG
https://github.com/APSIMInitiative/ApsimX/pull/3994/files \cr

NOTE: Eric Zurcher provided help by sending me an R file originally written by
Andrew Moore. It provides a bit of context for how some of the decisions
were made for constructing the synthetic soil profiles in APSIM. (email from june 3 2021).

Variable which are directly retrieved and a simple unit conversion is performed: \cr
* Bulk density - bdod \cr
* Carbon - soc \cr
* Clay - clay \cr
* Sand - sand \cr
* PH - phh2o \cr
* Nitrogen - nitrogen \cr
Variables which are optionally estimated using pedotransfer functions: \cr
LL15, DUL, SAT, KS, AirDry \cr
TO-DO: \cr
What do I do with nitrogen? \cr
Can I use CEC? \cr
How can I have a guess at FBiom and Finert? \cr
FBiom does not depend on any soil property at the moment, should it? \cr
}
\examples{
\dontrun{
## Only run this if rest.isric.org is working
rest.isric.on <- suppressWarnings(try(readLines("http://rest.isric.org", 
n = 1, warn = FALSE), silent = TRUE))

## Get soil profile properties for a single point
if(!inherits(rest.isric.on, "try-error")){
  sp1 <- get_isric_soil_profile(lonlat = c(-93, 42), fix = TRUE, verbose = FALSE)
  ## Visualize
  plot(sp1)
  plot(sp1, property = "water")
 }
}
}
\seealso{
\code{\link{apsimx_soil_profile}}, \code{\link{edit_apsim_replace_soil_profile}}, \code{\link{edit_apsimx_replace_soil_profile}}.
}
\author{
Fernando E. Miguez, Eric Zurcher (CSIRO) and Andrew Moore (CSIRO)
}
