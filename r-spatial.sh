#!/bin/bash

## Install R and geo-spatial dependencies
## mdsumner@gmail.com

## Paste all this text into "Post-Creation/Configuration Script"" or run as `sudo r-spatial.sh`

## This script installs:
## - R with rgdal, ncdf4, rgeos and raster
## - including HDF4, HDF5, NetCDF-4 and OpenDAP capabilities via rgdal or raster
## - using Nectar image "NeCTAR Ubuntu 14.04 (Trusty) amd64"
## - see final comments for RStudio Server, which should be done interactively - and update the
## version by checking the website noted for "wget" and subsequent "gdebi" install

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


## PROJ.4 and GDAL
apt-get install proj-bin --assume-yes
apt-get install libproj-dev --assume-yes
apt-get install libgdal-dev --assume-yes
apt-get install gdal-bin --assume-yes

## now R
apt-get install r-base r-base-dev --assume-yes
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "http://cran.csiro.au/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages(c("rgdal", "rgeos", "ncdf4", "raster"), "/usr/local/lib/R/site-library")'

## LaTeX, pandoc etc. nightmare - just google rstudio errors and follow the trail . . .
## sudo apt-get install ec

apt-get install texlive-fonts-recommended --assume-yes
apt-get install texlive-latex-recommended --assume-yes

apt-get install gdebi-core --assume-yes
apt-get install libapparmor1 --assume-yes # Required only for Ubuntu, not Debian
## uncomment and run gdebi with sudo
##wget http://download2.rstudio.org/rstudio-server-0.98.1091-amd64.deb
##gdebi rstudio-server-0.98.1091-amd64.deb --assume-yes

## RStudio server?, uncomment and run interactively
## see here for updates: http://www.rstudio.com/products/rstudio/download-server/
# sudo apt-get install gdebi-core --assume-yes
## already installed above by something, but no harm
# sudo apt-get install libapparmor1 --assume-yes # Required only for Ubuntu, not Debian
#  wget http://download2.rstudio.org/rstudio-server-0.98.1085-amd64.deb
# sudo gdebi rstudio-server-0.98.1085-amd64.deb

##wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.2.3.368-amd64.deb
## sudo gdebi shiny-server-1.2.3.368-amd64.deb
