wget -qO- https://get.docker.com/ | sh
## sudo adduser mdsumner
sudo usermod -aG docker mdsumner
sudo usermod -aG docker ubuntu

docker pull postgres
docker pull rocker/hadleyverse

sudo docker run -d -p 8787:8787 rocker/hadleyverse

docker run --name ocdb -e POSTGRES_PASSWORD=T4llH0ps -d postgres
sudo docker run -d -p 8787:8787 -P --name rstd --link ocdb:ocdb rocker/hadleyverse
