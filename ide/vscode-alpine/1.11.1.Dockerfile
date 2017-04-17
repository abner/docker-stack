FROM alpine

LABEL MAINTAINER="abner <contato@abner.io>"

RUN apk update && apk add --no-cache sudo ttf-dejavu ttf-ubuntu-font-family ttf-liberation git zsh tmux libnotify  nss-dev xss-dev xtst-dev xss-dev && \
     rm -rf /var/cache/apk

COPY /tmp/VSCode-linux-x64/  /usr/apps/vscode/

RUN ln -s /usr/apps/vscode/code /usr/local/bin/code

COPY bin/ /usr/local/bin/

RUN chmod +x /usr/local/bin/*

#Fonts config for vscode

COPY common-files/local.conf /etc/fonts/local.conf

# INSTALL Fonts

RUN cd /usr/share/fonts/truetype/; mkdir ttf-monaco; mkdir ttf-proggyclean; 

COPY common-files/Monaco_Linux.ttf /usr/share/fonts/truetype/ttf-monaco/Monaco_Linux.ttf
COPY common-files/ProggyCleanSZ.ttf /usr/share/fonts/truetype/ttf-proggyclean/ProggyCleanSZ.ttf

RUN    cd /usr/share/fonts/truetype/ttf-monaco &&  \
        mkfontdir  && \
        cd /usr/share/fonts/truetype/ttf-proggyclean && \
        mkfontdir && \
        cd ../ &&    \
        fc-cache

ENTRYPOINT ["/bin/zsh", "-c", "/home/node/entrypoint.sh"]
