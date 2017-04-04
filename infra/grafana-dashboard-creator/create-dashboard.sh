#!/bin/bash
#
# See README.md for details
#
# Set up and pair an InfluxDB database with Grafana
# - ensures the InfluxDB database and DB user exist
# - ensures the proxied Grafana InfluxDB data store exists
# - creates/updates dashboards for each container, and one for all containers
#
# The InfluxDB database, InfluxDB user, and InfluxDB password hard-coded to 'cadvisor'
#
# This is a modified fork of Lee Hambley's Gist:
# at https://github.com/leehambley
#
# Usage:
#
#   create-dashboards.sh

echo "BALANCER IP: $BALANCER_IP"
if [ -n $BALANCER_IP ]; then 
  DASHBOARD_HOST=$BALANCER_IP;
else
  DASHBOARD_HOST='localhost'
fi

INFLUXDB_API_URL="http://$DASHBOARD_HOST:8086/"
INFLUXDB_API_REMOTE_URL="http://influxsrv:8086"     # url for commands proxied through Grafana

GRAFANA_URL="http://$DASHBOARD_HOST:8081/"
GRAFANA_API_URL="http://$DASHBOARD_HOST:8081/api/"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NEWLINE='
'
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#COOKIEJAR=$(mktemp)
touch ./grafana-sessions
COOKIEJAR=./grafana-sessions
trap 'unlink ${COOKIEJAR}' EXIT

function influx_has_user {
    echo "CHECKING IF INFLUX HAS USER"
    echo "INFLUX API: $INFLUXDB_API_URL"
  curl \ 
    --silent \
    --data-urlencode "q=SHOW USERS" \
    "${INFLUXDB_API_URL}query?u=${INFLUXDB_USER}&p=${INFLUXDB_PASS}" \
    | grep -q "${CADVISOR_INFLUXDB_USER_NAME}"
}

function influx_create_user {
  curl \
    --silent \
    -XPOST \
    --data-urlencode "q=CREATE USER ${CADVISOR_INFLUXDB_USER_NAME} WITH PASSWORD '${CADVISOR_INFLUXDB_USER_PASSWORD}'; GRANT ALL PRIVILEGES ON ${CADVISOR_INFLUXDB_DB_NAME} TO ${CADVISOR_INFLUXDB_USER_NAME}" \
    "${INFLUXDB_API_URL}query?u=${INFLUXDB_ROOT_ADMIN}&p=${INFLUXDB_PASS}" > /dev/null 2>&1
}

function influx_create_database {
   echo -e "CREATING INFLUXDB ON $INFLUXDB_API_URL WITH $INFLUXDB_USER:$INFLUXDB_PASS"
   curl \
      -XPOST  \
      --data-urlencode "q=CREATE DATABASE $CADVISOR_INFLUXDB_DB_NAME" \
       "${INFLUXDB_API_URL}query?u=${INFLUXDB_USER}&p=${INFLUXDB_PASS}"
      
}

function setup_influxdb {
  influx_create_database
  # Note: InfluxDB is configured with PRE_CREATE_DB=cadvisor
  if influx_has_user; then
    info "InfluxDB: Database ${CADVISOR_INFLUXDB_DB_NAME} already has the user ${CADVISOR_INFLUXDB_USER_NAME}"
  else
    if influx_create_user; then
      success "InfluxDB: Database ${CADVISOR_INFLUXDB_DB_NAME} user ${CADVISOR_INFLUXDB_USER_NAME} created"
    else
      error "InfluxDB: Database ${CADVISOR_INFLUXDB_DB_NAME} user ${CADVISOR_INFLUXDB_USER_NAME} could not be created"
    fi
  fi
}

function setup_grafana_session {
  echo "GRAFANA LOGIN: ${GRAFANA_LOGIN}"
  echo "GRAFANA PASSWORD: ${GRAFANA_PASSWORD}"
  if !   curl -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary "{\"user\":\"${GRAFANA_LOGIN}\",\"email\":\"\",\"password\":\"${GRAFANA_PASSWORD}\"}" \
    --cookie-jar "$COOKIEJAR" \
    "${GRAFANA_URL}login" ; then #> /dev/null 2>&1 ; then
    echo
    error "Grafana Session: Couldn't store cookies at ${COOKIEJAR}"
  fi
}

function grafana_has_data_source {
  setup_grafana_session
  curl --silent --cookie "${COOKIEJAR}" "${GRAFANA_API_URL}datasources" \
    | grep "\"name\":\"${GRAFANA_DATA_SOURCE_NAME}\"" -q
}

