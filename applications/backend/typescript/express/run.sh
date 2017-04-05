#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t abner/app-ts-node $DIR

docker run --tty -it --rm -p 3000:3000 abner/app-ts-node 