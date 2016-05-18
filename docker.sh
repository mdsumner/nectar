## debian
uname -r
# 3.16.0-4-amd64

apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
 
echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list

apt-get update


sudo apt-get update
sudo apt-get install docker-engine
sudo service docker start

sudo docker run hello-world

sudo docker run -d -p 8787:8787 rocker/rstudio

sudo docker run geodata/gdal

sudo groupadd docker

# Add the connected user "${USER}" to the docker group.
# Change the user name to match your preferred user.
# You may have to logout and log back in again for
# this to take effect.
sudo gpasswd -a username docker

# Restart the Docker daemon.
sudo service docker restart
