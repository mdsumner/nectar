
Ubuntu 20.04

```bash


sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt upgrade

sudo apt install g++ libxml2-dev libcurl4-openssl-dev libproj-dev autotools-dev autoconf libtool pkg-config make

## then in .bashrc
#export MAKEFLAGS = -j27
#export PATH="$HOME/bin:$PATH"
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$HOME/lib"

git clone https://github.com/osgeo/gdal
cd GDAL/gdal
./autogen.sh
./configure --prefix=/home/ubuntu
make
make install



gdalinfo --version
GDAL 3.4.0dev-e37f6bc55f, released 2021/09/22

```
