
## Conda

```bash
sudo echo 'deb https://cloud.r-project/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list


sudo apt-get update 
sudo apt-get upgrade --assume-yes

sudo apt-get install apt-transport-https --assume-yes

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
bash Anaconda3-4.2.0-Linux-x86_64.sh 

## NetCDF
sudo apt-get install libnetcdf-dev --assume-yes
sudo apt-get install netcdf-bin --assume-yes

## PROJ.4 and GDAL
sudo apt-get install proj-bin --assume-yes
sudo apt-get install libproj-dev --assume-yes
sudo apt-get install libgdal-dev --assume-yes
sudo apt-get install gdal-bin --assume-yes
sudo apt-get install libgeos-dev --assume-yes

sudo apt-get install libssl-dev  --assume-yes

## now R
sudo apt-get install r-base r-base-dev --assume-yes
sudo echo 'local({ r <- getOption("repos"); r["CRAN"] <- "https://cran.ms.unimelb.edu.au/";options(repos = r); })' >> /etc/R/Rprofile.site
sudo Rscript -e 'install.packages(c("devtools", "rgdal", "rgeos", "ncdf4", "raster"), "/usr/local/lib/R/site-library")'

sudo apt-get install gdebi-core --assume-yes
wget https://download2.rstudio.org/rstudio-server-0.99.903-amd64.deb
sudo gdebi rstudio-server-0.99.903-amd64.deb
```