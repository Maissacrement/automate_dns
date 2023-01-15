FROM registry.gitlab.com/maissacrement/dns:1.0.1


##### UPGRADE BIND9
RUN apt remove -y bind9

WORKDIR /opt
RUN wget -q https://codeload.github.com/isc-projects/bind9/tar.gz/refs/tags/v9_17_21
RUN ls && tar -xvf v9_17_21 && mv bind9-9_17_21 bind

RUN apt update &&\
    apt install -y autoconf automake libtool libuv1-dev libnghttp2-dev libcap-dev \
        make pkg-config check g++ librsync-dev libz-dev libssl-dev uthash-dev libyajl-dev

WORKDIR /opt/bind

RUN autoreconf -fi &&\
    ./configure --prefix=/usr &&\
    make &&\
    make install &&\
    ldconfig

##### UPGRADE BIND9

WORKDIR /app
COPY ./* ./

RUN chmod +x ./entrypoint.sh &&\
    cp -r ./etc/bind/* /etc/bind/

RUN /lib/systemd/systemd-sysv-install enable bind

RUN touch /var/run/nginx.pid

RUN apt install -y libiscsi-dev

RUN cp /etc/bind/named.conf /usr/etc/ &&\
    mkdir /var/cache/bind

ENTRYPOINT ["./entrypoint.sh"]