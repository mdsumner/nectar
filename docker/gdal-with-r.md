
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
apt install r-base r-base-dev
```

test trip

```
proj --version
git clone https://github.com/Trackage/trip.git
cd trip
R
devtools::document()
devtools::build()
devtools::install()
```
