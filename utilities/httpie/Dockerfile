FROM alpine:latest

RUN apk add --update curl python py-pip ca-certificates unzip

RUN pip install --upgrade pip

RUN pip install -U httpie httpie-unixsocket && rm -rf /var/cache/apk/*

ENTRYPOINT ["http"]
