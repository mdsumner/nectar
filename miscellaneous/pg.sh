
sudo apt update
sudo apt upgrade

sudo apt -y install gnupg2
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -


sudo apt install postgis postgresql-13-postgis-3

sudo -i -u postgres

createuser postgis_test
createdb postgis_db -O postgis_test


psql -d postgis_db

sudo apt update
CREATE EXTENSION postgis;
