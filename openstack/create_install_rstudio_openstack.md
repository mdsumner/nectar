## create/install/secure and RStudio server in nectar


Hi Mike,

Below are all the notes that I took from our create/install/secure and RStudio instance in Nectar effort this morning.

 

Headline items are:

- Using your openstack command line tools and your ACE_eco_stats RC file and you openstack password

- create an instance

- Install r + rstudio on instance

- (we’ll use the Tasmania instance default DNS for nginx and certbot)

- Install nginx and configure for reverse proxy to rstudio server

- Install letsencrypt certbot and let it do the magic of requesting and installing an ssl certificate and adjusting your nginx config (https://letsencrypt.org/)

 

Now that we have done the best we can to ensure that our RStudio server doesn’t leak our users’ passwords:

- Users should be instructed to log onto their account, and change their password to something strong (i.e. long, unique, managed: https://support.ehelp.edu.au/support/solutions/articles/6000213823-passwords)

 
## admin side
 
apt-get install python-openstackclient

 


os server create --flavor m3.small --image 'NeCTAR Ubuntu 18.04 LTS (Bionic) amd64' --nic net-id='Classic Provider' --security-group ssh --key-name aServiceKey --availability-zone tasmania acme

 


## client server

using for this example the following DNS name vm-144-6-226-131.rc.tasmania.nectar.org.au

 

sudo su

apt update

apt upgrade

apt install gdebi-core


wget https://s3.amazonaws.com/rstudio-ide-build/desktop/xenial/amd64/rstudio-1.2.1240-amd64.deb

gdebi rstudio-1.2.1240-amd64.deb -n

 

 

echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' >> /etc/apt/sources.list

 

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes

 

sudo apt install vim r-base r-base-dev --assume-yes

apt install nginx

#refusing to connect

 

#re-install RStudio

gdebi rstudio-server-1.2.1193-amd64.deb -n

 

#connects! Assume the order of installation matters: r-base before rstudio

 

 

#create DNS entry

#fudging by using Tasmania default

vm-144-6-226-131.rc.tasmania.nectar.org.au

 

#reversre proxy (nginx infront of rstudio server)

#nginx will listen to pt80 and forward to pt 8787

#instr here: procy setting acording to https://support.rstudio.com/hc/en-us/articles/200552326-Running-RStudio-Server-with-a-Proxy

+ amendmendts by Just

 

repleace the http { } section from /etc/nginx/nginx.conf with this (note the servername and .welknown location need tobe named for your server)

http {

 

  map $http_upgrade $connection_upgrade {

      default upgrade;

      ''      close;

    }

 

    client_max_body_size 50M;

 

  server {

    listen 80;

 

    location / {

      proxy_pass http://localhost:8787;

      proxy_redirect http://localhost:8787/ $scheme://$http_host/;

      proxy_http_version 1.1;

      proxy_set_header Upgrade $http_upgrade;

      proxy_set_header Connection $connection_upgrade;

      proxy_read_timeout 20d;

    }

    location /.well-known {

            alias /var/www/vm-144-6-226-131.rc.tasmania.nectar.org.au/.well-known;

    }

 

    server_name vm-144-6-226-131.rc.tasmania.nectar.org.au;

  }

}

sudo /etc/init.d/nginx restart

 

#sever now responds to pt 80, can remove access to pt 8787:

os server remove security group acme RStudioServer

 

#using certbot to get cert and let it fix nginx config:

apt install python-certbot-nginx

certbot --nginx -d vm-144-6-226-131.rc.tasmania.nectar.org.au

 

root@acme:/home/ubuntu# certbot --nginx -d vm-144-6-226-131.rc.tasmania.nectar.org.au

Saving debug log to /var/log/letsencrypt/letsencrypt.log

Plugins selected: Authenticator nginx, Installer nginx

Enter email address (used for urgent renewal and security notices) (Enter 'c' to

cancel): 

 

-------------------------------------------------------------------------------

Please read the Terms of Service at

https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must

agree in order to register with the ACME server at

https://acme-v01.api.letsencrypt.org/directory

-------------------------------------------------------------------------------

(A)gree/(C)ancel: A

 

-------------------------------------------------------------------------------

Would you be willing to share your email address with the Electronic Frontier

Foundation, a founding partner of the Let's Encrypt project and the non-profit

organization that develops Certbot? We'd like to send you email about EFF and

our work to encrypt the web, protect its users and defend digital rights.

-------------------------------------------------------------------------------

(Y)es/(N)o: Y

Obtaining a new certificate

Performing the following challenges:

http-01 challenge for vm-144-6-226-131.rc.tasmania.nectar.org.au

Waiting for verification...

Cleaning up challenges

Deploying Certificate to VirtualHost /etc/nginx/nginx.conf

 

Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.

-------------------------------------------------------------------------------

1: No redirect - Make no further changes to the webserver configuration.

2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for

new sites, or if you're confident your site works on HTTPS. You can undo this

change by editing your web server's configuration.

-------------------------------------------------------------------------------

Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 2

Redirecting all traffic on port 80 to ssl in /etc/nginx/nginx.conf

 

-------------------------------------------------------------------------------

Congratulations! You have successfully enabled

https://vm-144-6-226-131.rc.tasmania.nectar.org.au

 

You should test your configuration at:

https://www.ssllabs.com/ssltest/analyze.html?d=vm-144-6-226-131.rc.tasmania.nectar.org.au

-------------------------------------------------------------------------------

 

IMPORTANT NOTES:

- Congratulations! Your certificate and chain have been saved at:

   /etc/letsencrypt/live/vm-144-6-226-131.rc.tasmania.nectar.org.au/fullchain.pem

   Your key file has been saved at:

   /etc/letsencrypt/live/vm-144-6-226-131.rc.tasmania.nectar.org.au/privkey.pem

   Your cert will expire on 2019-04-11. To obtain a new or tweaked

   version of this certificate in the future, simply run certbot again

   with the "certonly" option. To non-interactively renew *all* of

   your certificates, run "certbot renew"

- Your account credentials have been saved in your Certbot

   configuration directory at /etc/letsencrypt. You should make a

   secure backup of this folder now. This configuration directory will

   also contain certificates and private keys obtained by Certbot so

   making regular backups of this folder is ideal.

- If you like Certbot, please consider supporting our work by:

 

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate

  Donating to EFF:                    https://eff.org/donate-le

 

- We were unable to subscribe you the EFF mailing list because your

   e-mail address appears to be invalid. You can try again later by

   visiting https://act.eff.org.

  

   

 

 

 

-------------------------------------------------------------

#acme2, condensing the instructions (fingers crossed)


new/changed user creds can be sent via email, and/or known by you as an admin, provided the user changes it immediately

username = michael

password = zaq1xsw2

 

logon and immediately go to Tools | Shell and change your password using the command `passwd` to a strong password

sign out and sign back in (to trigger password manager, password update)

 

 

 

 

 

