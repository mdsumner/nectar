Notes for installing R, Python with geospatial deps on Linux, Ubuntu 22 (2023-02-10). 

The system libs, and the R packages are way overkill - but this is a working set of notes for our usage atm. 

```
## latest R (search "ubuntu cran")
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

## latest geospatial 
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

sudo apt update
sudo apt upgrade --assume-yes

## Install 3rd parties

## all the libs (includes quite a bit of stuff for R that eratos doesn't use)
## presume eratos needs libnetcdf libproj, unsure about the rest
sudo apt install --assume-yes \
   git libjq-dev  libmagick++-dev libarchive-dev libnetcdf-dev proj-bin libnode-dev \
   libxml2-dev libcurl4-openssl-dev libproj-dev libgdal-dev gdal-bin libgeos-dev  libssl-dev libgl1-mesa-dev libglu1-mesa-dev \
   libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick libgit2-dev r-base r-base-dev libharfbuzz-dev libfribidi-dev 


## Install RStudio server (we have opened ports 8787 for rstudio, and 22 for ssh) - nginx secure setup for RStudio server is described elsewhere)
## don't use the l#atest formal release, it doesn't work on jammy ... get  a daily build
#wget https://s3.a#mazonaws.com/rstudio-ide-build/server/jammy/amd64/rstudio-server-2023.0 aily-304-amd64.deb
#sudo apt install gdebi-core
#sudo gdebi rstudio-server-2023.03.0-daily-304-amd64.deb


## Get pip and eratos deps  (I would add rasterio xarray etc)
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install --upgrade deepmerge h5py netCDF4 numpy pandas pyjwt pyproj pyyaml requests shapely  tabulate 
sudo eratos installsdk 

## test the install
# pip show eratos
```


TODO: find the minimal set of R packages for reasonable use with eratos (reticulate is bare minimum)

```R
## now in R all the package loot, this is major overkill, not all necessary but covers my needs easy for now 
pak::pkg_install("/home/mdsumner/Git/eratos-work/cfdtk")
pkgs <- c("angstroms", "backports",   "base64enc", "BiocManager", "bitops",   "caTools", "crayon", "devtools", "evaluate", "formatR", "geojsonio",   "ggforce", "ggraph", "graticule", "highr", "htmltools", "htmlwidgets",   "httpuv", "knitr", "leaflet", "magick", "mapview", "markdown",   "ncdf4", "praise", "proj4", "PROJ", "reproj", "quadmesh", "raster", "rbgm", "rgdal",   "rgeos", "rgl", "rmarkdown", "RNetCDF", "rprojroot", "rworldmap",   "sf", "sfdct", "shiny", "sourcetools", "spbabel", "spdplyr",   "spex", "tabularaster", "testthat", "tibble", "tidync", "tidyverse", "traipse", "vapour",   "xtable", "yaml", 
"exactextractr", "geos", "reticulate",
"decido", "RTriangle", "silicate", "ceramic", "crsmeta", "unjoin", "geodist", "sfheaders", "mapdeck",  "trip", "traipse", "usethis", "devtools", "roxygen2")
pak::pkg_install(pkgs)
```

```
