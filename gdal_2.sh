sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git
git clone https://github.com/OSGeo/gdal.git
sudo apt-get install libhdf4-dev --assume-yes
sudo apt-get install build-essential
cd gdal
./configure
make 

