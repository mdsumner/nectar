sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git
git clone https://github.com/OSGeo/gdal.git
sudo apt-get install libhdf4-dev --assume-yes
sudo apt-get install build-essential
sudo apt-get install libproj-dev
cd gdal
./configure
make 
make install
export LD_LIBRARY_PATH=/usr/local/lib

