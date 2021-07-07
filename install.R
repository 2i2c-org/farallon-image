#!/usr/bin/env r

# Install devtools, so we can install versioned packages
install.packages("devtools")

# Specific versions of lwgeom and sf are needed
# Latest pinned versions at the time do not install,
# due to incompatibilities with libproj versions they
# need and what is avaialble in the deb repos
versioned_packages = c(
  "sf", "0.9-8",
  "lwgeom", "0.2-6"
 )

for (i in seq(1, length(versioned_packages), 2)) {
  devtools::install_version(
    versioned_packages[i],
    version = versioned_packages[i + 1],
    upgrade = FALSE,
    quiet = TRUE
  )
}

# Install a bunch of R packages
# This doesn't do any dependency resolution or anything,
# so refer to `installed.packages()` for authoritative list
cran_packages <- c(
  "gtools",
  "tidyverse",
  "learnr",
  "knitr",
  "rmarkdown",
  "Rcpp",
  "reticulate",
  "shiny",
  "itsadug",
  "Matrix",
  "TMB",
  "car",
  "lme4",
  "MASS",
  "MuMIn",
  "mediation",
  "nlsem",
  "lavaan",
  "semPlot",
  "mgcv",
  "mgcViz",
  "DHARMa",
  "dunn.test",
  "corrplot",
  "statmod",
  "tweedie",
  "glmmTMB",
  "data.table",
  "rgeos",
  "sp",
  "raster",
  "rgdal",
  "purrr",
  "ggpubr",
  "ggstance",
  "gplots",
  "gganimate",
  "splitstackshape",
  "rworldmap",
  "maptools",
  "mapdata",
  "rnaturalearth",
  "rnaturalearthdata",
  "viridis",
  "adehabitatMA",
  "ncdf4",
  "Information",
  "corrplot",
  "ClustOfVar"
)

install.packages(cran_packages, upgrade=FALSE, quiet=TRUE)
