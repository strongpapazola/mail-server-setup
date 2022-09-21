# mail-server-setup
Run Setup For All

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
```


lunak.id.	1	IN	TXT	"v=spf1 a mx ip4:203.194.113.155 include:_spf.google.com ~all"
