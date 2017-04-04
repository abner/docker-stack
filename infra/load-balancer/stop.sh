#!/bin/bash
eval $(docker-machine env balancer)
export BALANCER_IP=$(docker-machine ip balancer)
echo -e "Stopping :: Balancer Docker :: [ by Abner Oliveira® ]... on $BALANCER_IP"

docker-compose down  && \
echo -e "Stopped successfuly. Bye :D"
exit 0;
echo 'Error on stopping # Balancer Docker'