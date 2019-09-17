FROM osgeo/gdal:ubuntu-full-latest

MAINTAINER "mdsumner" mdsumner@gmail.com

RUN apt-get update && apt-get install -y software-properties-common

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/  " >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN apt-get update
RUN apt-get upgrade -y

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y \
	gdb \
	git \
	libcairo2-dev \
	libcurl4-openssl-dev \
	libexpat1-dev \
	libpq-dev \
	libsqlite3-dev \
	libudunits2-dev \
	make \
	pandoc \
	qpdf \
	r-base-dev \
  	sqlite3 \
	subversion \
	valgrind \
	vim \
	wget

RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_cran(c("Rcpp", "knitr", "covr", "dplyr", "geojsonsf", "testthat", "rbenchmark", "rmarkdown", "spelling"))'

RUN git clone --depth 10 https://github.com/hypertidy/vapour.git
#RUN git config --global user.email "mdsumner@gmail.com"

RUN R CMD build --no-build-vignettes --no-manual vapour
RUN R CMD INSTALL vapour

CMD ["/bin/bash"]
