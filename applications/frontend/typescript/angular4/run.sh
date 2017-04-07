#!/bin/bash

NG_APP_NAME=$1

NG_APP_PREFIX=$2

if [ -z ${NG_APP_NAME:+x} ]; then
   NG_APP_NAME="app-angular4"
fi

if [ -z ${NG_APP_PREFIX:+x} ]; then
   NG_APP_PREFIX="app"
fi



echo "APP NAME: $NG_APP_NAME"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GROUP_ID=$(id -g $USER)
USER_ID=$(id -u $USER)
echo "GID: $GROUP_ID"
echo "UID: $USER_ID"

if [ ! -f .$DIR/create-user.sh ]; then
  read -r -d '' CREATE_USER_FILE_CONTENT << EOF
#!/bin/sh
deluser node
addgroup --gid $GROUP_ID app-group
adduser --system --home /usr/src/app --gecos " " --no-create-home --uid $USER_ID --gid $GROUP_ID app
chown app:app-group /usr/src/app
EOF
   echo -e "$CREATE_USER_FILE_CONTENT" > create-user.sh
   chmod +x create-user.sh
fi

echo "\nBuilding abner/angular4:onbuild"

if docker build -t abner/angular4:onbuild $DIR/ -f $DIR/Dockerfile; then
    echo -e "\nstarting container..."
    if docker run --rm --tty -v $DIR/apps:/usr/src/app -e NG_APP_PREFIX=$NG_APP_PREFIX -e NG_APP_NAME=$NG_APP_NAME -p 4200:4200 abner/angular4:onbuild yarn; then
        echo -e "\nContainer started and is running on port"
    else
        echo -e "\nFailed to start container using docker image abner/angular4"
    fi
else
    echo -e "\nFailed to build docker image abner/angular4:onbuild"
fi

