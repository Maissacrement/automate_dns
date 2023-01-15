# Automated bind DNS

## Intro

Once the conteur is launched you can propagate the dns on your machine by modifying the path /etc/resolv.conf 

In order to make the dns identifiable you will need to mention the ip address of the dns server via the nameserver entry

nameserver `dnsip`

## Docker Parameter 

Getting started

`IP`: server dns ip

`CIDR`: ip address range

`DNS_BASE`: dns server name base

`DNS[:N]`: subdomain dns server bound definition, where N is an incremental number of subdomain

`ETC`: default '/etc' etc path

`BIND_DIR`: default '/etc/bind' bind path

## Example

```yaml
version: '3.9'
services:
  server0:
    image: robertshand/python-hello-world
    networks:
      dnsserver:
        ipv4_address: 172.100.30.10 # hello world static ip

  server1:
    image: robertshand/python-hello-world
    networks:
      dnsserver:
        ipv4_address: 172.100.30.58 # hello world static ip

  dns:
    image: registry.gitlab.com/maissacrement/dns:latest
    domainname: myst.yana
    network_mode: host
    hostname: dns
    ipc: host
    privileged: true
    environment:
      IP: '172.100.30.1' # ip of dns server
      CIDR: '172.100.30.0/24' # ip address auth range
      DNS_BASE: 'myst.yana' # dns server base name
      DNS1: 'www:172.100.30.10' # [subdomainPrefix]:[targetedIp]
      DNS2: 'reduncy:172.100.30.58' # [subdomainPrefix]:[targetedIp]
    extra_hosts:
      - "www.myst.yana:172.100.30.10" # container server0
      - "reduncy.myst.yana:172.100.30.58" # container server1

networks:
  dnsserver:
    driver: bridge
    ipam:
      config:
        - subnet: 172.100.30.0/24
          gateway: 172.100.30.1
```

## FIX: 1.0.1

* MOVE RESOLV TO EXTRA_HOST
* MAKE SURE AVAILABILITY OF BIND AND NGINX