#!/bin/bash
## 1) Update and install R

## using Nectar image "NeCTAR Ubuntu 14.04 (Trusty) amd64"
## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
sudo chown ubuntu /etc/apt/sources.list
sudo echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install r-base r-base-dev -y


## 3) Install 3rd party NetCDF4 dependency
sudo apt-get install netcdf-bin -y
sudo apt-get install libnetcdf-dev -y

## 2) Install R package dependencies
## lib = "/usr/lib/R/site-library"

sudo Rscript -e 'x <- .libPaths();install.packages(c("abind", "plyr", "reshape2", "foreach", "digest", "ggplot2", "ncdf4", "ncdf", "doParallel", "fields", "testthat", "knitr"), lib = x[length(x)-1], repos = "http://cran.csiro.au")'


## 3) Install RCMIP5
sudo Rscript -e 'x <- .libPaths();install.packages("RCMIP5", lib = x[length(x)-1], repos = "http://cran.csiro.au")'
