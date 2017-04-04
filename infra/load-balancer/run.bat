@echo off
docker-machine start
docker-machine ip > hostname.txt
set /p REN_RT_EXTERNAL_IP=<hostname.txt
del hostname.txt
echo Host-ip: %REN_RT_EXTERNAL_IP%
@FOR /f "tokens=*" %i IN ('docker-machine env') DO @%i
call docker-compose up