#!/bin/bash

## Install R and pg

## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

## updated GDAL
## https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

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

## PostgreSQL now so that GDAL and rgdal automatically pick it and PostGIS up
##http://wiki.openstreetmap.org/wiki/PostGIS/Installation
apt-get install postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1
## https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-14-04

## PROJ.4 and GDAL
apt-get install proj-bin --assume-yes
apt-get install libproj-dev --assume-yes
apt-get install libgdal-dev --assume-yes
apt-get install gdal-bin --assume-yes

## now R
apt-get install r-base r-base-dev --assume-yes
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "http://cran.csiro.au/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages(c("rgdal", "rgeos", "ncdf4", "raster", "dplyr", "RPostgreSQL"), "/usr/local/lib/R/site-library")'

## create normal user etc. 
#sudo adduser azif
##sudo -i -u postgres
##createdb azif
##createuser --interactive


## consider (for PostGIS)
# CGAL
sudo apt-get install libcgal-dev
sudo apt-get install libcgal-demo
