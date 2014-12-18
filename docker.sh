!#/bin/bash
apt-get update
apt-get upgrade
apt-get install docker.io

docker build -t gdal:latest git://github.com/geo-data/gdal-docker/
docker run -d -p 8787:8787 rocker/rstudio
