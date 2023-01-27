#!/bin/bash
#sysctl -w net.ipv4.ip_nonlocal_bind=1;

if [ "${CUSTOM_CERT}" != "false" ]; then
./scripts/certificatssl.sh /usr/local/nginx/ssl-cert www
else
sed -i "s/\/usr\/local\/nginx\/ssl-cert\/{domain}.key/${CUSTOM_KEY_FILE}/g" /etc/bind/named.conf.options
sed -i "s/\/usr\/local\/nginx\/ssl-cert\/{domain}\.crt/${CUSTOM_CERT_FILE}/g" /etc/bind/named.conf.options
fi

cat /etc/bind/named.conf.options
python3.9 setup.py &
tail -f /var/log/nginx/*.log;


#iptables -t mangle -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-ip 172.100.20.70 --on-port 7555 --tproxy-mark 1/1
#iptables -t mangle -A PREROUTING -i eth0 --source 172.100.20.0/24 -j ACCEPT
#iptables -t mangle -A PREROUTING -i eth0 --destination 172.100.20.0/24 -j ACCEPT
#iptables -t mangle -A PREROUTING -i eth0 -p tcp -m tcp --sport 80 -j MARK --set-mark 1/1
