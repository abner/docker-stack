FROM node:6.10.0-alpine

RUN npm install -g @angular/cli@1.0.0 watchman ts-node

RUN ng set packageManager=yarn --global

RUN mkdir -p usr/src/app

WORKDIR /usr/src/app


COPY ./build-sass.sh /usr/local/bin/build-sass

RUN chmod +x /usr/local/bin/build-sass

RUN  /usr/local/bin/build-sass

RUN ng set packageManager=yarn --global

COPY ./docker-entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 4200

ENTRYPOINT ["sh", "/usr/local/bin/entrypoint"]

COPY template /template

USER root

COPY ./create-user-with-args.sh /usr/local/bin/create-user

RUN chmod +x /usr/local/bin/create-user

CMD ["ng", "serve", "-H", "0.0.0.0"]