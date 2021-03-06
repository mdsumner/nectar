wget -qO- https://get.docker.com/ | sh
## sudo adduser mdsumner
sudo usermod -aG docker mdsumner
sudo usermod -aG docker ubuntu

docker pull postgres
docker pull rocker/hadleyverse

sudo docker run -d -p 8787:8787 rocker/hadleyverse
docker run --name ocdb -e POSTGRES_PASSWORD=secret -d postgres
docker run -it --link ocdb:postgres --rm postgres sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
##docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
sudo docker run -d -p 8787:8787 -P --name rstd --link ocdb:ocdb rocker/hadleyverse
