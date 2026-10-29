# Issues, 2017–2025

Everything from this repo's GitHub issues (#3–#14), copied here on 2026-10-29 when
the issues were closed. Kept as written: build notes, fixes to old scripts, and
experiments. They're out of date and aren't instructions; the guide replaces them.

- #14 (DNS and HTTPS for RStudio) was mined into `guide/06-rstudio-server.md`.
- #10 (AWS and rocker) overlaps with `guide/01-concepts.md` (EC2) and `guide/07-software.md`.
- Ideas from #12 and #13 are in `TODO.md`.

## #3 2x single quote missing

*closed, opened 2017-10-11 by JustBerkhout, closed 2018-09-13* — https://github.com/mdsumner/nectar/issues/3

line 25 and 26 are missing their closing single quote

### Comment by mdsumner, 2017-10-11

Thanks!  


## #4 jqr

*closed, opened 2017-10-11 by JustBerkhout, closed 2018-09-13* — https://github.com/mdsumner/nectar/issues/4

jqr failed in my install. Upon fail (uin the stdout log) it suggests the apt instructions:
add-apt-repository -y ppa:opencpu/jq
apt-get update
apt-get install libjq-dev

after which 
Rscript -e 'install.packages(c("jqr"), "/usr/local/lib/R/site-library")'
succeeds


### Comment by JustBerkhout, 2017-10-11

