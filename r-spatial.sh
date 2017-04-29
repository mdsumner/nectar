#!/bin/bash

## Install R and geo-spatial dependencies
##  (a bit of a moving feast, let me know if you need help)

## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
echo 'deb https://cran.ms.unimelb.edu.au/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

## updated GDAL 
## https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

apt-get update 
apt-get upgrade --assume-yes

## Install 3rd parties

## NetCDF
apt-get install libnetcdf-dev --assume-yes && \

## PROJ.4 and GDAL and R
apt-get install proj-bin --assume-yes && \
apt-get install libproj-dev --assume-yes && \
apt-get install libgdal-dev --assume-yes && \
apt-get install gdal-bin --assume-yes && \
apt-get install libgeos-dev --assume-yes && \
apt-get install libssl-dev  --assume-yes && \
apt-get install libudunits2-dev --assume-yes && \
apt-get install r-base r-base-dev --assume-yes
echo 'local({ r <- getOption("repos"); r["CRAN"] <- "https://mirror.aarnet.edu.au/pub/CRAN/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages(c("devtools", "rgdal", "rgeos", "ncdf4", "raster", "sf", "tibble", "tidyverse", "rworldmap", "graticule"), "/usr/local/lib/R/site-library")'
Rscript -e 'install.packages(c("backports", "base64enc", "bitops", "caTools", "crayon", "evaluate",  "formatR",  "highr", "htmltools", "htmlwidgets", "httpuv", "knitr",  "markdown", "praise", "proj4", "rmarkdown", "rprojroot",   "shiny", "sourcetools",  "testthat", "xtable", "yaml"), "/usr/local/lib/R/site-library")'
apt-get install gdebi-core --assume-yes
wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-1.1.96-amd64.deb
gdebi rstudio-dailybuilds/rstudio-1.1.96-amd64.deb -n


