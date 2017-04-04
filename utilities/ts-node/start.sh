#!/bin/bash

if [ -z ${NODE_ENV:+x} ]; then
    APP_ENV=$NODE_ENV
else
   APP_ENV=development    
fi


echo "Starting Typescript App in mode '$APP_ENV'"


if [APP_ENV == 'production' ] ; then
    yarn start:produciton
else 
   yarn start
fi