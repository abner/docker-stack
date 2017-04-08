#!/bin/bash

NG_APP_NAME=$1

NG_APP_PREFIX=$2

EXTRA_ARGS=$3


function run {
    echo -e "\nstarting container..."
    if echo "$EXTRA_ARGS" | grep test ; then
        if docker run --rm -v $DIR/apps:/usr/src/app -e NG_APP_PREFIX=$NG_APP_PREFIX -e NG_APP_NAME=$NG_APP_NAME abner/angular4:onbuild ng test --single-run; then
            echo -e "Tests executed successfully."
        fi
    else
        if docker run --rm --name "abner_angular4_$NG_APP_NAME" -v $DIR/apps:/usr/src/app -e NG_APP_PREFIX=$NG_APP_PREFIX -e NG_APP_NAME=$NG_APP_NAME -p 4200:4200 abner/angular4:onbuild ng serve -H 0.0.0.0 $EXTRA_ARGS; then
            echo -e "\nContainer started and is running on port"
        else
            echo -e "\nFailed to start container using docker image abner/angular4"
        fi
    fi
}

if [ -z ${REBUILD:+x} ]; then

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
        run
    else
        echo -e "\nFailed to build docker image abner/angular4:onbuild"
    fi
else 
    run
fi