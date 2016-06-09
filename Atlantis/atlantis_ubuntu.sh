#!/bin/bash

## install Atlantis on standard Nectar Ubuntu 16.04 "Xenial"

##-------------------------------------------------------
## deps not fully specified yet
#apt-get install apt-transport-https --assume-yes
apt-get update 	
apt-get upgrade --assume-yes
apt-get install subversion --assume-yes
apt-get install automake --assume-yes

## Install 3rd parties

## PROJ.4 (dev but bin as well?)
apt-get install libproj-dev

##  nanohttp 
apt-get install libxml2-dev

## NetCDF (both dev and bin?)
apt-get install libnetcdf-dev --assume-yes
apt-get install netcdf-bin --assume-yes

##-------------------------------------------------------
## get and install Atlantis
## As user ARG
 
mkdir ~/svn
mkdir ~/svn/atlantis
cd ~/svn/atlantis
svn co https://svnserv.csiro.au/svn/ext/atlantis/Atlantis/trunk/atlantis   --username ARG
 
cd atlantis
## cmake "configure/make/install"
aclocal
autoheader
autoconf
## lotsa warnings here, but ok
automake -a
./configure
make
sudo make install
 
## but how do I run it? 
atlantisMerged
#Atlantis SVN Updated to Version 6026
#Atlantis SVN Path https://svnserv.csiro.au/svn/ext/atlantis/Atlantis/trunk/atlantis Relative ^/Atlantis/trunk/atlantis
#Atlantis SVN Last Change Date 2016-06-02 13:03:47 +1000 (Thu, 02 Jun 2016)
 
 
cd ~/svn/atlantis
 
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

## run it
AtlantisNCGen
#argc = 1
#Usage: AtlantisNCGen [ -t template.nc | -g groups.csv] -o outputFile.nc -r runParams.csv -b boxTracers.csv -l boxLayerTracers.csv [boxLayerTracers2.csv ...]

#See the README.odt file for more information

