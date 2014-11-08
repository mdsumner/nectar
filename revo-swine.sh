#!/bin/bash

echo 'deb http://cran.csiro.au/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

## updated GDAL 
## https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable
add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

apt-get update 
apt-get upgrade --assume-yes


apt-get install gdebi-core
apt-get install libapparmor1 # Required only for Ubuntu, not Debian

## http://mran.revolutionanalytics.com/documents/rro/installation/#revorinst-lin
wget http://mran.revolutionanalytics.com/install/RRO-8.0-Beta-Ubuntu-14.04.x86_64.tar.gz

tar zxvf RRO-8.0-Beta-Ubuntu-14.04.x86_64.tar.gz
./install.shs

wget http://download2.rstudio.org/rstudio-server-0.98.1091-amd64.deb


