#!/bin/sh
deluser node
addgroup --gid 888 app-group
adduser --system --home /usr/src/app --gecos " " --no-create-home --uid 801294985 --gid 888 app
chown app:app-group /usr/src/app
