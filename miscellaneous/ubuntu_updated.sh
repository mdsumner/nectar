#!/bin/bash

## define $threads
threads=`expr \`cat /proc/cpuinfo |grep -i 'core id'|wc -l\` \+ 1`

## up to date Ubuntu
## insert this text into "Customization Script"
## include whatever other additions you want further down
apt-get update --assume-yes
apt-get upgrade --assume-yes
apt-get install g++ make --assume-yes