function grafana_create_data_source {
  echo "GRAFANA API: $GRAFANA_API_URL"
  echo "GRAFANA DATASOURCE: $GRAFANA_DATA_SOURCE_NAME"
  echo "CADVISOR_INFLUXDB_DB_NAME: ${CADVISOR_INFLUXDB_DB_NAME}"
  echo "CADVISOR_INFLUXDB_USER_NAME: $CADVISOR_INFLUXDB_USER_NAME"
  echo "CADVISOR_INFLUXDB_USER_PASSWORD: $CADVISOR_INFLUXDB_USER_PASSWORD"
  echo -e "COOKIE JAR"; cat $COOKIEJAR
  echo "INFLUX DB API URL: $INFLUXDB_API_REMOTE_URL"
  setup_grafana_session
  curl --cookie "${COOKIEJAR}" \
       -X POST \ --silent \
       -H 'Content-Type: application/json;charset=UTF-8' \
       --data-binary "{\"name\":\"${GRAFANA_DATA_SOURCE_NAME}\",\"type\":\"influxdb\",\"url\":\"${INFLUXDB_API_REMOTE_URL}\",\"access\":\"proxy\",\"database\":\"$CADVISOR_INFLUXDB_DB_NAME\",\"user\":\"${CADVISOR_INFLUXDB_USER_NAME}\",\"password\":\"${CADVISOR_INFLUXDB_USER_PASSWORD}\"}" \
       "${GRAFANA_API_URL}datasources" 2>&1 | grep 'Datasource added' -q;
       #"${GRAFANA_API_URL}datasources";
}

function setup_grafana {
  if grafana_has_data_source; then
    info "Grafana: Data source ${CADVISOR_INFLUXDB_DB_NAME} already exists"
  else
    if grafana_create_data_source; then
      success "Grafana: Data source $CADVISOR_INFLUXDB_DB_NAME created"
    else
      error "Grafana: Data source $CADVISOR_INFLUXDB_DB_NAME could not be created"
    fi
  fi
}

function ensure_dashboard_from_template {
  TITLE=$1
  WHERE_CLAUSE=$2
  STACK=$3

  NET_USAGE_TITLE="Container Network Usage"
  FS_LIMIT_WHERE=""
  TOOLTIP_SHARED="true"
  if [ $STACK = "true" ]; then
    NET_USAGE_TITLE="Container Network Usage (view a single container if --net=host)"
    FS_LIMIT_WHERE="and 1=0"
    TOOLTIP_SHARED="false"
  fi

  TEMP_FILE_1=$(mktemp)
  cat "$DIR/Container.json.tmpl" \
    | sed -e "s|___TITLE___|$TITLE|g" \
    | sed -e "s|___STACK___|$STACK|g" \
    | sed -e "s|___FS_LIMIT_WHERE___|$FS_LIMIT_WHERE|g" \
    | sed -e "s|___NETWORK_USAGE_TITLE___|$NET_USAGE_TITLE|g" \
    | sed -e "s|___TOOLTIP_SHARED___|$TOOLTIP_SHARED|g" \
    | sed -e "s|___CONTAINER_WHERE_CLAUSE___|$WHERE_CLAUSE|g" \
    > "${TEMP_FILE_1}"
	ensure_grafana_dashboard "${TEMP_FILE_1}"
  RET=$?
  unlink "${TEMP_FILE_1}"
  if [ "${RET}" -ne "0" ]; then
    echo "An error occurred"
    exit 1
  fi
}

function ensure_grafana_dashboard {
  DASHBOARD_PATH=$1
  TEMP_DIR=$(mktemp -d)
  TEMP_FILE="${TEMP_DIR}/dashboard"

  # Need to wrap the dashboard json, and make sure the dashboard's "id" is null for insert
  echo '{"dashboard":' > $TEMP_FILE
  cat $DASHBOARD_PATH | sed -E 's/^  "id": [0-9]+,$/  "id": null,/' >> $TEMP_FILE
  echo ', "overwrite": true }' >> $TEMP_FILE

  curl --cookie "${COOKIEJAR}" \
       -X POST \
       --silent \
       -H 'Content-Type: application/json;charset=UTF-8' \
       --data "@${TEMP_FILE}" \
       "${GRAFANA_API_URL}dashboards/db" > /dev/null 2>&1
  unlink $TEMP_FILE
  rmdir $TEMP_DIR
}

function ensure_grafana_dashboards {
	echo "Creating a dashboard for 'All Containers'"
  ensure_dashboard_from_template 'All Containers (Stacked)' 'container_name !~ /\\\\//' "true"

	echo "Creating a dashboard for each running container"
  IFS=$NEWLINE
  for x in $(echo "$DOCKER_PS"); do
    CONTAINER_ID=`echo $x | awk '{print $1}'`
    CONTAINER=`echo $x | awk 'END {print $NF}'`

    # Skip the header
    if [ "${CONTAINER_ID}" = "CONTAINER" ]; then
      continue
    fi

    echo "creating a dashboard for container '${CONTAINER}'"
    ensure_dashboard_from_template "${CONTAINER}" "container_name='${CONTAINER}'" "false"
  done
  echo "Done"
}

function success {
  echo "$(tput setaf 2)""$*""$(tput sgr0)"
}

function info {
  echo "$(tput setaf 3)""$*""$(tput sgr0)"
}

function error {
  echo "$(tput setaf 1)""$*""$(tput sgr0)" 1>&2

}

setup_influxdb
setup_grafana
ensure_grafana_dashboards
