## https://github.com/JamesRamm/MapThing/blob/master/README.md
  sudo apt-get update
  sudo apt-get upgrade
  
  sudo apt-get install npm
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  sudo apt-get install -y nodejs
  udo apt-get install build-essential clang libdbus-1-dev libgtk2.0-dev                        libnotify-dev libgnome-keyring-dev libgconf2-dev                        libasound2-dev libcap-dev libcups2-dev libxtst-dev                        libxss1 libnss3-dev gcc-multilib g++-multilib curl                        gperf bison
  git clone https://github.com/electron/electron.git
  cd electron/
  ./script/bootstrap.py -v
  ./script/create-dist.py
  cd ..
  git clone https://github.com/JamesRamm/MapThing.git
  cd MapThing/
  npm install
  npm run templates
  ../electron/out/D/electron .
  
