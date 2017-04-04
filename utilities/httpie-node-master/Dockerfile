FROM node:6.10.0-alpine

RUN apk add --update curl python py-pip ca-certificates unzip

RUN pip install --upgrade pip

RUN pip install -U httpie httpie-unixsocket && rm -rf /var/cache/apk/*

VOLUME ["/opt/httpie-node"]

RUN yarn global add typescript ts-node

RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu

COPY ./entrypoint.sh /

RUN chmod +x ./entrypoint.sh

ENV HTTPIE_CONFIG_DIR=/home/node/.httpie

USER node

ENTRYPOINT ["/entrypoint.sh"]

CMD ["node"]
