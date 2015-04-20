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
Rscript -e 'install.packages(c("rgdal", "rgeos", "ncdf4", "raster"), "/usr/local/lib/R/site-library")'


sudo adduser mdsumner
sudo -i -u postgres
createdb mdsumner
createuser --interactive

##SHOW data_directory;
## /var/lib/postgresql/9.3/main

/usr/local/pgsql/data

## attach volume  to 
sudo apt-get install gdebi-core --assume-yes
sudo apt-get install libapparmor1 --assume-yes

# CGAL
sudo apt-get install libcgal-dev
sudo apt-get install libcgal-demo

sudo apt-get install postgresql postgresql-contrib postgresql-devel 
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt trusty-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-9.4-postgis-2.1 pgadmin3 ##postgresql-contrib
sudo apt-get postgresql-client-common postgres-xc-client

#sudo su - postgres psql
#create user  mdsumner with password 'hoochymama';
#create database ocdb;
#grant all privileges on database ocdb to mdsumner;

Rscript -e 'install.packages(c("dplyr", "RPostgreSQL"), "/usr/local/lib/R/site-library")'
