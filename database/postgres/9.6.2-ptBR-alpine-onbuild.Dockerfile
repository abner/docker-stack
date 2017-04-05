FROM postgres:9.6.2-alpine
ENV LANG pt_BR.utf8

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app


ONBUILD ADD dump.sql /docker-entrypoint-initdb.d/dump.sql
