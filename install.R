#!/usr/bin/env r

# Install devtools, so we can install versioned packages
install.packages("devtools")

# Install a bunch of R packages
# This doesn't do any dependency resolution or anything,
# so refer to `installed.packages()` for authoritative list
cran_packages <- c(
  "gtools", "3.8.2",
  "tidyverse", "1.3.0",
  "learnr", "0.10.1",
  "knitr", "1.29",
  "rmarkdown", "2.3",
  "Rcpp", "1.0.5",
  "reticulate", "1.16",
  "shiny", "1.5.0",
  "itsadug", "2.3",
  # TMB needs at least 1.3-4 version of Matrix
  "Matrix", "1.3-4",
  "TMB", "1.7.18",
  "car", "3.0-10",
  "lme4", "1.1-25",
  "MASS", "7.3-53",
  "MuMIn", "1.43.17",
  "mediation", "4.5.0",
  "nlsem", "0.8",
  "lavaan", "0.6-7",
  "semPlot", "1.1.2",
  "mgcv", "1.8-33",
  "mgcViz", "0.1.6",
  "DHARMa", "0.3.3.0",
  "dunn.test", "1.3.5",
  "corrplot", "0.84",
  "statmod", "1.4.35",
  "tweedie", "2.3.2",
  "glmmTMB", "1.0.2.1",
  "data.table", "1.13.2",
  "rgeos", "0.5-5",
  "sf", "0.9-6",
  "sp", "1.4-4",
  "raster", "3.3-13",
  "rgdal", "1.5-18",
  "purrr", "0.3.4",
  "ggpubr", "0.4.0",
  "ggstance", "0.3.4",
  "gplots", "3.1.0",
  "gganimate", "1.0.7",
  "splitstackshape", "1.4.8",
  "rworldmap", "1.3-6",
  "maptools", "1.0-2",
  "mapdata", "2.3.0",
  "rnaturalearth", "0.1.0",
  "rnaturalearthdata", "0.1.0",
  "viridis", "0.5.1",
  "adehabitatMA", "0.3.14",
  "ncdf4", "1.17",
  "Information", "0.0.9",
  "corrplot", "0.84",
  "ClustOfVar", "1.1",
  # From https://github.com/2i2c-org/pilot/issues/79
  "lwgeom", "0.2-6"
)

for (i in seq(1, length(cran_packages), 2)) {
  devtools::install_version(
    cran_packages[i],
    version = cran_packages[i + 1]
  )
}
