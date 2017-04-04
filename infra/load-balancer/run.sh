#!/bin/bash
docker-machine start balancer;
eval $(docker-machine env balancer)
export BALANCER_IP=$(docker-machine ip balancer)
echo -e "Started :: Balancer Docker :: [ by Abner Oliveira® ]... on $BALANCER_IP"
docker-compose up -d && \
export DOCKER_PS=$(docker ps)
docker run --rm  --env-file .env --env BALANCER_IP=$BALANCER_IP --env DOCKER_PS="$DOCKER_PS" -v ${PWD}/docker-ps.output:/tmp/docker-ps.output abner/grafana-dashboard-creator