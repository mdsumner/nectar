echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' >> /etc/apt/sources.list

## key for R 3.5.0
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

apt update 
apt upgrade --assume-yes

apt install cmake make g++ libx11-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxrandr-dev libxext-dev libxcursor-dev libxinerama-dev libxi-dev libssl-dev libcurl4-openssl-dev 

apt install libglew-dev libglfw3-dev

apt install --assume-yes    r-base r-base-dev git

install remotes, usethis, shader
#libjq-dev libv8-3.14-dev  libmagick++-dev libarchive-dev libnetcdf-dev proj-bin \
   #libxml2-dev libcurl4-openssl-dev \ 
   #libproj-dev libgdal-dev gdal-bin libgeos-dev  libssl-dev libgl1-mesa-dev libglu1-mesa-dev \
   #libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick libgit2-dev \
