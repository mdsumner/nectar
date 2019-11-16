
```bash
apt-get update
apt-get upgrade

apt-get install docker.io


wget https://raw.githubusercontent.com/OSGeo/gdal/master/gdal/docker/ubuntu-full/Dockerfile

# http://erouault.blogspot.com/2019/
# note build-arg not build-var

GDAL_VERSION=$(curl -Ls https://api.github.com/repos/rouault/gdal/commits/master  -H "Accept: application/vnd.github.VERSION.sha")
docker build --build-arg GDAL_VERSION=${GDAL_VERSION} -t gdal_latest .
```

Interactive

```
docker run -it gdal_latest:latest /bin/bash
apt update
apt-get upgrade
echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' >> /etc/apt/sources.list
## key for R 3.5.0
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

apt install r-base r-base-dev
apt install git 
apt install libcurl4-openssl-dev
apt install libxml2-dev
apt install libssl-dev
```

test trip

```
proj # Rel. 6.1.0, May 15th, 2019
git clone https://github.com/Trackage/trip.git
cd trip
R
install.packages("devtools")
devtools::install_deps()
remotes::install_github("edzer/sp")
remotes::install_github("rforge/rgdal")

devtools::document()
devtools::build()
devtools::install()
```
