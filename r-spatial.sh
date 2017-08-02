#!/bin/bash

## Install R and geo-spatial dependencies
##  (a bit of a moving feast, let me know if you need help)

## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
echo 'deb https://cran.csiro.au/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

## updated GDAL 
## https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

apt update 
apt upgrade --assume-yes

## Install 3rd parties

## NetCDF and geo-spatial wunderkind
apt install libarchive-dev libnetcdf-dev proj-bin  libproj-dev libgdal-dev gdal-bin libgeos-dev  libssl-dev   libudunits2-dev  r-base r-base-dev --assume-yes
   
# R packages
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "https://cran.csiro.au/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages(c("devtools", "rgdal", "rgeos", "ncdf4", "raster", "RNetCDF", "sf", "tibble", "tidyverse", "rworldmap"), "/usr/local/lib/R/site-library")'
#Rscript -e 'install.packages(c("backports", "base64enc", "bitops", "caTools", "crayon", "evaluate",  "formatR",  "ggraph", "ggforce", "highr", "htmltools", "htmlwidgets", "httpuv", "knitr",  "markdown", "praise", "proj4", "rmarkdown", "rprojroot",   "shiny", "sourcetools",  "testthat", "xtable", "yaml", "angstroms", "graticule", "ncdump", "rbgm", "spdplyr", "spbabel", "spex"), "/usr/local/lib/R/site-library")
#Rscript -e 'devtools::install_github(c("rstudio/leaflet", "bhaskarvk/leaflet.extras", "environmentalinformatics-marburg/mapview@develop"), "/usr/local/lib/R/site-library")

## RSTudio
apt-get install gdebi-core --assume-yes
## find daily builds here
#wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-1.1.238-amd64.deb
wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
gdebi rstudio-server-1.0.143-amd64.deb -n

## then, regularly
# apt update
# apt upgrade
# Rscript -e 'devtools::update_packages(TRUE)'
