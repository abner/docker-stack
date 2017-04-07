#!/bin/bash
CONTAINER_ID=$(docker ps -f ancestor=abner/angular4:onbuild --format '{{ .ID}}')
docker logs $CONTAINER_ID -f