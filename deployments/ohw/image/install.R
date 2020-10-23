#!/usr/bin/env r

# Install devtools, so we can install versioned packages
install.packages("devtools")

# Install a bunch of R packages
# This doesn't do any dependency resolution or anything,
# so refer to `installed.packages()` for authoritative list
cran_packages <- c(
  "tidyverse", "1.3.0",
  "learnr", "0.10.1",
  "knitr", "1.29",
  "rmarkdown", "2.3",
  "Rcpp", "1.0.5",
  "reticulate", "1.16",
  "shiny", "1.5.0"
)

for (i in seq(1, length(cran_packages), 2)) {
  devtools::install_version(
    cran_packages[i],
    version = cran_packages[i + 1]
  )
}
