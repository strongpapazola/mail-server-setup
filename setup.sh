#!/bin/bash
read -p 'Enter RootDomain [example.com] : ' DOMAIN
read -p 'Enter Selector [key001] : ' SELECTOR
apt update
#apt-get install postfix courier-imap courier-pop opendkim opendkim-tools mailutils certbot letsencrypt -y
apt-get install postfix courier-imap courier-pop opendkim opendkim-tools mailutils -y
#certbot certonly -d $DOMAIN --standalone
sed -i "s/127.0.1.1/127.0.1.1 $DOMAIN/g" /etc/hosts
echo "$DOMAIN" > /etc/hostname
hostname $DOMAIN

if [ `grep -iRl "default" /etc/postfix/main.cf` ];then
cp /etc/postfix/main.cf /etc/postfix/main.cf.bak
fi

echo 'smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)' > /etc/postfix/main.cf
echo 'biff = no' >> /etc/postfix/main.cf
echo 'append_dot_mydomain = no' >> /etc/postfix/main.cf
echo 'readme_directory = no' >> /etc/postfix/main.cf
#--- CHANGED VALUE ---#
#echo "smtpd_tls_cert_file=/etc/letsencrypt/live/$DOMAIN/fullchain.pem" >> /etc/postfix/main.cf #CHANGE VARIABLE
#echo "smtpd_tls_key_file=/etc/letsencrypt/live/$DOMAIN/privkey.pem" >> /etc/postfix/main.cf #CHANGE VARIABLE
echo "smtpd_tls_cert_file=smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/postfix/main.cf #CHANGE VARIABLE
echo "smtpd_tls_key_file=smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/postfix/main.cf #CHANGE VARIABLE
#--- CHANGED VALUE ---#
echo 'smtpd_use_tls=yes' >> /etc/postfix/main.cf
echo 'smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache' >> /etc/postfix/main.cf
echo 'smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache' >> /etc/postfix/main.cf
echo 'smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination' >> /etc/postfix/main.cf
echo "myhostname = $DOMAIN" >> /etc/postfix/main.cf #CHANGE VARIABLE
echo 'alias_maps = hash:/etc/aliases' >> /etc/postfix/main.cf
echo 'alias_database = hash:/etc/aliases' >> /etc/postfix/main.cf
echo 'myorigin = /etc/mailname' >> /etc/postfix/main.cf
echo "mydestination = $myhostname, $DOMAIN, localhost" >> /etc/postfix/main.cf #CHANGE VARIABLE
echo 'relayhost =' >> /etc/postfix/main.cf
echo 'mynetworks = 0.0.0.0/0 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128' >> /etc/postfix/main.cf
echo 'mailbox_size_limit = 0' >> /etc/postfix/main.cf
echo 'recipient_delimiter = +' >> /etc/postfix/main.cf
echo 'inet_interfaces = all' >> /etc/postfix/main.cf
echo 'inet_protocols = all' >> /etc/postfix/main.cf
#--- CHANGED VALUE ---#
echo 'home_mailbox = Maildir/' >> /etc/postfix/main.cf
echo 'smtp_sasl_auth_enable = yes' >> /etc/postfix/main.cf
echo 'smtp_sasl_security_options = noanonymous' >> /etc/postfix/main.cf
echo 'smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd' >> /etc/postfix/main.cf
echo 'smtp_tls_security_level = encrypt' >> /etc/postfix/main.cf
echo 'smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt' >> /etc/postfix/main.cf
echo 'milter_protocol = 2' >> /etc/postfix/main.cf
echo 'milter_default_action = accept' >> /etc/postfix/main.cf
echo 'smtpd_milters = inet:localhost:12301' >> /etc/postfix/main.cf
echo 'non_smtpd_milters = inet:localhost:12301' >> /etc/postfix/main.cf

#--- CHANGED VALUE ---#
maildirmake.courier /etc/skel/Maildir

echo "AutoRestart             Yes" >> /etc/opendkim.conf
echo "AutoRestartRate         10/1h" >> /etc/opendkim.conf
echo "UMask                   002" >> /etc/opendkim.conf
echo "Syslog                  yes" >> /etc/opendkim.conf
echo "SyslogSuccess           Yes" >> /etc/opendkim.conf
echo "LogWhy                  Yes" >> /etc/opendkim.conf
echo "Canonicalization        relaxed/simple" >> /etc/opendkim.conf
echo "ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts" >> /etc/opendkim.conf
echo "InternalHosts           refile:/etc/opendkim/TrustedHosts" >> /etc/opendkim.conf
echo "KeyTable                refile:/etc/opendkim/KeyTable" >> /etc/opendkim.conf
echo "SigningTable            refile:/etc/opendkim/SigningTable" >> /etc/opendkim.conf
echo "Mode                    sv" >> /etc/opendkim.conf
echo "PidFile                 /var/run/opendkim/opendkim.pid" >> /etc/opendkim.conf
echo "SignatureAlgorithm      rsa-sha256" >> /etc/opendkim.conf
echo "UserID                  opendkim:opendkim" >> /etc/opendkim.conf
echo "Socket                  inet:12301@localhost" >> /etc/opendkim.conf

#sed -i 's/SOCKET="local:/var/run/opendkim/opendkim.sock"/#SOCKET="local:/var/run/opendkim/opendkim.sock"/g' /etc/default/opendkim
echo 'SOCKET="inet:12301@localhost"' > /etc/default/opendkim #REPLACE INSTEAD

sudo mkdir -p /etc/opendkim
sudo mkdir -p /etc/opendkim/keys

echo "$DOMAIN info:1nf0" > /etc/postfix/sasl/sasl_passwd
postmap /etc/postfix/sasl/sasl_passwd

echo "127.0.0.1" > /etc/opendkim/TrustedHosts
echo "localhost" >> /etc/opendkim/TrustedHosts
echo "*.$DOMAIN" >> /etc/opendkim/TrustedHosts
echo "$SELECTOR._domainkey.$DOMAIN $DOMAIN:$SELECTOR:/etc/opendkim/keys/$DOMAIN/$SELECTOR.private" > /etc/opendkim/KeyTable

echo "*@$DOMAIN $SELECTOR._domainkey.$DOMAIN" > /etc/opendkim/SigningTable

mkdir /etc/opendkim/keys/$DOMAIN
pushd /etc/opendkim/keys/$DOMAIN
opendkim-genkey -b 1024 -s $SELECTOR -d $DOMAIN
chown opendkim:opendkim *.private
cat $SELECTOR.txt

service opendkim restart
service postfix restart
service courier-imap restart
service courier-pop restart


