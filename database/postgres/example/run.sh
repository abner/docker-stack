#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo "Stops previously running container..."
docker stop $(docker ps --filter ancestor=abner/postgres:9.6.2-ptBR-example -q)

echo "Building example image"
docker build -t abner/postgres:9.6.2-ptBR-example $DIR -f $DIR/Dockerfile
echo ""
echo "starting container..."
docker run --rm -d -p 5432:5432 abner/postgres:9.6.2-ptBR-example
echo ""
echo "waiting for postgres..."
DB_PORT=5432 python $DIR/wait-for-postgres.py
sleep 5
while ! docker logs $(docker ps --filter ancestor=abner/postgres:9.6.2-ptBR-example -q)  | grep "database system is ready to accept connections"
do
  echo "$(date) - still waiting..."
  sleep 3
done
echo ""
echo "postgres is ready."
echo ""
echo "executing repl"
docker exec -it --tty -e PG_PASSWORD=nw $(docker ps --filter ancestor=abner/postgres:9.6.2-ptBR-example -q) psql -U northwind