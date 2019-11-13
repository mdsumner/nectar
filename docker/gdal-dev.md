
```bash
apt-get update
apt-get upgrade

apt-get install docker.io


wget https://raw.githubusercontent.com/OSGeo/gdal/master/gdal/docker/ubuntu-full/Dockerfile

#BOOM: http://erouault.blogspot.com/2019/
#build-arg not build-var

GDAL_VERSION=$(curl -Ls https://api.github.com/repos/rouault/gdal/commits/master  -H "Accept: application/vnd.github.VERSION.sha")
docker build --build-arg GDAL_VERSION=${GDAL_VERSION} -t gdal_latest .
```
Interactive

```
docker run -it gdal_latest:latest /bin/bash
```

Single command

```bash
docker run --rm -v /home/ubuntu:/host  gdal_latest:latest gdalinfo /host/laea.png
```
sudo docker run --rm -it -v /rdsi/PRIVATE/raad:/raad  gdal_latest:latest /bin/bash
