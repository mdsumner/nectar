sudo apt-get update
sudo apt-get upgrade --assume-yes
sudo apt-get install git --assume-yes
sudo apt-get install libnetcdf-dev --assume-yes
sudo apt-get install netcdf-bin --assume-yes
sudo apt-get install libhdf4-dev --assume-yes
sudo apt-get install build-essential --assume-yes
sudo apt-get install libproj-dev --assume-yes
sudo apt-get install proj-bin --assume-yes
git clone https://github.com/OSGeo/gdal.git

cd gdal
./configure
make 
make install
export LD_LIBRARY_PATH=/usr/local/lib



