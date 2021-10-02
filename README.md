# Automated bind DNS

## Docker Parameter 

Getting started

`IP`: server dns ip

`CIDR`: ip address range

`DNS_BASE`: dns server name base

`DNS[:N]`: subdomain dns server bound definition, where N is an incremental number of subdomain

`ETC`: default '/etc' etc path

`BIND_DIR`: default '/etc/bind' bind path

## FIX: 1.0.1

* MOVE RESOLV TO EXTRA_HOST
* MAKE SURE AVAILABILITY OF BIND AND NGINX