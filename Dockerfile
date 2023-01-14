FROM registry.gitlab.com/maissacrement/dns:1.0.1

WORKDIR /app
COPY ./entrypoint.sh ./entrypoint.sh

RUN chmod +x ./entrypoint.sh

RUN /lib/systemd/systemd-sysv-install enable bind

RUN touch /var/run/nginx.pid

ENTRYPOINT ["./entrypoint.sh"]