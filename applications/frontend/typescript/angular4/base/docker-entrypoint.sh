#!/bin/sh

echo "Docker Entrypoint of abner/angular4 container"

create-user

chown app:app-group -R /usr/src/app/
chown app:app-group /template/ -R

ls -la /template

if ! [ -f /usr/src/app/.angular-cli.json ]; then
     TEMPLATE_FOLDER="/template"
     echo "TEMPLATE FOLDER: $TEMPLATE_FOLDER"
     cp -R $TEMPLATE_FOLDER/. /usr/src/app/
     cd /usr/src/app/
     ls -la
     yarn
     ng set prefix $NG_APP_PREFIX
     ng set name $NG_APP_NAME
     chown app:app-group -R /usr/src/app/
     
     #ng new $NG_APP_NAME  --style scss --prefix $NG_APP_PREFIX --routing true
fi

cd /usr/src/app
chown app:app-group -R /usr/src/app/

echo "Just about to start: $@"
exec "$@"
