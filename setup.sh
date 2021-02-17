#!/bin/bash
read -p 'Enter SubDomain [mail.example.com] : ' SUBDOMAIN
read -p 'Enter RootDomain [example.com] : ' DOMAIN
apt-get -o "DPkg::Options::=--force-confdef" install postfix courier-imap courier-pop squirrelmail opendkim opendkim-tools mailutils certbot letsencrypt -y
certbot certonly -d $DOMAIN --standalone


