# Install R and geo-spatial dependencies

A constantly moving feast, let me know if you need help. 

**Note**
* I'm using latest ubuntu and R usually, check https://cran.r-project.org/bin/linux/ubuntu/README




```bash

## key for apt-get update, see https://cran.r-project.org/bin/linux/ubuntu/README
echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' >> /etc/apt/sources.list

## key for R 3.5.0
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
## updated GDAL 
## https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

## opencpu (for geojson)
#add-apt-repository -y ppa:opencpu/opencpu-2.1

apt update 
apt upgrade --assume-yes

## Install 3rd parties

## NetCDF and geo-spatial wunderkind
apt install --assume-yes \
   git libjq-dev libv8-3.14-dev  libmagick++-dev libarchive-dev libnetcdf-dev proj-bin \
   libproj-dev libgdal-dev gdal-bin libgeos-dev  libssl-dev libgl1-mesa-dev libglu1-mesa-dev \
   libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick libgit2-dev \
   r-base r-base-dev 



# R packages
# echo 'local({ r <- getOption("repos"); r["CRAN"] <- "https://cran.csiro.au/";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'remotes::install_cran(c("devtools", "sfdct", "rgdal", "leaflet",  "rgeos", "ncdf4", "raster", "RNetCDF", "sf", "tibble", "tidyverse", "rworldmap", "geojsonio", "magick", "rgl", "tabularaster", "angstroms", "spex", "graticule"))'
Rscript -e 'remotes::install_cran(c("BiocManager", "backports", "base64enc", "bitops", "caTools", "crayon", "evaluate",  "formatR",  "ggraph", "ggforce", "highr", "htmltools", "htmlwidgets", "httpuv", "knitr",  "mapview", "markdown", "praise", "proj4", "rmarkdown", "rprojroot",   "shiny", "sourcetools",  "testthat", "xtable", "yaml", "angstroms", "graticule", "quadmesh", "rbgm", "spdplyr", "spbabel", "spex", "vapour"))'
Rscript -e 'remotes::install_github(c("SWotherspoon/SGAT", "SWotherspoon/BAStag", "hypertidy/tidync"), lib = "/usr/local/lib/R/site-library")'
Rscript -e 'BiocManager::install("rhdf5")'

## raadtools
## apt install sshfs
## 
## Rscript -e 'devtools::install_github("AustralianAntarcticDivision/raadtools")'

## find daily builds here
#wget https://s3.amazonaws.com/rstudio-dailybuilds
#wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-1.1.353-amd64.deb
#gdebi rstudio-server-1.1.353-amd64.deb -n

## to downgrade gcc and gfortran (for Atlantis, and so R packages can still build)
## https://unix.stackexchange.com/questions/410723/how-to-install-a-specific-version-of-gcc-in-kali-linux
## and apt-get install gfortran-6 ##so R fortran would compile with gcc 6.5.0


```

diversitree, hisse, BAMM
```bash
apt install libgsl-dev libfftw3-dev 
Rscript -e  'remotes::install_cran(c("diversitree", "hisse", "BAMM", "BAMMtools", "corpcor" ,  "cubature",  "gdata",     "gplots",    "gtools","MCMCglmm",  "tensorA"))' 

```


python and c.
```bash
# tensorflow
## I have no idea what I'm doing with Python, but this seemed to work: 
# apt install libpython3.6
# apt install pip-python3
# pip3 install numpy
# pip3 install keras
# pip3 install tensorflow
## set this in /etc/R/Renviron.site RETICULATE_PYTHON=/usr/bin/python3
# #library(reticulate)
# #py_config()
# #use_python("/usr/bin/python3")

```
