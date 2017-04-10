#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "DIR: $DIR"

VSCODE_FOLDER="$DIR/tmp"

if ! [ -d $VSCODE_FOLDER ]; then
    mkdir -p $VSCODE_FOLDER
fi

VSCODE_TAR_FILE="$DIR/tmp/code-stable-code_1.11.1.tar.gz"
VSCODE_DOWNLOAD_URL="https://go.microsoft.com/fwlink/?LinkID=620884"


function build_docker {
    echo -e "Starting to build docker abner/vscode:1.11.1\n"
    docker build -t abner/vscode:1.11.1 ./ -f ./1.11.1.Dockerfile
}

if [ -d $VSCODE_FOLDER ]; then
   if ! [ -f $VSCODE_TAR_FILE ]; then
     echo -e "Getting Visual Studio Code Tar file ($VSCODE_TAR_FILE)...\n"
     curl -L $VSCODE_DOWNLOAD_URL -o $VSCODE_TAR_FILE
   fi
   echo -e "Extracting Visual Studio Tar file..."
   echo "COMMAND: tar -xzvf $VSCODE_TAR_FILE -C $VSCODE_FOLDER" 
   if tar -xzvf $VSCODE_TAR_FILE -C $VSCODE_FOLDER; then
     echo -e "Visual Studio Code is ready on folder $VSCODE_FOLDER\n"
     build_docker
   else
     echo -e "Error extracting VSCODE"
   fi
fi


