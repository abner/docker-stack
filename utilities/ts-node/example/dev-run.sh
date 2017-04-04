#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t abner/app-ts-node $DIR -f $DIR/Dockerfile.development

docker run --rm -it -v $DIR:/usr/src/app -p 3000:3000 abner/app-ts-node 