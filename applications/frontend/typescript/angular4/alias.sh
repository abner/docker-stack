export NG_APP_PREFIX=myApp
export NG_APP_NAME=my-app
alias _ng="docker run --rm -v $PWD/apps:/usr/src/app -e NG_APP_PREFIX=$NG_APP_PREFIX -e NG_APP_NAME=$NG_APP_NAME abner/angular4:onbuild ng $@"
alias _ngt="_ng test"
alias _ngb="_ng build --prod"
alias _ngg="_ng generate $@"
alias _nge="_ng e2e"