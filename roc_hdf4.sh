## 1) Update and install R

## using Nectar image "NeCTAR Ubuntu 14.04 (Trusty) amd64"
## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
sudo chown ubuntu /etc/apt/sources.list
sudo echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y r-base r-base-dev 

## 2) Install R package dependencies
## brew, digest, Rcpp stringr, and testthat packages
## lib = "/usr/lib/R/site-library"
sudo Rscript -e 'x <- .libPaths();install.packages(c("roxygen2", "testthat", "Rcpp"), lib = x[length(x)-1], repos = "http://cran.csiro.au")'

## 3) Install 3rd party HDF dependency
sudo apt-get install -y libhdf4g-dev
sudo apt-get install git -y

## 4) Get the package source and install
git clone https://github.com/mdsumner/roc.git

### 4a) roxygenize
### Rscript -e 'roxygen2::roxygenize("roc")'
### not sure if this is a bug in roxygen2, but ensure methods is loaded first
Rscript -e 'library(methods);roxygen2::roxygenize("roc")'

### 4b) Rcpp attributes (wraps the C++ source for R functions and doc)
Rscript -e 'Rcpp::compileAttributes("roc")'

### 4c) build and install
## check where your hdf.h is, ensure this corresponds to roc/src/Makevars and
export CPATH=/usr/include/hdf
R CMD build roc

echo 'CPATH=/usr/include/hdf' >> .Renviron


=======
##Rscript -e 'roxygen2::roxygenize("roc")'
## not sure if this is a bug in roxygen2, but ensure methods is loaded first
Rscript -e 'library(methods);roxygen2::roxygenize("roc")'
## check where your hdf.h is, ensure this corresponds to roc/src/Makevars and
export CPATH=/usr/include/hdf
R CMD build roc
sudo R CMD INSTALL roc_0.0-4.tar.gz --library=/usr/lib/R/site-library

## 5) Obtain an example file and test it out
wget http://oceandata.sci.gsfc.nasa.gov/cgi/getfile/S2004001.L3b_DAY_KD490.main.bz2
bunzip2 S2004001.L3b_DAY_KD490.main.bz2
Rscript -e 'library(roc);str(readL3("S2004001.L3b_DAY_KD490.main"))'
## List of 8
##  $ NUMROWS   : int 2160
## $ bin_num   : int [1:358121] 73217 74173 74181 74183 75135 75136 75144 75145 75146 75216 ...
## $ nobs      : int [1:358121] 1 1 1 1 2 2 1 2 2 1 ...
## $ nscenes   : int [1:358121] 1 1 1 1 1 1 1 1 1 1 ...
## $ weights   : num [1:358121] 1 1 1 1 1.41 ...
## $ Kd_490_sum: num [1:358121] 0.111 0.154 0.169 0.14 0.25 ...
## $ Kd_490_ssq: num [1:358121] 0.0124 0.0238 0.0284 0.0197 0.0448 ...
## $ filename  : chr "S2004001.L3b_DAY_KD490.main"