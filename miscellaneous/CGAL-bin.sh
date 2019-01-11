#!/bin/bash

## up to date Ubuntu
## insert this text into "Customization Script"
## include whatever other additions you want further down

apt-get update --assume-yes
apt-get upgrade --assume-yes
apt-get install libcgal-dev --assume-yes
apt-get install libcgal-demo --assume-yes
apt-get install cmake g++

tar --gzip -xf /usr/share/doc/libcgal-demo/examples.tar.gz
tar --gzip -xf /usr/share/doc/libcgal-demo/demo.tar.gz

## QGLViewer (also need GLEW for some Mesh_3 demos, not sure yet)
wget http://www.libqglviewer.com/src/libQGLViewer-2.5.3.tar.gz

tar -xzf libQGLViewer-2.5.3.tar.gz
cd libQGLViewer-2.5.3/QGLViewer

qmake
make
sudo make install
########################################


## http://homepages.math.uic.edu/~ddumas/teaching/2014/spring/mcs481/cgal-example/
