#!/bin/sh
deluser node
addgroup  -g 888 888
adduser -g " " -u 801294985 -G 888 801294985
chown 801294985:888 /usr/src/app
