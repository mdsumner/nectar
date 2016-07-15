#!/bin/bash

## sources.list
#deb http://ftp.au.debian.org/debian  sid main
#deb-src http://ftp.au.debian.org/debian sid main


apt-get install apt-transport-https --assume-yes

apt-get install git
	
apt-get update 	
apt-get upgrade --assume-yes

## Install 3rd parties


## HDF4
apt-get install libhdf4-dev --assume-yes
apt-get install hdf4-tools --assume-yes

## NetCDF
apt-get install libnetcdf-dev --assume-yes
apt-get install netcdf-bin --assume-yes


## PROJ.4 and GDAL
apt-get install proj-bin --assume-yes
apt-get install libproj-dev --assume-yes
apt-get install libgdal-dev --assume-yes
apt-get install gdal-bin --assume-yes
apt-get install libgeos-dev --assume-yes

 apt-get install libudunits2-0 libudunits2-dev

## V8 for rmapshaper
apt-get install libv8-3.14-dev 

##apt-get install libssl-dev  --assume-yes

apt-get install jags --assume-yes

## now R
apt-get install r-base r-base-dev --assume-yes
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "https://cloud.r-project.org/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages(c("devtools", "rjags", "PBSmapping", "RNetCDF", "rgdal", "rgeos", "ncdf4", "raster"), "/usr/local/lib/R/site-library")'


apt-get install gdebi-core --assume-yes

## uncomment and run gdebi with sudo
##wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-0.99.1200-amd64.deb
##gdebi rstudio-0.99.1200-amd64.deb


## rgl
## 2016-03-10
#apt-get install libgl1-mesa-dev libglu1-mesa-dev

