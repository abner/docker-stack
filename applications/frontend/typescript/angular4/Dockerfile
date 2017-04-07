FROM node:6.10.0

# Install Chromium & Xvfb
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable xvfb && \
  rm -rf /var/lib/apt/lists/*


RUN npm install -g @angular/cli@1.0.0 watchman typings ts-node

RUN ng set packageManager=yarn --global
#RUN xvfb :99 -ac 

RUN export DISPLAY=:99.0

RUN mkdir -p usr/src/app
RUN mkdir -p /templates

WORKDIR /usr/src/app


COPY ./create-user.sh /usr/local/bin/create-user

RUN /usr/local/bin/create-user
RUN chown -R app:app-group /usr/src/app



RUN chown app:app-group /templates/ -R

RUN chown app:app-group /usr/src/app/ -R


RUN ng set packageManager=yarn --global

RUN cd /templates/; ng new template-app --directory --style scss --routing true --prefix app

RUN chown -R app:app-group /usr/src/app

USER root

COPY ./docker-entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

# Install dependencies
ENTRYPOINT "entrypoint"

EXPOSE 4200

CMD ["yarn", "start"]
