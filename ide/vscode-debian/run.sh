#!/bin/bash
docker run --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME:/home/user \
    -e DISPLAY=unix$DISPLAY \
    --device /dev/dri \
    abner/vscode-debian