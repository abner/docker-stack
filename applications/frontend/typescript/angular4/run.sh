#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GROUP_ID=$(id -g $USER)
USER_ID=$(id -u $USER)
echo "GID: $GROUP_ID"
echo "UID: $USER_ID"

if [ ! -f .$DIR/create-user.sh ]; then
  read -r -d '' CREATE_USER_FILE_CONTENT << EOF
#!/bin/sh
deluser node
addgroup  -g $GROUP_ID $GROUP_ID
adduser -g " " -u $USER_ID -G $GROUP_ID $USER_ID
chown $USER_ID:$GROUP_ID /usr/src/app
EOF
   echo -e "$CREATE_USER_FILE_CONTENT" > create-user.sh
   chmod +x create-user.sh
fi

echo "\nBuilding abner/angular4:onbuild"

if docker build -t abner/angular4:onbuild $DIR/ -f $DIR/Dockerfile; then
    echo -e "\nstarting container..."
    if [ docker run --rm --tty -it -v $DIR:/usr/local/app -p 4200:4200 -u "$USER_ID" abner/angular4:onbuild]; then
        echo -e "\nContainer started and is running on port"
    else
        echo -e "\nFailed to start container using docker image abner/angular4"
    fi
else
    echo -e "\nFailed to build docker image abner/angular4:onbuild"
fi

