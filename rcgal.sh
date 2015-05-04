
apt-get update --assume-yes
apt-get upgrade --assume-yes
apt-get install libcgal-dev --assume-yes
apt-get install libcgal-demo --assume-yes
apt-get install cmake g++ --assume-yes

git clone https://github.com/s-u/rcgal.git
git clone https://github.com/s-u/fastshp.git

R CMD build rcgal
R CMD build fastshp
R CMD INSTALL rcgal_.tar.gz
R CMD INSTALL fastshp_.tar.gz

#library(fastshp)
#library(rcgal)
#d <- read.shp("Countries.shp")

## area 
#.Call("shp_area", PACKAGE = "rcgal", d)
#.Call("shp_orientation", PACKAGE = "rcgal", d)
## etc. 


