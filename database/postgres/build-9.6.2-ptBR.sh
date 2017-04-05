#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t abner/postgres:9.6.2-ptBR $DIR -f $DIR/9.6.2-ptBR-alpine.Dockerfile