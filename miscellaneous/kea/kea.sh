## key for apt-get update, see http://cran.r-project.org/bin/linux/ubuntu/README
echo 'deb https://cran.ms.unimelb.edu.au/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

## updated GDAL 
## https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

export GDAL_INCLUDE_DIR=/usr/include/gdal
export GDAL_LIB_PATH=/usr/lib

apt-get install libgdal-dev libproj-dev gdal-bin
apt-get install mercurial git build-essential cmake-curses-gui -y
cd /usr/local/src
hg clone https://bitbucket.org/chchrsc/kealib
cd kealib/trunk
sudo ccmake .

## At this point, it is necessary to point the Makefile to the good directories for the GDAL and HDF5 libraries on 
# which it depends: GDAL_INCLUDE_DIR usually is /usr/include/gdal, while GDAL_LIB_PATH is /usr/lib.
# Press c to configure, then g to generate the Makefile, then launch the compilation:
make
make install

#The KEA plugin can then be linked with the other GDAL plugins. To do so, put the follwing lines at the end of your ~/.bashrc file:
GDAL_DRIVER_PATH=/usr/local/gdalplugins
export GDAL_DRIVER_PATH
Then reload your bashrc:
source ~/.bashrc



apt-get update 
apt-get upgrade --assume-yes

## Install 3rd parties

## pretty sure not 100% the -tools and -bin versions 
## are not needed for R but they are useful

## HDF4
apt-get install libhdf4-dev --assume-yes
apt-get install hdf4-tools --assume-yes

## NetCDF
apt-get install libnetcdf-dev --assume-yes
apt-get install netcdf-bin --assume-yes


## PROJ.4 and GDAL
apt-get install proj-bin --assume-yes
apt-get install libproj-dev --assume-yes
apt-get install libgdal-dev --assume-yes
apt-get install gdal-bin --assume-yes
apt-get install libgeos-dev --assume-yes

apt-get install libssl-dev  --assume-yes

