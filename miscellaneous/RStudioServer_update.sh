#!/usr/bin/bash
apt-get update --assume-yes
apt-get upgrade --assume-yes
wget http://download2.rstudio.org/rstudio-server-0.98.1079-amd64.deb
gdebi rstudio-server-0.98.1079-amd64.deb

