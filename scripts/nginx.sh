NGINX_VERSION=1.9.5
debian_installer="apt install -y"
debian_package="libpcre16-3 libpcre3-dev libghc-hsopenssl-dev libghc-zlib-dev libghc-puremd5-dev libmd-dev wget tar make"

main () {
  apt update
  mkdir /nginx;cd nginx;
  bash -c "${debian_installer} ${debian_package}"
  wget -O nginx-${NGINX_VERSION}.tar.gz --no-check-certificate https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
  tar -zxvf nginx-${NGINX_VERSION}.tar.gz
  cd nginx-${NGINX_VERSION}
  ./configure --with-http_ssl_module --with-http_v2_module --with-openssl-opt=enable-tls1_3 --with-http_realip_module && make install && make
  export PATH=${PATH}:/usr/local/nginx/sbin
  echo "export PATH=${PATH}:/usr/local/nginx/sbin" >> ~/.bashrc
  nginx
}

main