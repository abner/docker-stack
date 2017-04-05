#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GROUP_ID=$(id -g $USER)
USER_ID=$(id -u $USER)
echo "GID: $GROUP_ID"
echo "UID: $USER_ID"
if [ ! -f .$DIR/create-user.sh ]; then
  read -d '' CREATE_USER_FILE_CONTENT << EOF
#!/bin/sh
deluser node
addgroup  -g $GROUP_ID $GROUP_ID
adduser -g " " -u $USER_ID -G $GROUP_ID $USER_ID
chown $USER_ID:$GROUP_ID /usr/src/app
EOF
   echo -e "$CREATE_USER_FILE_CONTENT" > create-user.sh
   chmod +x create-user.sh
fi

echo "BUILDING DOCKER IMAGE abner/app-ts-node"

docker build -t  abner/app-ts-node  $DIR -f $DIR/development.Dockerfile

#sudo chown $USER_ID:$GROUP_ID -R ./node_modules

echo "STARTING CONTAINER USING IMAGE abner/app-ts-node. USER_ID=$USER_ID"
docker run --rm -it --tty -v $DIR:/usr/src/app -u "$USER_ID" -p 3000:3000 abner/app-ts-node 