https://raw.githubusercontent.com/OSGeo/gdal/master/gdal/docker/ubuntu-small/Dockerfile

```bash
apt-get update
apt-get upgrade

apt-get install docker.io

wget https://raw.githubusercontent.com/OSGeo/gdal/master/gdal/docker/ubuntu-small/Dockerfile

#BOOM: http://erouault.blogspot.com/2019/
#build-arg not build-var

GDAL_VERSION=$(curl -Ls https://api.github.com/repos/rouault/gdal/commits/rfc75  -H "Accept: application/vnd.github.VERSION.sha")
docker build --build-arg GDAL_VERSION=${GDAL_VERSION} -t gdal_multid .
```
