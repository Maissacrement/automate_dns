#!/bin/bash
set -e

location=$1
location=${location:-""}
mkdir -p ${location}

DNS="$2.${DNS_BASE}"
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

echo "
distinguished_name = req_distinguished_name

[req_distinguished_name]
C = US
ST = CA
L = Paris
O = RFtoolkit, Inc.
OU = Tech
CN = www.${DNS_BASE}

[ ext ]
basicConstraints=CA:TRUE,pathlen:10
" > ${location}/server.cnf

echo "Location: ${location}"

# rm ${location}/*.{crt,key}
# Generate ca certificate -des3 
echo "GENERATE CA SSL CERTS"
openssl genrsa -out ${location}/ca.key 4096 
openssl req -new -subj "/CN=$DNS" -x509 -key ${location}/ca.key -out ${location}/ca.crt -config ${location}/v3.ext
ls ${location}
#openssl x509 -verify -in ${location}/ca.crt -text -noout

#cp ${location}/ca.{key,crt} /etc/ssl/certs

# Generate server 
echo "GENERATE SERVER SSL CERTS"
openssl genrsa -out ${location}/$DNS.key 2048
openssl req -new -sha256 -subj "/C=US/ST=CA/O=RFtoolkit, Inc./CN=$DNS" -config ${location}/server.cnf -key ${location}/$DNS.key -out ${location}/$DNS.csr

openssl req -in ${location}/$DNS.csr -noout -text
openssl req -text -noout -verify -in ${location}/$DNS.csr

# Sign server key with CA authority
openssl x509 -req -in ${location}/$DNS.csr -CA ${location}/ca.crt -CAkey ${location}/ca.key -CAcreateserial -out ${location}/$DNS.crt -sha256

chown -R $USER:$USER ${location}
chmod -R 770 ${location}/*.crt
chmod -R 770 ${location}/*.key
cat  ${location}/ca.{crt,key} > ${location}/bundleca
cp ${location}/* /etc/ca-certificates/update.d/
update-ca-certificates
sed -i "s/{domain}/$DNS/g" /etc/bind/named.conf.options
