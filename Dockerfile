# Copyright (c) 2024 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
# Copyright (c) 2024 Jérémy WALTHER <jeremy.walther@golflima.net>
# See <https://github.com/frxyt/docker-cowenv> for details.

FROM alpine:latest
LABEL maintainer="Jérémy WALTHER <jeremy@ferox.yt>"

RUN apk add --no-cache 
RUN set -ex; \
    apk add --no-cache \
        bash \
        git \
        nginx \
        perl; \
    git clone https://github.com/schacon/cowsay.git /tmp/cowsay; \
    cd /tmp/cowsay; \
    ./install.sh /usr/local; \
    rm -rf /tmp/cowsay; \
    apk del git; \
    mkdir -p /var/www/html /var/www/run/nginx/logs; \
    chown nginx:nginx -R /var/www/html /var/www/run;

COPY cowenv         /usr/local/bin/cowenv
COPY default.conf   /etc/nginx/http.d/default.conf
COPY nginx.conf     /etc/nginx/nginx.conf

USER nginx
EXPOSE 8080

ENV COWSAY_F=default \
    COWSAY_W=100

ENTRYPOINT [ "/usr/local/bin/cowenv" ]
