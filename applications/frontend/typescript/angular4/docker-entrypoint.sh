#!/bin/sh
if ! [ -f /usr/src/app/.angular-cli.json ]; then
    ng new --style scss --prefix $NG_APP_NAME --routing true --directory /usr/src/app
fi

yarn

exec "$@"