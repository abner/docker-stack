#!/bin/zsh

create_user

sudo chown -R app $HOME

PROJECTS_DIR=/home/node/projects

APP_DIR=$PROJECTS_DIR/$PROJECT_NAME

export PATH=$PATH:$HOME/bin

echo "APP DIR --------"
echo $APP_DIR


function create_user {
    mkdir -p /home/app/.ssh/ && ssh-keyscan github.com >> /home/app/.ssh/known_hosts && ssh-keyscan gitlab.com >> /home/app/.ssh/known_hosts

}




# Inicializar servidor alm
cat /home/app/ng-tsserver.sh | bash

#xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $XAUTHORITY_TOKEN


sudo chown -R $UID $HOME

# Abrir tmux com janelas com testes, servidor de desenvolvimento e monitoramento de recursos da máquina
/bin/zsh -c /home/app/tmux.sh $APP_DIR