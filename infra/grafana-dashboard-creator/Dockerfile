FROM alpine:latest

RUN apk add --update curl bash ncurses && \
     rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app

ENV TERM=xterm-256color

COPY create-dashboard.sh /usr/src/app/create-dashboard.sh
COPY Container.json.tmpl /usr/src/app/Container.json.tmpl

RUN chmod +x /usr/src/app/create-dashboard.sh

ONBUILD COPY Container.json.tmpl /usr/src/app


WORKDIR /usr/src/app

CMD '/usr/src/app/create-dashboard.sh'



