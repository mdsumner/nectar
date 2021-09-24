
Ubuntu 20.04

```bash


sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt upgrade

sudo apt install g++ libxml2-dev libcurl4-openssl-dev libproj-dev autotools-dev autoconf libtool pkg-config make libsqlite3-dev sqlite3

## then in .bashrc
#export MAKEFLAGS = -j27
#export PATH="$HOME/bin:$PATH"
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$HOME/lib"

git clone https://github.com/osgeo/proj
cd proj
git checkout 8.1
./autogen.sh
./configure --prefix=$HOME --with-proj=$HOME

make
make install

git clone https://github.com/osgeo/gdal
cd GDAL/gdal
./autogen.sh
./configure --prefix=$HOME
make
make install
#gdalinfo --version
#GDAL 3.4.0dev-e37f6bc55f, released 2021/09/22


## R
sudo apt install --no-install-recommends software-properties-common dirmngr gdebi-core libssl-dev 
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base

wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
sudo gdebi rstudio-server-1.4.1717-amd64.deb

## all the github bs
## get a token for HTTPS https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
## get gh cli (not gitsome ...) https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git
##                               https://medium.com/analytics-vidhya/github-cli-brings-github-to-your-terminal-809cea627d62

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh

```
