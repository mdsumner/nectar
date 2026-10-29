http://www.win-vector.com/blog/2016/02/databases-in-containers/

https://hub.docker.com/r/mdillon/postgis/
```bash
apt-get update
apt-get install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list

apt-get update
#Purge the old repo if it exists.
apt-get purge lxc-docker
#Verify that APT is pulling from the right repository.
apt-cache policy docker-engine

apt-get update
#Install the recommended packages.
apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

apt-get install docker-engine
#Start the docker daemon.
service docker start
#Verify docker is installed correctly.
#sudo docker run hello-world

## PostGIS

docker run -p 5432:5432 --name pg_raad -e POSTGRES_PASSWORD=pg_raad -d mdillon/postgis

```

DB access. 

```bash
## direct access: 
docker run -it --link pg_raad:postgres --rm postgres \
    sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
 
 ```
 
```R
## install.packages("RPostgreSQL")
library(dplyr)
db <- src_postgres(dbname = "template1", host = <addy_boomboom>, port = "5432", user = <useyboombam>, password = <passywok>)

ii <-  copy_to(db, iris, name = deparse(substitute(df)))
ii
```

```
Source:   query [?? x 5]
Database: postgres 9.5.4 [postgres@115.146.90.12:5432/template1]

   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
          <dbl>       <dbl>        <dbl>       <dbl>   <chr>
1           5.1         3.5          1.4         0.2  setosa
2           4.9         3.0          1.4         0.2  setosa
3           4.7         3.2          1.3         0.2  setosa
```
