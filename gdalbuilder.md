
Ubuntu 20.04

```bash


sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt upgrade

sudo apt install g++ libxml2-dev libcurl4-openssl-dev libproj-dev autotools-dev autoconf libtool pkg-config make

git clone https://github.com/osgeo/gdal
cd GDAL/gdal
./autogen.sh
./configure --prefix=/home/ubuntu
make
make install

```
