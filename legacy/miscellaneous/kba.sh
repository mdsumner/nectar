#!/bin/bash

cd ~/build
rm -rf R-patched
wget ftp://ftp.stat.math.ethz.ch/Software/R/R-patched.tar.gz
tar zxvf R-patched.tar.gz
cd R-patched
./configure --prefix=/u/mdsumner/
make -j 4
make install

cd ~/build
wget   ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4/hdf5-1.8.13.tar.gz
tar zxvf hdf5-1.8.13.tar.gz
cd hdf5-1.8.13
./configure --prefix=/u/mdsumner/
make -j 4
make install

cd ~/build
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.2.tar.gz
tar zxvf netcdf-4.3.2.tar.gz
cd netcdf-4.3.2


env H5DIR="/u/mdsumner" CPPFLAGS="-I/u/mdsumner/include" LDFLAGS="-L/u/mdsumner/lib" ./configure --prefix=/u/mdsumner/

make -j 4
make install

cd ~/build

wget ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.17.tar.gz
tar zxvf udunits-2.2.17.tar.gz
cd udunits-2.2.17/
./configure --prefix=/u/mdsumner/

env LD_LIBRARY_PATH="/u/mdsumner/lib" bin/Rscript -e 'install.packages(c("RNetCDF"), configure.args = c("--with-netcdf-include=/u/mdsumner/include --with-netcdf-lib=/u/mdsumner/lib --with-udunits-include=/u/mdsumner/include --with-udunits-lib=/u/mdsumner/lib"))'

env LD_LIBRARY_PATH="/u/mdsumner/lib" bin/Rscript -e 'install.packages(c("ncdf4"), configure.args = c("--with-netcdf-include=/u/mdsumner/include --with-netcdf-lib=/u/mdsumner/lib"))'

env LD_LIBRARY_PATH="/u/mdsumner/lib" bin/R
