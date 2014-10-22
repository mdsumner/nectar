#!/bin/bash

## Install R and geo-spatial dependencies
## mdsumner@gmail.com

## Paste all this text into "Post-Creation/Configuration Script"" or run as `sudo r-spatial.sh`

## - NOTE: commands may be run individually must be run as sudo for ubuntu account, 
##   otherwise they run as root in startup, or as sudo by normal bash script

## This script installs:
## - R with rgdal, ncdf4, rgeos and raster
## - including HDF4, HDF5, NetCDF-4 and OpenDAP capabilities via rgdal or raster
## - using Nectar image "NeCTAR Ubuntu 14.04 (Trusty) amd64"
## - see final comments for RStudio Server, which should be done interactively - and update the
## version by checking the website noted for "wget" and subsequent "gdebi" install

## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
apt-get update 
apt-get upgrade --assume-yes

## Install 3rd parties

## pretty sure not 100% the -tools and -bin versions 
## are not needed for R but they are useful

## HDF4
apt-get install libhdf4-dev --assume-yes
apt-get install hdf4-tools --assume-yes

## NetCDF
apt-get install libnetcdf-dev --assume-yes
apt-get install netcdf-bin --assume-yes

## PROJ.4 and GDAL
apt-get install libproj --assume-yes
apt-get install libproj-dev --assume-yes
apt-get install libgdal-dev --assume-yes
apt-get install gdal-bin --assume-yes

## now R
apt-get install r-base r-base-dev --assume-yes
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "http://cran.csiro.au/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages(c("rgdal", "rgeos", "ncdf4", "raster"), "/usr/lib/R/site-library")'

## RStudio server?, uncomment and run interactively
## see here for updates: http://www.rstudio.com/products/rstudio/download-server/
# sudo apt-get install gdebi-core --assume-yes
## already installed above by something, but no harm
# sudo apt-get install libapparmor1 --assume-yes # Required only for Ubuntu, not Debian
# wget http://download2.rstudio.org/rstudio-server-0.98.1081-amd64.deb
# sudo gdebi rstudio-server-0.98.1081-amd64.deb

