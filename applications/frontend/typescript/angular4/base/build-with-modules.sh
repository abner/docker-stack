#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t abner/angular4-base:alpine-onbuild-with-modules $DIR/ -f $DIR/ng_with_modules-alpine.Dockerfile $@