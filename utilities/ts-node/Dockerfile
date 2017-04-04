FROM node:6.10.0-alpine

RUN npm i -g typescript ts-node

RUN mkdir -p /usr/src/appts

WORKDIR /usr/src/app

RUN chown node:node -R /usr/src/app


COPY entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

USER node

ONBUILD COPY ./tsconfig.json /usr/src/app/tsconfig.json
ONBUILD COPY ./package.json /usr/src/app/package.json
ONBUILD COPY ./src /usr/src/app/src
ONBUILD RUN yarn
ONBUILD RUN yarn build



## install dependencies if a package.json was provided
RUN ((file package.json && yarn) || echo 1) &  2>&1

ENTRYPOINT ["entrypoint"]

CMD "ts-node"
