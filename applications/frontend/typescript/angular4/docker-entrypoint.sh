#!/bin/sh

echo "Docker Entrypoint of abner/angular4 container"
echo "CURRENT USER: $(whoami)"
echo "SHOWING ENVIRONMENT VARIABLES..."
env



chown app:app-group -R /templates/template-app
chown app:app-group -R /usr/src/app/

echo  "listing templates folder"
ls -la /templates
echo "listing app folder"
ls -la /usr/src/app

if ! [ -f /usr/src/app/$NG_APP_NAME/.angular-cli.json ]; then
     cp -R /templates/template-app /usr/src/app/$NG_APP_NAME
     ng set prefix $NG_APP_PREFIX
     ng set name $NG_APP_NAME
     chown app:app-group -R /usr/src/app/
     #ng new $NG_APP_NAME  --style scss --prefix $NG_APP_PREFIX --routing true
fi

cd /usr/src/app/$NG_APP_NAME

yarn serve &