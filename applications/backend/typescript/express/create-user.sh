#!/bin/sh
deluser node
addgroup  -g 1000 1000
adduser -g " " -u 1000 -G 1000 1000
chown 1000:1000 /usr/src/app
