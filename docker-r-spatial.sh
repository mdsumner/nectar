## debian

apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
 
echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list


apt-get update
apt-get upgrade --assume-yes
apt-get install docker-engine
service docker start

sudo docker run -d -p 8787:8787 rocker/hadleyverse

