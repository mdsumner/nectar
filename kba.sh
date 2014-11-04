cd ~/build
wget ftp://ftp.stat.math.ethz.ch/Software/R/R-patched.tar.gz
tar zxvf R-patched.tar.gz
cd R-patched
./configure --prefix=/u/mdsumner/
make -j8
make install

module load netcdf/3.6.2-gnu  
udunits/2.1.7

bin/Rscript -e 'install.packages(c("RNetCDF"))'

