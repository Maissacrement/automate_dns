#!/bin/bash
#sysctl -w net.ipv4.ip_nonlocal_bind=1;
./scripts/certificatssl.sh /usr/local/nginx/ssl-cert www;
nohup python3.9 setup.py;
tail -f /var/log/nginx/*.log;

#iptables -t mangle -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-ip 172.100.20.70 --on-port 7555 --tproxy-mark 1/1
#iptables -t mangle -A PREROUTING -i eth0 --source 172.100.20.0/24 -j ACCEPT
#iptables -t mangle -A PREROUTING -i eth0 --destination 172.100.20.0/24 -j ACCEPT
#iptables -t mangle -A PREROUTING -i eth0 -p tcp -m tcp --sport 80 -j MARK --set-mark 1/1