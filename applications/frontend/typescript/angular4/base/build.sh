#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t abner/angular4-base:alpine-onbuild $DIR/ -f $DIR/ng-alpine.Dockerfile $@