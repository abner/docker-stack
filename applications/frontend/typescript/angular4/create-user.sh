#!/bin/sh
deluser node
addgroup --gid 1000 app-group
adduser --system --home /usr/src/app --gecos " " --no-create-home --uid 1000 --gid 1000 app
chown app:app-group /usr/src/app
