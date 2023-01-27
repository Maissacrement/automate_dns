#!/bin/bash
set -e

location=$1
location=${location:-""}
mkdir -p ${location}

DNS="www.${DNS_BASE}"
echo "DNS: ${DNS}"

echo "x509_extensions = v3_req
prompt = no
distinguished_name = req_distinguished_name

[req_distinguished_name]
C = US
ST = VA
L = Paris
O = RFtoolkit, Inc.
OU = Tech
CN = rftoolkit.ddns.net
[v3_req]
keyUsage = critical, digitalSignature, keyAgreement
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = www.${DNS_BASE}
DNS.2 = *.${DNS_BASE}
DNS.3 = ${DNS_BASE}
DNS.4 = ${IP}" > ${location}/v3.ext

echo "Location: ${location}"

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -config ${location}/v3.ext -keyout ${location}/www.${DNS_BASE}.key -out ${location}/www.${DNS_BASE}.crt

chmod -R 777 ${location}/*.crt
chmod -R 777 ${location}/*.key
#cat ${location}/www.${DNS_BASE}.{crt,key} > ${location}/bundleca
cp ${location}/www.${DNS_BASE}.{crt,key} /etc/ca-certificates/update.d/
update-ca-certificates
sed -i "s/{domain}/$DNS/g" /etc/bind/named.conf.options