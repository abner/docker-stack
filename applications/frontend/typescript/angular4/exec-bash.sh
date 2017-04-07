#!/bin/bash
CONTAINER_ID=$(docker ps -f ancestor=abner/angular4:onbuild --format '{{ .ID}}')
docker exec --tty -it $CONTAINER_ID /bin/bash
