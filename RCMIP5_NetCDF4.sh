#!/bin/bash
## 1) Update and install R

## optional set your timezone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Etc/GMT+10 /etc/localtime

## using Nectar image "NeCTAR Ubuntu 14.04 (Trusty) amd64"
## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
## chown ubuntu /etc/apt/sources.list
echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "http://cran.csiro.au/"; options(repos = r); })' >> /etc/R/Rprofile.site

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
apt-get update --assume-yes
apt-get upgrade --assume-yes
apt-get install r-base r-base-dev --assume-yes

## 3) Install 3rd party NetCDF4 dependency
apt-get install netcdf-bin --assume-yes
apt-get install libnetcdf-dev --assume-yes

## 2) Install R package dependencies
## lib = "/usr/lib/R/site-library"
Rscript -e 'install.packages(c("abind", "plyr", "reshape2", "foreach", "digest", "ggplot2", "ncdf4", "ncdf", "doParallel", "fields", "testthat", "knitr"), lib = "/usr/lib/R/site-library", repos = "http://cran.csiro.au")'

## 3) Install RCMIP5
Rscript -e 'install.packages("RCMIP5", lib = "/usr/lib/R/site-library", repos = "http://cran.csiro.au")'
