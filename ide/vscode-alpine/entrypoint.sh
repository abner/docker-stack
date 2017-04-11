#!/bin/zsh

create_user

sudo chown -R app $HOME

PROJECTS_DIR=/home/node/projects

APP_DIR=$PROJECTS_DIR/$PROJECT_NAME

export PATH=$PATH:$HOME/bin

echo "APP DIR --------"
echo $APP_DIR


mkdir -p /home/app/.ssh/ && ssh-keyscan github.com >> /home/app/.ssh/known_hosts && ssh-keyscan gitlab.com >> /home/app/.ssh/known_hosts
addgroup --gid $GID app-group
adduser --system --home /home/app --gecos " " --no-create-home --uid $UID --gid $GID app
chown app:app-group /home/app

# Inicializar servidor alm
cat /home/app/ng-tsserver.sh | bash

#xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $XAUTHORITY_TOKEN


sudo chown -R $UID $HOME

# Abrir tmux com janelas com testes, servidor de desenvolvimento e monitoramento de recursos da máquina
/bin/zsh -c /home/app/tmux.sh $APP_DIR