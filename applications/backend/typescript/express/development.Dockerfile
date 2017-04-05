FROM abner/ts-node

EXPOSE 3000

VOLUME /usr/src/app

USER root

COPY ./create-user.sh /usr/local/bin/create-user

RUN /usr/local/bin/create-user

ENV NODE_ENV=development

RUN yarn 

CMD ["yarn", "start"]
