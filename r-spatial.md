# Install R and geo-spatial dependencies

A constantly moving feast, let me know if you need help. 

**Note**
* I'm using latest ubuntu and R usually, check https://cran.r-project.org/bin/linux/ubuntu/




```bash
# update indices
sudo apt update -qq
# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"



sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

sudo apt update
sudo apt upgrade --assume-yes

## Install 3rd parties

## NetCDF and geo-spatial wunderkind
sudo apt install --assume-yes \
   git libjq-dev  libmagick++-dev libarchive-dev libnetcdf-dev proj-bin libnode-dev \
   libxml2-dev libcurl4-openssl-dev libproj-dev libgdal-dev gdal-bin libgeos-dev  libssl-dev libgl1-mesa-dev libglu1-mesa-dev \
   libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick libgit2-dev r-base r-base-dev 




# R packages
# echo 'local({ r <- getOption("repos"); r["CRAN"] <- "file:///rdsi/PRIVATE/raad/dev/cran";options(repos = r); })' >> /etc/R/Rprofile.site
Rscript -e 'install.packages("remotes")'
Rscript -e 'remotes::install_cran(c("angstroms", "anglr", "backports",   "base64enc", "BiocManager", "bitops",   "caTools", "crayon", "devtools", "evaluate", "formatR", "geojsonio",   "ggforce", "ggraph", "graticule", "highr", "htmltools", "htmlwidgets",   "httpuv", "knitr", "leaflet", "magick", "mapview", "markdown",   "ncdf4", "praise", "proj4", "PROJ", "reproj", "quadmesh", "raster", "rbgm", "rgdal",   "rgeos", "rgl", "rmarkdown", "RNetCDF", "rprojroot", "rworldmap",   "sf", "sfdct", "shiny", "sourcetools", "spbabel", "spdplyr",   "spex", "tabularaster", "testthat", "tibble", "tidync", "tidyverse", "traipse", "vapour",   "xtable", "yaml"))'

Rscript -e 'remotes::install_cran(c("decido", "RTriangle", "silicate", "ceramic", "crsmeta", "unjoin", "lazyraster", "geodist", "sfheaders", "mapdeck", "TMB", "foieGras", "trip", "traipse", "bsam"))'

Rscript -e 'remotes::install_github(c("SWotherspoon/SGAT", "SWotherspoon/BAStag", "AustralianAntarcticDivision/raadtools"))'
Rscript -e 'BiocManager::install("rhdf5")'



## raadtools
## apt install sshfs
## 

## find daily builds here
#wget https://s3.amazonaws.com/rstudio-dailybuilds
#wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-1.1.353-amd64.deb
#gdebi rstudio-server-1.1.353-amd64.deb -n

## to downgrade gcc and gfortran (for Atlantis, and so R packages can still build)
## https://unix.stackexchange.com/questions/410723/how-to-install-a-specific-version-of-gcc-in-kali-linux
## and apt-get install gfortran-6 ##so R fortran would compile with gcc 6.5.0


```

### diversitree, hisse, BAMM
```bash
apt install libgsl-dev libfftw3-dev 
Rscript -e  'remotes::install_cran(c("diversitree", "hisse",  "BAMMtools", "corpcor" ,  "cubature",  "gdata",     "gplots",    "gtools","MCMCglmm",  "tensorA"))' 

## BAMM command line http://bamm-project.org/settingup.html#installation-from-source
apt install cmake
git clone https://github.com/macroevolution/bamm.git

```



# python and c.
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


## Microsoft access MDB files

```
apt install unixodbc
git clone https://github.com/brianb/mdbtools.git
cd mdbtools
autoreconf -i -f
./configure --disable-man
make
make install
ldconfig
## R: library(Hmisc); mdb.get("mdbfile", "diag")
```

