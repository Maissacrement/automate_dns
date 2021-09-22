#!/bin/bash
sysctl -w net.ipv4.ip_nonlocal_bind=1;
/etc/init.d/bind start;
/etc/init.d/bind restart;
./scripts/certificatssl.sh /usr/local/nginx/ssl-cert www;
python3.9 setup.py;
tail -f /dev/null;

#iptables -t mangle -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-ip 172.100.20.70 --on-port 7555 --tproxy-mark 1/1
#iptables -t mangle -A PREROUTING -i eth0 --source 172.100.20.0/24 -j ACCEPT
#iptables -t mangle -A PREROUTING -i eth0 --destination 172.100.20.0/24 -j ACCEPT
#iptables -t mangle -A PREROUTING -i eth0 -p tcp -m tcp --sport 80 -j MARK --set-mark 1/1