This resolves these three issues
Warning messages:
1: In install.packages(c("devtools", "sfdct", "rgdal", "leaflet", "rgeos",  :
  installation of package ‘jqr’ had non-zero exit status
2: In install.packages(c("devtools", "sfdct", "rgdal", "leaflet", "rgeos",  :
  installation of package ‘geojson’ had non-zero exit status
3: In install.packages(c("devtools", "sfdct", "rgdal", "leaflet", "rgeos",  :
  installation of package ‘geojsonio’ had non-zero exit status

### Comment by mdsumner, 2017-10-11

I've added this in now, cheers. 

(The raad-client has stalled a bit but it works well, at some point we'll have to formalize the build so it's able to be actually stable - and this will help!)


## #5 why this HDF error?

*closed, opened 2018-02-15 by mdsumner, closed 2018-09-13* — https://github.com/mdsumner/nectar/issues/5

Notes for later

```


ncdump -h  .../oceandata.sci.gsfc.nasa.gov/MODISA/L3BIN/2003/001/A2003001.L3b_DAY_RRS.nc

rs2 (rw) and aes2 (ro) - succeeds over nfs 
This netCDF 4.4.0 has been built with the following features:

  --cc        -> /usr/bin/x86_64-linux-gnu-gcc
  --cflags    -> -I/usr/include -I/usr/include/hdf5/serial
  --libs      -> -L/usr/lib -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lnetcdf -lhdf5_hl -lhdf5 -lpthread -lsz -lz -ldl -lm -lcurl

  --has-c++   -> no
  --cxx       ->
  --has-c++4  -> no
  --cxx4      ->

  --fc        ->
  --fflags    ->
  --flibs     ->
  --has-f90   -> no

  --has-dap   -> yes
  --has-nc2   -> yes
  --has-nc4   -> yes
  --has-hdf5  -> yes
  --has-hdf4  -> no
  --has-pnetcdf-> no
  --has-szlib -> no

  --prefix    -> /usr
  --includedir-> /usr/include
  --version   -> netCDF 4.4.0





3121 - rw  - fails over nfs, succeeds local

This netCDF 4.6.0 has been built with the following features:

  --cc        -> /usr/bin/cc
  --cflags    -> -I/usr/include -I/usr/include/hdf5/serial
  --libs      -> -L/usr/lib/x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lnetcdf -lhdf5_hl -lhdf5 -lpthread -lsz -lz -ldl -lm -lcurl

  --has-c++   -> no
  --cxx       ->

  --has-c++4  -> no
  --cxx4      ->

  --has-fortran-> no
  --has-dap   -> yes
  --has-dap2  -> yes
  --has-dap4  -> yes
  --has-nc2   -> yes
  --has-nc4   -> yes
  --has-hdf5  -> yes
  --has-hdf4  -> no
  --has-logging-> no
  --has-pnetcdf-> no
  --has-szlib -> no
  --has-cdf5 -> no
  --has-parallel-> no

  --prefix    -> /usr
  --includedir-> /usr/include
  --libdir    -> /usr/lib/x86_64-linux-gnu
  --version   -> netCDF 4.6.0



ctp - readonly - fails over nfs, succeeds local
nc-config --all

This netCDF 4.5.0 has been built with the following features:

  --cc        -> /usr/bin/cc
  --cflags    -> -I/usr/include -I/usr/include/hdf5/serial
  --libs      -> -L/usr/lib/x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lnetcdf -lhdf5_hl -lhdf5 -lpthread -lsz -lz -ldl -lm -lcurl

  --has-c++   -> no
  --cxx       ->

  --has-c++4  -> no
  --cxx4      ->

  --has-fortran-> no
  --has-dap   -> yes
  --has-dap2  -> yes
  --has-dap4  -> yes
  --has-nc2   -> yes
  --has-nc4   -> yes
  --has-hdf5  -> yes
  --has-hdf4  -> no
  --has-logging-> no
  --has-pnetcdf-> no
  --has-szlib -> no
  --has-cdf5 -> no
  --has-parallel-> no
```

### Comment by mdsumner, 2018-09-13

We found on marine pred that it works via sshfs, but not via NFS. 

If you copy the NetCDF4 file to the VM it works, but from the network it doesn't. Nobody knows why. 


## #6 install_github in r-spatial.sh fails

*closed, opened 2018-11-30 by JustBerkhout, closed 2018-11-30* — https://github.com/mdsumner/nectar/issues/6

The line 
```
Rscript -e 'devtools::install_github(c("bhaskarvk/leaflet.extras", "environmentalinformatics-marburg/mapview@develop", "SWotherspoon/SGAT", "SWotherspoon/BAStag", "hypertidy/tidync"), "/usr/local/lib/R/site-library")'
```
fails with 
```
Error: HTTP error 404.
  No commit found for the ref /usr/local/lib/R/site-library
```

### Comment by JustBerkhout, 2018-11-30

adding explicit argument name `lib=` for the site-library argument fixes this. I.e.
```
Rscript -e 'devtools::install_github(c("bhaskarvk/leaflet.extras", "environmentalinformatics-marburg/mapview@develop", "SWotherspoon/SGAT", "SWotherspoon/BAStag", "hypertidy/tidync"), lib="/usr/local/lib/R/site-library")'
```

### Comment by mdsumner, 2018-11-30

Thanks!  I  removed a couple of entries and updated


## #7 `git` is missing from `r-spatial.sh`

*closed, opened 2018-12-17 by JustBerkhout, closed 2019-09-18* — https://github.com/mdsumner/nectar/issues/7

I manually installed git after running the r-spatial spiel. 

(sudo) apt install git

### Comment by mdsumner, 2018-12-17

What OS? I've rarely had to do this, but thanks!

### Comment by mdsumner, 2019-09-18

it's in here now https://github.com/mdsumner/nectar/blob/master/r-spatial.md


## #8 secure server

*closed, opened 2019-01-10 by mdsumner, closed 2019-09-18* — https://github.com/mdsumner/nectar/issues/8





### Comment by JustBerkhout, 2019-01-11

```bash
os server create --flavor m3.small --image 'NeCTAR Ubuntu 18.04 LTS (Bionic) amd64' --nic net-id='Classic Provider' --security-group ssh --key-name JustServiceKey --availability-zone tasmania acme
```


## #9 notes for GDAL hacking

*open, opened 2022-03-08 by mdsumner* — https://github.com/mdsumner/nectar/issues/9


latest and greatest on aceeco

```
cmake ..  -DGDAL_USE_PCODEC=ON -DGDAL_USE_GEOTIFF_INTERNAL=ON -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_UNITY_BUILD=ON  -DCMAKE_BUILD_TYPE=Release 

sudo cmake --build . --parallel 31 --target install
```

how to rebase https://adamj.eu/tech/2022/03/25/how-to-squash-and-rebase-a-git-branch/

```
git checkout master
git pull
git checkout <new-feature>
git rebase --keep-base -i master  ## fixup all the dross (f on lines below first)
git rebase -i master
```


Getting this down to much tighter

```
git clone https;//github.com/osgeo/gdal.git

## get a specific PR branch
#git remote add rouault https://github.com/rouault/gdal
#git fetch rouault
#git checkout <...>

## sudo usermod -aG docker $USER
## fire up docker for gdal-deps, so we can build with whatever PR 
docker run -it \
    -v $(pwd):/gdal:rw \
    ghcr.io/osgeo/gdal-deps:ubuntu20.04-master
cd gdal
mkdir build
cd build
../.github/workflows/ubuntu_20.04/build.sh
make install

```

to build from source do 


```
 sudo python3.10 -m pip install -r ../doc/requirements.txt
 sudo python3.10 -m pip install -r ../autotest/requirements.txt

cmake ..  -DGDAL_USE_GEOTIFF_INTERNAL=ON -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_UNITY_BUILD=ON  -DCMAKE_BUILD_TYPE=Release -DPython_LOOKUP_VERSION=3.10.12

sudo cmake --build . --parallel 31  --target install

sudo python3 -m pip install pre-commit
pre-commit install
```

to lint and test

```
pre-commit run --all-files

python3.10 -m pytest ../autotest/gcore/vrt_read.py -k test_vrt_protocol

```



with rocker: 

```
docker build . -f dockerfiles/geospatial-dev-osgeo_4.3.1.Dockerfile  -t install-osgeo.gdal
docker run --rm -ti install-osgeo.gdal bash
```










##OLD NOTES BELOW




To check out and build GDAL from source, as ubuntu user

## GDAL Build hints

https://gdal.org/build_hints.html

## My notes

first PROJ (Note that 8.2 is still autotools, cmake required as of version 9.0 - I'll update)

```
git clone https://github.com/osgeo/proj
cd proj
git checkout 8.2
./autogen.sh
./configure --prefix=$HOME

make  ## I have 'MAKEFLAGS -j[n]' env set
make install
```

now GDAL, with new cmake

```
#sudo apt-get install python3-dev
#git clone https://github.com/osgeo/gdal
#cd gdal
#mkdir build
# cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$HOME
cmake --build . --parallel 26  
cmake --build . --target install 
```



then to check utility function

```
gdalinfo --version
GDAL 3.5.0dev-4f4292740a, released 2022/03/08
~/builds/proj$ proj
Rel. 8.2.1, January 1st, 2022
usage: proj [-bdeEfiIlmorsStTvVwW [args]] [+opt[=arg] ...] [file ...]
```

previous notes were here, I will update once I get this sorted:   https://github.com/mdsumner/nectar/blob/master/gdalbuilder.md




### Comment by mdsumner, 2022-03-08

working example with bbox, crs, and bands in 'vrt_connection' branch: https://github.com/mdsumner/gdal/tree/vrt_connection

autotest/ is in the gdal source tree

```
gdalinfo "vrt://autotest/gdrivers/data/netcdf/MODIS_ARRAY.nc?a_ullr=0,1,1,0&a_srs=EPSG:3857&a_ullr=100,200,1000,-300&bands=1,1"
```

### Comment by mdsumner, 2022-03-09

now add '-ot' output type

```
 gdalinfo "vrt://autotest/gdrivers/data/netcdf/MODIS_ARRAY.nc?a_ullr=0,1,1,0&a_srs=EPSG:3031&a_ullr=100,200,1000,-300&bands=1,1&ot=Float64"
```



### Comment by mdsumner, 2022-03-09

'-if' (doesn't seem to work)

'-expand' (fails sometimes ?? is there a transient temp file or something?)

```
gdalinfo "vrt://autotest/gcore/data/test_average_palette.tif?expand=rgba&if=NetCDF"
```

### Comment by mdsumner, 2022-03-10

what is up with this?  it doesn't work, and then it does ...

![image](https://user-images.githubusercontent.com/4107631/157579078-ebf613f3-c172-4573-b118-7f5d42f759a9.png)


### Comment by mdsumner, 2022-04-01

how to do GDAL executable

```C++
#include <iostream>
#include "gdal.h"
#include "ogr_spatialref.h"

bool this_way(char *input) {
  OGRSpatialReference srs;
  srs.SetFromUserInput(input);
  char *txt = nullptr;
  srs.exportToProj4(&txt);
  std::cout << txt << "\n";
  CPLFree(txt);
  return true;
}

bool cpl_way(CPLString input) {
  OGRSpatialReference srs;
  srs.SetFromUserInput(input);

  char *output = nullptr;
  srs.exportToProj4(&output);
  std::cout << output << "\n";
  CPLFree(output);
  return true;
}


bool that_way(char *input) {
  OGRSpatialReference *srs = nullptr;
  srs = new OGRSpatialReference;
  srs->SetFromUserInput(input);
  char *txt = nullptr;
  srs->exportToProj4(&txt);
  delete srs;
  std::cout << txt << "\n";

  CPLFree(txt);
  return true;
}

int main() {
  char input[] = "WGS84";
  bool yes = this_way(input);
  bool no  = that_way(input);
  CPLString   input2{};
  input2 = "WGS84";
  bool cpl = cpl_way(input2);
  return 1;
}

```

```bash
g++  -I/usr/include/gdal  -o program program.cpp -L/usr/lib -lgdal -lproj
./program
```

> +proj=longlat +datum=WGS84 +no_defs
> +proj=longlat +datum=WGS84 +no_defs
> +proj=longlat +datum=WGS84 +no_defs



### Comment by mdsumner, 2022-04-05

so, you can do spaces in the args, or escape them, committed just now

> gdalinfo "vrt://autotest/gdrivers/data/netcdf/MODIS_ARRAY.nc?a_srs=EPSG:3857&bands=1,1&a_ullr=0\ 10\ 100\ -10"
> gdalinfo "vrt://autotest/gdrivers/data/netcdf/MODIS_ARRAY.nc?a_srs=EPSG:3857&bands=1,1&a_ullr=0 10 100 -10"

you can't use commas in the decimals, but gdalinfo normally can so we'd better use it's parsing (it can mix them even)




### Comment by mdsumner, 2022-04-06

the spaces fail when it comes to the VRT text, you get '&amp;' but not %20

### Comment by mdsumner, 2022-09-28

just my geoarrow-cpp notes

```
mkdir test
cp test.cpp test/
cd test
cp ../CMake* .
#nano CMakeLists.txt ## edit CMakeLists to ../src/geoarrow etc
cmake .
g++ test.cpp -L . -lgeoarrow -lm
./test
g++ test.cpp -L . -lgeoarrow -lm -o test

```

### Comment by mdsumner, 2023-02-06

new, here we're consolidating

- PROJ and GEOS from source, selecting specific version
- R from CRAN advised repos, install for latest release (we'll get the binary package installs via r2u or pak)
- GDAL from source, latest commits

I've got most libraries we need, there is some remaining stuff around BLOSC, lz4, Zstandard, that family of compression stuff or whatever it is. 


```

## arrow

sudo apt update
sudo apt install -y -V ca-certificates lsb-release wget
wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt update
sudo apt install -y -V libarrow-dev # For C++

sudo apt upgrade

## R

# update indices
sudo apt update -qq
# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --assume-yes \
    libmagick++-dev libarchive-dev libnetcdf-dev libnode-dev \
   libxml2-dev libcurl4-openssl-dev   libssl-dev libgl1-mesa-dev libglu1-mesa-dev \
   libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick libgit2-dev r-base r-base-dev 

sudo apt install g++ libxml2-dev libcurl4-openssl-dev cmake pkg-config make libsqlite3-dev  python3-dev libtiff-dev  lz4 libgtest-dev  libkml-dev   libparquet-dev libarrow-dataset-dev libxerces-c-dev  libhdf4-dev libblosc-dev sqlite3

git clone https://github.com/osgeo/proj
cd proj
git checkout 9.1.1
mkdir build
cd build
cmake ..
sudo cmake --build . --parallel 31  --target install 

git clone https://github.com/libgeos/geos
cd geos
git checkout 3.11.1
mkdir build
cd build
cmake ..
sudo cmake --build . --parallel 31  --target install 



git clone https://github.com/osgeo/gdal
cd gdal
mkdir build
cd build

## finally got this to work, see https://gist.github.com/mdsumner/526af876cfddaa5ff245ab376b3cec84
##cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr   

## without csharp or java (since 2023-03-15) 
cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr   -DBUILD_JAVA_BINDINGS:BOOL=OFF -DBUILD_CSHARP_BINDINGS:BOOL=OFF

sudo cmake --build . --parallel 31  --target install 

sudo apt install docker.io

## this doesn't work, it doesn't pick up the system libs above
#sudo usermod -aG docker ubuntu
#docker run --rm -ti -e PASSWORD=yourpassword -p 8787:8787 rocker/rstudio  user/yourpassword
```

### Comment by mdsumner, 2023-02-19

So using the above, or using the docker target builder from the gdal docker scripts, I needed to do

```
cp -R  /usr/local/lib/python3/dist-packages/* /usr/local/lib/python3.8/dist-packages/
```

none of PYTHONPATH or LD_LIBRARY_PATH or any other config I could find would work , so I'll just hack this for now. 



### Comment by mdsumner, 2023-02-19

the docker way, with full

```
#~/Git/gdal-source/gdal/docker/ubuntu-full$ 
docker build . --target builder  -t hypertidy/gdal-full
docker run -it --rm -v /home/gdal/Git/gdal-source:/gdal-source  hypertidy/gdal-full
cd gdal-source/gdal/build2  ## use different
## cmake config and build/install as above
cd ../autotest
apt update
apt install python3-pip ## wtaf
python3.8 -m pip install -r ./requirements.txt
pytest gdrivers/mem.py::test_mem_2


```

### Comment by mdsumner, 2023-02-23

getting smarter about docker, using gdal-source/ubuntu-small-mike

```
## build the runner
docker build .   -t hypertidy/gdal-small-runner
docker build . --target builder  -t hypertidy/gdal-small-builder

## run em
docker run -it --rm -v /home/gdal/Git/gdal-source:/gdal-source  hypertidy/gdal-small-runner

docker run -it --rm -v /home/gdal/Git/gdal-source:/gdal-source  hypertidy/gdal-small-builder
```


### Comment by mdsumner, 2023-04-05

/vsicurl/https://gebco2022.s3.valeria.science/gebco_2022_complete_cog.tif

### Comment by mdsumner, 2023-05-12

building netcdf with cmake (on gdalserver)

```
- # NetCDF C Configuration Summary
==============================

# General
-------
NetCDF Version:         4.9.2
Dispatch Version:       5
Configured On:          Fri 12 May 2023 00:21:30 UTC
Host System:            x86_64-Linux-5.4.0-148-generic
Build Directory:        /home/gdal/source/netcdf-c-4.9.2
Install Prefix:         /usr/local
Plugin Install Prefix:  N.A.

# Compiling Options
-----------------
C Compiler:             /usr/bin/cc
CFLAGS:                  -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -g -Wall -Wconversion
CPPFLAGS:
LDFLAGS:                  -Wl,--no-undefined
AM_CFLAGS:
AM_CPPFLAGS:
AM_LDFLAGS:
Shared Library:         yes
Static Library:         no
Extra libraries:        -lhdf5_hl -lhdf5 -lpthread -lsz -lz -ldl -lm -lblosc -lzstd -lbz2 -lcurl -lxml2
XML Parser:             libxml2

# Features
--------
Benchmarks:             no
NetCDF-2 API:           yes
HDF4 Support:           no
HDF5 Support:           yes
NetCDF-4 API:           yes
CDF5 Support:           yes
NC-4 Parallel Support:  no
PnetCDF Support:        no

DAP2 Support:           yes
DAP4 Support:           yes
Byte-Range Support:     yes

S3 Support:             no

NCZarr Support:         yes
NCZarr Zip Support:     no

Diskless Support:       yes
MMap Support:           yes
JNA Support:            no
ERANGE Fill Support:    yes
Relaxed Boundary Check: yes

Multi-Filter Support:   yes
Quantization:           yes
Logging:                no
SZIP Write Support:     yes
Standard Filters:       deflate szip blosc zstd bz2
ZSTD Support:           yes
Parallel Filters:       yes


-- Configuring done
-- Generating done
-- Build files have been written to: /home/gdal/source/netcdf-c-4.9.2
```

### Comment by mdsumner, 2023-08-01

for python plots over ssh I needed

sudo apt-get install python3-tk
sudo apt-get install qt5-default 


### Comment by mdsumner, 2023-09-09

ok so on gdal server stick with this for now

```
 sudo python3.8 -m pip install -r ./doc/requirements.txt
 sudo python3.8 -m pip install -r ./autotest/requirements.txt

cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr  -DPython_LOOKUP_VERSION=3.8.10

sudo cmake --build . --parallel 31 --target install

```

### Comment by mdsumner, 2023-11-03

here is the rocker dev-osgeo

https://github.com/rocker-org/rocker-versioned2/pkgs/container/geospatial

then I had to do 

```
sudo apt update 
sudo apt upgrade

sudo apt install python-dev-is-python3

wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

sudo python3 -m pip install cryptography pandas datetime  fsspec branca  click pyparsing dask  pystac_client xarray cachetools zarr odc-stac

sudo python3 -m pip install gdal   gnm ogr osr  --no-binary "gdal,gnm,ogr,osr"  
sudo python3 -m pip install rasterio shapely fiona geopandas pyproj  affine --no-binary "rasterio,shapely,fiona,geopandas,pyproj,affine"
sudo python3 -m pip install folium
sudo python3 -m pip install  odc-stac  odc-geo rioxarray  --no-binary ":all:"

```

then it's all good in 3.10.12




### Comment by mdsumner, 2023-11-03

scratch the above, do it all from source and use this: https://github.com/auspatious/dea-coastlines/blob/stable/Dockerfile


### Comment by mdsumner, 2023-11-06

sudo apt install python3-pip

sudo python3 -m pip install affine branca cachetools click cryptography dask datetime fiona folium fsspec gdal geopandas gnm odc-geo odc-stac odc-stac ogr osr pandas pyparsing pyproj pystac_client rasterio rioxarray shapely xarray zarr --nobinary ":all:"



## #10 notes for AWS

*open, opened 2022-05-18 by mdsumner* — https://github.com/mdsumner/nectar/issues/10

t2-micro instance (with 30Gb disk)

make sure ssh 22 and htpp 8787 (and 8888) and set up

then choose ubuntu, apt upgrade, also docker install snafu is differet in new ubuntu

Then

```
sudo docker pull rocker/geospatial:dev-osgeo

sudo docker run --rm \
           -p 8888:8787 \
           -e PASSWORD=<you password> \
           rocker/geospatial:dev-osgeo &

## set security group rule for 8888 (not sure why this map thing but that worked)

http://<public ip>:8888
```

happy 

### Comment by mdsumner, 2022-05-18

this is more, we need to set ENV for specific versions of PROJ, GDAL, GEOS and we need to build the docker image and then push it for reuse

```
## basic use of rocker
sudo docker run  \
           -p 8888:8787 \
           -e PASSWORD=pass \
           rocker/geospatial:dev-osgeo &


## set security group rule for 8888 (not sure why this map thing but that worked)
http://<public ip>:8888

but what we want is 
sudo docker build . -t mike:3.5.0 -f  mike.Dockerfile

## Dockerfile:  (use tidyverse, or rstudio, not verse)
FROM rocker/tidyverse:devel
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

ENV PROJ_VERSION=9.0.0
ENV GDAL_VERSION=3.5.0
ENV GEOS_VERSION=3.10.2

RUN /rocker_scripts/dev_osgeo.sh
```

then for example

```
 docker build . -t hypertidy_gdal3.5.0 -f  hypertidy_gdal3.5.0.Dockerfile

docker push mdsumner/hypertidy:hypertidy_gdal3.5.0
```





## #11 notes from old raadtools dicuss

*open, opened 2022-08-30 by mdsumner* — https://github.com/mdsumner/nectar/issues/11

https://github.com/AustralianAntarcticDivision/raadtools/issues/73


## #12 python sheesh

*open, opened 2022-09-08 by mdsumner* — https://github.com/mdsumner/nectar/issues/12

```bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt upgrade

sudo apt install g++ libxml2-dev libcurl4-openssl-dev libproj-dev cmake autoconf libtool pkg-config make libsqlite3-dev sqlite3 libnetcdf-dev libmagick++-dev libarchive-dev  proj-bin libnode-dev libxml2-dev libcurl4-openssl-dev libproj-dev  libgeos-dev  libssl-dev libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick python3-dev libhdf4-dev libhdf5-dev

git clone https://github.com/osgeo/gdal
cd gdal
mkdir build
 cd build

cmake .. ##-DCMAKE_INSTALL_PREFIX=$HOME
cmake --build . --parallel 31
sudo cmake --build . --target install 
sudo ldconfig

wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

sudo python3 -m pip install numpy packaging pandas zarr netCDF4 rasterio bottleneck
sudo python3 -m pip install "dask[complete]"
sudo python3 -m pip install xarray geopandas sparse aiohttp requests matplotlib

## R
sudo apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base

sudo apt install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.1-554-amd64.deb
sudo gdebi rstudio-server-2022.07.1-554-amd64.deb

sudo apt install build-essential gfortran

Rscript -e 'remotes::install_cran("RcppEigen")'

## put makeflags and cloud.r-project.org in .Renviron 
Rscript -e 'remotes::install_cran(c("angstroms", "anglr", "backports",   "base64enc", "BiocManager", "bitops",   "caTools", "crayon", "devtools", "evaluate", "formatR", "geojsonio",   "ggforce", "ggraph", "graticule", "highr", "htmltools", "htmlwidgets",   "httpuv", "knitr", "leaflet", "magick", "mapview", "markdown",   "ncdf4", "praise", "proj4", "PROJ", "reproj", "quadmesh", "raster", "rbgm", "rgdal",   "rgeos", "rgl", "rmarkdown", "RNetCDF", "rprojroot", "rworldmap",   "sf", "sfdct", "shiny", "sourcetools", "spbabel", "spdplyr",   "spex", "tabularaster", "testthat", "tibble", "tidync", "tidyverse", "traipse", "vapour",   "xtable", "yaml", "decido", "RTriangle", "silicate", "ceramic", "crsmeta", "unjoin", "lazyraster", "geodist", "sfheaders", "mapdeck",  "trip", "traipse", "bsam", "geos", "wk", "reticulate"))'


```


### Comment by mdsumner, 2022-09-08

minimal test

```python

import xarray as xr 
import geopandas as gp 
import pandas as pd 
import sparse

store = 'https://ncsa.osn.xsede.org/Pangeo/pangeo-forge/gpcp-feedstock/gpcp.zarr'

ds = xr.open_dataset(store, engine='zarr', chunks={})
ds
<xarray.Dataset>
Dimensions:      (latitude: 180, nv: 2, longitude: 360, time: 9226)
Coordinates:
    lat_bounds   (latitude, nv) float32 dask.array<chunksize=(180, 2), meta=np.ndarray>
  * latitude     (latitude) float32 -90.0 -89.0 -88.0 -87.0 ... 87.0 88.0 89.0
    lon_bounds   (longitude, nv) float32 dask.array<chunksize=(360, 2), meta=np.ndarray>
  * longitude    (longitude) float32 0.0 1.0 2.0 3.0 ... 356.0 357.0 358.0 359.0
  * time         (time) datetime64[ns] 1996-10-01 1996-10-02 ... 2021-12-31
    time_bounds  (time, nv) datetime64[ns] dask.array<chunksize=(200, 2), meta=np.ndarray>
Dimensions without coordinates: nv
Data variables:
    precip       (time, latitude, longitude) float32 dask.array<chunksize=(200, 180, 360), meta=np.ndarray>
Attributes: (12/45)
    Conventions:                CF-1.6, ACDD 1.3
    Metadata_Conventions:       CF-1.6, Unidata Dataset Discovery v1.0, NOAA ...
    acknowledgment:             This project was supported in part by a grant...
    cdm_data_type:              Grid
    cdr_program:                NOAA Climate Data Record Program for satellit...
    cdr_variable:               precipitation
    ...                         ...
    standard_name_vocabulary:   CF Standard Name Table (v41, 22 February 2017)
    summary:                    Global Precipitation Climatology Project (GPC...
    time_coverage_duration:     P1D
    time_coverage_end:          1996-10-01T23:59:59Z
    time_coverage_start:        1996-10-01T00:00:00Z
    title:                      Global Precipitation Climatatology Project (G...
```


### Comment by mdsumner, 2022-09-09

recipe with standard apt gdal

```bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt upgrade

sudo apt install g++ libxml2-dev libcurl4-openssl-dev libproj-dev cmake autoconf libtool pkg-config make libsqlite3-dev sqlite3 libnetcdf-dev libmagick++-dev libarchive-dev  proj-bin libnode-dev libxml2-dev libcurl4-openssl-dev libproj-dev  libgeos-dev  libssl-dev libudunits2-dev libprotobuf-dev protobuf-compiler imagemagick python3-dev libhdf4-dev libhdf5-dev libgdal-dev


wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

sudo python3 -m pip install numpy packaging pandas zarr netCDF4 rasterio bottleneck
sudo python3 -m pip install "dask[complete]"
sudo python3 -m pip install xarray geopandas sparse aiohttp requests matplotlib
sudo python3 -m pip install jupyter

## R
sudo apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base

sudo apt install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.1-554-amd64.deb
sudo gdebi rstudio-server-2022.07.1-554-amd64.deb

sudo apt install build-essential gfortran

Rscript -e 'remotes::install_cran("RcppEigen")'

## put makeflags and cloud.r-project.org in .Renviron 
Rscript -e 'remotes::install_cran(c("angstroms", "anglr", "backports",   "base64enc", "BiocManager", "bitops",   "caTools", "crayon", "devtools", "evaluate", "formatR", "geojsonio",   "ggforce", "ggraph", "graticule", "highr", "htmltools", "htmlwidgets",   "httpuv", "knitr", "leaflet", "magick", "mapview", "markdown",   "ncdf4", "praise", "proj4", "PROJ", "reproj", "quadmesh", "raster", "rbgm", "rgdal",   "rgeos", "rgl", "rmarkdown", "RNetCDF", "rprojroot", "rworldmap",   "sf", "sfdct", "shiny", "sourcetools", "spbabel", "spdplyr",   "spex", "tabularaster", "testthat", "tibble", "tidync", "tidyverse", "traipse", "vapour",   "xtable", "yaml", "decido", "RTriangle", "silicate", "ceramic", "crsmeta", "unjoin", "lazyraster", "geodist", "sfheaders", "mapdeck",  "trip", "traipse", "bsam", "geos", "wk", "reticulate"))'
```


## #13 ODC 

*open, opened 2023-03-21 by mdsumner* — https://github.com/mdsumner/nectar/issues/13

working on cube-in-a-box for the JupyterHub docker

- modifed .requirements.txt to add 'dask'
- working with port 8888:8888 in docker-compose.yaml, 8888 and 5432 added to my nectar security groups (and then found here https://github.com/opendatacube/cube-in-a-box/issues/46)
- set numpy==1.20


that worked a lot further, but failed on stac stuff - trying with no version components. ...
omg

 Bounding box must be within (-180, -90, 180, 90) (type=value_error)
make: *** [Makefile:34: index] Error 1
ubuntu@odc:~/Git/cube-in-a-box$ sudo  make setup BBOX=-46,140,-30,148

now using

```
sudo  make setup BBOX=140,-46,148,-30
```


Seen during python resolution: 

```
ERROR: botocore 1.15.32 has requirement urllib3<1.26,>=1.20; python_version != "3.4", but you'll have urllib3 1.26.15 which is incompatible.
ERROR: awscli 1.18.32 has requirement PyYAML<5.4,>=3.10; python_version != "3.4", but you'll have pyyaml 6.0 which is incompatible.
ERROR: distributed 2023.3.1 has requirement click>=8.0, but you'll have click 7.1.2 which is incompatible.
ERROR: scipy 1.10.1 has requirement numpy<1.27.0,>=1.19.5, but you'll have numpy 1.18.5 which is incompatible.
ERROR: scikit-image 0.20.0 has requirement numpy>=1.21.1, but you'll have numpy 1.18.5 which is incompatible.
ERROR: scikit-image 0.20.0 has requirement scipy<1.9.2,>=1.8; python_version <= "3.9", but you'll have scipy 1.10.1 which is incompatible.
ERROR: pims 0.6.1 has requirement numpy>=1.19, but you'll have numpy 1.18.5 which is incompatible.
ERROR: jupyter-client 8.1.0 has requirement python-dateutil>=2.8.2, but you'll have python-dateutil 2.7.5 which is incompatible.
ERROR: ipyleaflet 0.14.0 has requirement ipywidgets<8,>=7.6.0, but you'll have ipywidgets 8.0.4 which is incompatible.
ERROR: fiona 1.9.2 has requirement click~=8.0, but you'll have click 7.1.2 which is incompatible.
```

### Comment by mdsumner, 2023-08-04

forget about cube in a box 

```
sudo apt install docker.io docker-compose

## probably need to restart after this
sudo usermod -aG docker ubuntu

git clone https://github.com/GeoscienceAustralia/dea-sandbox
cd dea-sandbox
docker-compose up

## need your server IP (or reverse proxy thing) and the lab token that the run tells you
#http://<IP>:9988/lab?token=<token>

## also need that port on nectar



#docker pull geoscienceaustralia/sandbox
#docker run --rm -ti -p 9988:9988 geoscienceaustralia/sandbox

```

### Comment by mdsumner, 2023-08-04

scratch that, CIAB is back baaby

https://github.com/mdsumner/cube-in-a-box




### Comment by mdsumner, 2023-08-04

almost there, just getting this now

---------------------------------------------------------------------------
ModuleNotFoundError                       Traceback (most recent call last)
Cell In[1], line 7
      4 import matplotlib.pyplot as plt
      6 import datacube
----> 7 import odc.stac
      8 import odc.geo.xr
      9 from odc.geo.geom import BoundingBox

File /usr/local/lib/python3.10/dist-packages/odc/stac/__init__.py:5
      1 """
      2 STAC Item -> ODC Dataset[eo3]
      3 """
----> 5 from ._eo3 import (
      6     BandMetadata,
      7     ConversionConfig,
      8     stac2ds,
      9 )
     12 __all__ = (
     13     "BandMetadata",
     14     "ConversionConfig",
     15     "stac2ds",
     16 )

File /usr/local/lib/python3.10/dist-packages/odc/stac/_eo3.py:17
     15 from pystac.extensions.projection import ProjectionExtension
     16 from datacube.index.eo3 import prep_eo3
---> 17 from datacube.index.index import default_metadata_type_docs
     18 from datacube.model import Dataset, DatasetType, metadata_from_doc
     19 from datacube.utils.geometry import GeoBox

ModuleNotFoundError: No module named 'datacube.index.index'

good enough to revisit later


## #14 openstack DNS/https

*open, opened 2023-04-13 by mdsumner* — https://github.com/mdsumner/nectar/issues/14

I did this from the actual server itself, my old notes were a bit over the top because I had no idea what was happening. 

I had a problem with python ... so I followed the instructions with a dummy user to create an env and do it all in there, but unsure that was necessary. On ace-eco-stats itself, which is where I first did the originals I had some python3.8 vs python3.11 issue. 


You need to add port 80, and remove port 8787 :)


```
pip install python-openstackclient python-designateclient
```

I don't understand the python openstack vs. the apt one, but what works is use mdsumner2 (on gdalserver) as the dummy, then do

```
cd ~/nectar_openstack
source venv/bin/activate
```

then run the openstack recordset stuff as below, mentioned here

https://support.ehelp.edu.au/support/solutions/articles/6000075747-api

and described for python here

https://docs.python-guide.org/dev/virtualenvs/

then do  (note the period at end of address)

```
openstack recordset create <project>.cloud.edu.au. <instance name> --type A --record <instance IP addr>

```

check with (note the final period)

```
openstack recordset list ace-eco-stats.cloud.edu.au.

```

note that the old example uses vm-<address>.rc.tasmania.nectar.org.au, but we just want <servername>.<project>.cloud.edu.au

```
apt install nginx
## edit the nginx stuff
sudo /etc/init.d/nginx restart
```

### Comment by mdsumner, 2023-04-13

and then 

```
sudo apt install python3-certbot-nginx
 sudo certbot --nginx -d <the servername.project.cloud.edu.au> 
```

### Comment by mdsumner, 2023-07-25

I had to edit to use 3.8 ...


```
cat /usr/bin/certbot
#!/usr/bin/python3.8
...
```

### Comment by mdsumner, 2025-05-30

working on the new pred lab

```
apt update
apt install python3 
apt install python3-pip python-venv


python3 -m venv myvenv
. myvenv/bin/activate

pip install python-openstackclient python-designateclient


source the_RCfile.sh

##  openstack zone list ## to give the zone e.g. zone.cloud.edu.au
##  openstack recordset list zone.cloud.edu.au.  ## 
## openstack server list  ## give the servernames
## to create the DNS record:
openstack recordset create --type A --record  <ip>  <project>.cloud.edu.au. servername
```

edit `/etc/nginx/nginx.conf` look here: https://github.com/AustralianAntarcticDivision/IDEA/issues/27#issuecomment-1823689226





