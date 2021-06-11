#!/usr/bin/env r
github_packages <- c(
  "James-Thorson-NOAA/FishStatsUtils", "2.8.0",
  "james-thorson/EOFR", "d3ebd884e3483645a029cdf092cff986f5d8b24a",
  "James-Thorson-NOAA/VAST", "3.7.1",
  "3wen/legendMap", "707f00ccdc494ce3aefead7abdf0d294bd6774df"
)


devtools::install_version("INLA", "20.03.17", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"))

for (i in seq(1, length(github_packages), 2)) {
  devtools::install_github(
    github_packages[i],
    ref = github_packages[i + 1]
  )
}
