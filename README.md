nectar
======


# Introduction


This page describes use of Nectar for beginners. Nectar is the cloud computing resource. 

> NeCTAR is a scientific "cloud-compute" resource, The National eResearch 
> Collaboration Tools and Resources (NeCTAR) Project  

https://nectar.org.au/about-nectar

Official guides and how-to here: ttps://support.nectar.org.au/support/solutions

# Summary

We will

1. What is the cloud? What is it used for? 
2. Log in to Nectar and launch a VM (virtual computer)
3. Log in to the VM
4. Use the VM


# 1. What is the cloud? What is it used for? 

It's just computers - computers that aren't physically on your desk, but also computers that you "create" for your own use. 

* Linux shell
* RStudio
* Matlab
* Python
* etc. 

*The hard thing*

Access is less direct than with a computer on your desk. 

*The great thing*

**A.** can create a very powerful computer with all dependencies need, and then make a copy of it, "snapshot it" and use it again, share with others. 

**B.** It's also possible to create a "recipe script" to take a clean computer and install everything on it that you need automatically. 

These two cases have pros and cons, but are not mutually exclusive. 

# 2. Log in to Nectar and launch a VM (virtual computer)

* need AAF account (e.g. a UTAS account)
* create Security Rules for the VM
* create a keypair for admin login
* create the computer!

## 3. Log in to the VM

* need an SSH client (*Windows needs extra installation*)
* create a normal user (don't always be the Administrator)

## 4. Use the VM

* transfer files (to and from the VM)
* install applications (as the Administrator)
* run the applications (as a user)


Summary of the process 
The crucial parts with Nectar are ensuring you have
a Nectar account
Security Rules for the right ports
a keypair set up for the initial admin login 
a Nectar allocation to launch the RStudio server against
somewhere to log into the virtual machine from (e.g. via SSH with MobaXTerm on Windows)
a tiny bit of Linux-fu to create a normal user
Nectar account
Many Australian universities provide access via pre-existing email account logins.  Go to the dashboard login, find your institution, e.g. UTas and follow the trail into the dashboard.  

Log in here: https://dashboard.rc.nectar.org.au/auth/login/?next=/project/
Next we will set up Security Rules, a keypair for secure access, and the actual launching. 
Security Rules
Go to Access and Security, and the Security Groups tab.
You may need the following ports open:
22   SSH  - this is needed for us to log in as admin to create users on the server
8787  RStudio Server - this allows users to log into the RStudio interface
Once you have Security Group/s defined you can apply them to an instance that you launch, either at launch or after the fact.

Key pair

Create one under the "Keypairs" tab under Access and Security. Save the resulting .pem file somewhere you can use it to SSH in (see Log in below). 

Note: the default admin user on this Ubuntu machine is "ubuntu", you'll use this name with the keypair to log in to the machine for creating normal users. 
Launch a server
Launching goes like this, with details relevant for 2014-05-28: 

find the most recent version of Ubuntu, currently 14.04 under "Images and Snapshots", make sure "Nectar official" tab is active, choose "NeCTAR Ubuntu 14.04 (Trusty) amd64", click Launch
set your Flavor (server grunt within limits of your allocation)
give it an “Instance Name”  
under Access & Security tab specify the keypair you will use (THIS IS REQUIRED BEFORE LAUNCHING)
also make sure the Security groups are applied – so you have all those ports for HTTP, SSH, HTTPS, RStudio Server and Shiny as required for your needs (See images of my rules above. )
under Availability Zone optionally choose a location
under "Customization", enter the script text (see below)
click “Launch” - once this is fired up you can get the IP address, which we use next
Script text
See here, enter the entire contents of r-spatial.sh into the Customization text field: 
https://github.com/mdsumner/nectar/blob/master/r-spatial.sh

You do need to run the gdebi install for the RStudio as sudo, and should do it interactively. 

Log in
Option 1)
Log in using SSH on Windows like this (I recommend using MobaXTerm)  http://mobaxterm.mobatek.net/
     (putty also works but isn't as "nice". )
in MobaXTerm create an SSH session
input your ip address "Remote Host", and "username"  ubuntu (note that it's using port 22 as per our SSH rule for Security Groups above)
configure it to use your keypair.pem file
configure any other settings relevant to your situation

Option 2)
If you don't know what this is go to Option 1: 
ssh ubuntu@[ip.number] -i [thekey].pem

Create a normal user, with a username/password
then create a normal Linux user with e.g. sudo adduser normalusername and follow the prompts. 
That normalusername should now be able to log in to the RStudio Server instance at http://ipaddress:8787 and also in the usual ways to the server. 







