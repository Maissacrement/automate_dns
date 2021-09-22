FROM kathara/quagga

ENV DEV_HOME=/home/nginx \
    uid=1000 gid=1000

# DEV USER
RUN mkdir -p ${DEV_HOME} ${DEV_HOME}/app && \
    echo "nginx:x:${uid}:${gid}:nginx,,,:${DEV_HOME}:/bin/bash" >> /etc/passwd && \
    echo "nginx:x:${uid}:" >> /etc/group

RUN apt update && apt install -y build-essential zlib1g-dev libncurses5-dev netcat \
    libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev python3-dev \
    wget libbz2-dev

RUN wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz && tar -xf Python-3.9.1.tgz

WORKDIR /Python-3.9.1
#--enable-shared
RUN ./configure --enable-optimizations &&\
    make -j 12 && make altinstall &&\
    pip3.9 install python-dotenv pyinstaller

WORKDIR /app
COPY . .

RUN chmod +x ./entrypoint.sh ./scripts/nginx.sh ./scripts/certificatssl.sh &&\
    mkdir -p /var/log/nginx/ /usr/local/nginx/ssl-cert /data/ssl-cert/ /usr/local/nginx/conf/includes/ &&\
    ./scripts/nginx.sh &&\
    mv /usr/local/nginx/conf/includes/base.conf /usr/local/nginx/conf/nginx.conf &&\
    cp -r ./etc/bind/* /etc/bind/ &&\
    touch /var/log/nginx/error.log &&\
    /lib/systemd/systemd-sysv-install enable bind

RUN touch /var/run/nginx.pid

ENTRYPOINT ["./entrypoint.sh"]