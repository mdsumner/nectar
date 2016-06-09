#!/bin/bash

##-------------------------------------------------------
## deps not fully specified yet

apt-get install apt-transport-https --assume-yes
apt-get update 	
apt-get upgrade --assume-yes

## Install 3rd parties

## NetCDF
apt-get install libnetcdf-dev --assume-yes
apt-get install netcdf-bin --assume-yes

##-------------------------------------------------------
## get and install Atlantis
## As user ARG
 
cd /home/shared/svn/
svn co https://svnserv.csiro.au/svn/ext/atlantis/Atlantis/trunk/atlantis   --username ARG
 
cd atlantis
## cmake "configure/make/install"
aclocal
autoheader
autoconf
automake -a
./configure
make
sudo make install
 
## but how do I run it? (I had a look in /usr/local/bin to see the new executable)
atlantisMerged
#Atlantis SVN Updated to Version 6026
#Atlantis SVN Path https://svnserv.csiro.au/svn/ext/atlantis/Atlantis/trunk/atlantis Relative ^/Atlantis/trunk/atlantis
#Atlantis SVN Last Change Date 2016-06-02 13:03:47 +1000 (Thu, 02 Jun 2016)
 
 
cd /home/shared/svn
 
svn co https://svnserv.csiro.au/svn/ext/atlantis/AtlantisNCGen/trunk/atlantisNCGen/ --username ARG
 
cd atlantisNCGen
## cmake "configure/make/install"
aclocal
autoheader
autoconf
automake -a
./configure
make
sudo make install
 
