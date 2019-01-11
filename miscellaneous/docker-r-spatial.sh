#!/bin/bash
## debian

apt-get update
apt-get install apt-transport-https ca-certificates --assume-yes
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
 
echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list


apt-get update
apt-get upgrade --assume-yes
apt-get install docker-engine --assume-yes
service docker start

docker run -d -p 8787:8787 rocker/hadleyverse

## now go to http://ip:8787 and login as per https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image

## sudo usermod -a -G docker <username>
