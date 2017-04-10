#!/bin/sh
echo -e "Script... creating user app"
env
deluser node
addgroup -g $GID app-group
adduser -h /usr/src/app -D -g " " -H -u $UID -G app-group app -s /bin/bash
chown app:$GID /usr/src/app
