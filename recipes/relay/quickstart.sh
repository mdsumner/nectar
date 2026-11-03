#!/bin/bash
# Paste into the dashboard's Customization Script box. Put your relay's name in FQDN: it must be a DNS record you can
# create (a Nectar DNS zone gives you <name>.<project>.cloud.edu.au), and the security group must open 80 and 443.
curl -fsSL https://raw.githubusercontent.com/mdsumner/nectar/main/recipes/relay/bootstrap.sh | FQDN=relay.myproject.cloud.edu.au bash
