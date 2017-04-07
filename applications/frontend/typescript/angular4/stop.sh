#!/bin/bash
CONTAINER_ID=$(docker ps -f ancestor=abner/angular4:onbuild --format '{{ .ID}}')
echo "Stoping container runing image abner/angular4:onbuild => $CONTAINER_ID"
if docker stop $CONTAINER_ID; then
    echo "Container stoped."
else
    echo "Error stopping container"
fi    
