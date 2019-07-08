# Murano apps on Nectar

Means we don't need the full stack of details to create

* RStudio Server on SSL / https with a persistent address (? 1)
* users are on a volume, in the same node as the deployment
* we'd SSH in as admin, add the R and sys updates for the usual stuff
* SSH in to add raadtools

# Qs

*(1) assume if we create a new server we simply use the old name 
* does nominated user get created in the volume? 

# Gotchas

* create volume in local node, deploy server that node

# Steps

* go to App Catalog->Browse->Browse_Local
* search RStudio (only one there)
* deploy (takes ages in Tas, need key, user, volume, name, dns)



