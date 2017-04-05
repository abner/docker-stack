#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker build -t abner/postgres:9.6.2-ptBR-onbuild $DIR -f $DIR/9.6.2-ptBR-alpine-onbuild.Dockerfile