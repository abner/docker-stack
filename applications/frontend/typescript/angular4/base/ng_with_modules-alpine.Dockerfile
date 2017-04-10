FROM abner/angular4-base:alpine-onbuild

RUN cp -R /template/. /usr/src/app/
RUN cd /usr/src/app; yarn 