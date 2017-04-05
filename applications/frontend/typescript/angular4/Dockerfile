FROM node:7

# Install Chromium & Xvfb
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable xvfb && \
  rm -rf /var/lib/apt/lists/*


RUN npm install -g @angular/cli@1.0.0 watchman typings ts-node

RUN xvfb :99 -ac 

RUN export DISPLAY=:99.0

WORKDIR /usr/src/app

COPY ./docker-entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

VOLUME /usr/src/app

# Install dependencies
ENTRYPOINT "entrypoint"

CMD ["yarn", "start"]
