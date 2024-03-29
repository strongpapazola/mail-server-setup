# SETUP MAIL SERVER CAN SEND TO GMAIL WITH OPENDKIM
The requirement for us to be able to send email messages safely is to setup DKIM and SPF

# RESEARCH SUCCESS SENDING EMAIL
you can install docker and pull the image
```
docker pull strongpapazola/mail_server:v1
```
and
```
docker run -it --rm -p 25:25 strongpapazola/mail_server:v1 bash
```
then you can inspect file config
```
#FILE CONFIGURED
/etc/hosts
/etc/hostname
/etc/postfix/main.cf
/etc/opendkim.conf
/etc/default/opendkim

sudo mkdir -p /etc/opendkim
sudo mkdir -p /etc/opendkim/keys

/etc/postfix/sasl/sasl_passwd

/etc/opendkim/TrustedHosts
/etc/opendkim/KeyTable
/etc/opendkim/SigningTable

mkdir /etc/opendkim/keys/$DOMAIN
```

# DNS Setting (Important)

```
;;
;; Domain:     lunak.id.
;; Exported:   2022-09-21 10:35:34
;;
;; This file is intended for use for informational and archival
;; purposes ONLY and MUST be edited before use on a production
;; DNS server.  In particular, you must:
;;   -- update the SOA record with the correct authoritative name server
;;   -- update the SOA record with the contact e-mail address information
;;   -- update the NS record(s) with the authoritative name servers for this domain.
;;
;; For further information, please consult the BIND documentation
;; located on the following website:
;;
;; http://www.isc.org/
;;
;; And RFC 1035:
;;
;; http://www.ietf.org/rfc/rfc1035.txt
;;
;; Please note that we do NOT offer technical support for any use
;; of this zone data, the BIND name server, or any other third-party
;; DNS software.
;;
;; Use at your own risk.
;; SOA Record
lunak.id	3600	IN	SOA	lunak.id root.lunak.id 2041542313 7200 3600 86400 3600

;; A Records
lunak.id.	1	IN	A	203.194.113.155
mail.lunak.id.	1	IN	A	203.194.113.155

;; CNAME Records
www.lunak.id.	1	IN	CNAME	lunak.id.

;; MX Records
lunak.id.	1	IN	MX	10 mail.lunak.id.

;; TXT Records
_dmarc.lunak.id.	1	IN	TXT	"v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"
key001._domainkey.lunak.id.	1	IN	TXT	"v=DKIM1;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtFkgBWv+21C2ApCjKuwJuorO0M7Pi3ZzK1p7jMzFw2UsJz/ULHs2igQa5HNEmlLohAxAN6/nVtdzb/+qyNUmNKW6sqgns2HqDPzNI5OTLqEbc4XLALeZ3IClTEmBzGRkrtrwf9i09H/XZZLH7xef3wHGERXrZaJJ7VIX/Zbdh0/JjWSy3bXPAbCt5QBLghtW5Iowniy3v+HMOGXRwG+rxVPjI54qzREXrbBEjY2sWKvu12qxCg/dfMBgkyxjYYhJiFUgHk1YBFtbyVLTT1aGNtZKfkmWXM4KipjPNs69lBZVQ7K4IVMKNbi2L7uN6cqVJqLzGMBdU6uNQm9QazjeuwIDAQAB"

lunak.id.	1	IN	TXT	"v=spf1 a mx ip4:203.194.113.155 include:_spf.google.com ~all"
```

# Test Mail Server Using Telnet
```
telnet mail.lunak.id 25

ehlo mail.lunak.id
mail from: root@lunak.id
rcpt to: strongpapazola@gmail.com
data
Subject: Dependabots from root gaming
halo
.

mail from: root@lunak.id
rcpt to: info@lunak.id
data
Subject: Dependabots from root gaming
halo
.
```


