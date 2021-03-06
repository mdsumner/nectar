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

## yikes
#wget http://download.osgeo.org/proj/proj-4.9.1.tar.gz
#tar -zxvf proj-4.9.1.tar.gz
#cd proj-4.9.1/
#sudo apt remove libproj-dev
#sudo apt remove proj-bin
#./configure --prefix=/usr
#make -j2
#sudo make install
#cd /etc/ld.so.conf.d
#sudo touch rgdal.conf
#echo '/usr/lib' | sudo tee -a rgdal.conf
#cd ~
#export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
#sudo R CMD REMOVE rgdal
#sudo R CMD INSTALL rgdal_1.0-2.tar.gz --configure-args='--with-gdal-config=/usr/local/bin/gdal-config'

cd gdal/gdal
./configure
make 
make install
export LD_LIBRARY_PATH=/usr/local/lib

sudo chown ubuntu /etc/apt/sources.list
sudo echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

sudo apt-get install r-base r-base-dev --assume-yes
sudo echo 'local({ r <- getOption("repos"); r["CRAN"] <- "http://cran.csiro.au/";options(repos = r); })' >> /etc/R/Rprofile.site

sudo apt-get install subversion
svn checkout svn://scm.r-forge.r-project.org/svnroot/rgdal/pkg
svn export pkg rgdal
R CMD build rgdal --no-build-vignettes
## R CMD INSTALL rgdal_1.0-2.tar.gz
## ghod, every step is trecherous . . .
R CMD INSTALL rgdal_1.0-2.tar.gz --configure-args='--with-gdal-config=/usr/bin/gdal-config'

Rscript -e 'install.packages(c("rgeos", "ncdf4", "raster"), "/usr/local/lib/R/site-library")'

## LaTeX, pandoc etc. nightmare - just google rstudio errors and follow the trail . . .
## sudo apt-get install ec

#apt-get install texlive-fonts-recommended --assume-yes
#apt-get install texlive-latex-recommended --assume-yes

apt-get install gdebi-core --assume-yes
apt-get install libapparmor1 --assume-yes # Required only for Ubuntu, not Debian


