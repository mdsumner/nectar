
sudo apt update
sudo apt upgrade

sudo apt -y install gnupg2
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

sudo apt install postgis postgresql 

sudo -i -u postgres

createuser postgis_test
createdb postgis_db -O postgis_test


psql -d postgis_db

CREATE EXTENSION postgis;
