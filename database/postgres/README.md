

# Postgres

## Postgres 9.6.2 Alpine based image


**Starts the server**

```bash
docker run  -p 5432:5432 -d abner/postgres:9.6.2-ptBR
```

**psql repl**

```bash
docker exec -it --tty $(docker ps --filter ancestor=abner/postgres:9.6.2-ptBR -q) psql -U postgres
```


**bash terminal**

```bash
docker exec -it --tty $(docker ps --filter ancestor=abner/postgres:9.6.2-ptBR -q) /bin/sh
```