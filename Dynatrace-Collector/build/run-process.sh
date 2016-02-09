#!/bin/bash
NAME=${NAME:-"dtcollector"}
AGENT_PORT=${AGENT_PORT:-"9998"}

# We attempt to auto-discover the Dynatrace Server through the environment
# when the container has been --linked to a 'dynatrace/server' container
# instance with a link alias 'dtserver'.
#
# Example: docker run --link dtserver-1:dtserver dynatrace/collector
#
# Auto-discovery can be overridden by providing the $SERVER variable
# through the environment.
SERVER_HOST_NAME=${DTSERVER_ENV_HOST_NAME:-"docker-dtserver"}
SERVER_COLLECTOR_PORT=${DTSERVER_ENV_COLLECTOR_PORT:-"6698"}
SERVER=${SERVER:-"${SERVER_HOST_NAME}:${SERVER_COLLECTOR_PORT}"}

# Wait for the server to start serving collectors.
wait-for-cmd.sh "nc -z `echo ${SERVER} | sed 's/:/ /'`" 360

JVM_XMS=${JVM_XMS:-"2G"}
JVM_XMX=${JVM_XMX:-"2G"}
JVM_PERM_SIZE=${JVM_PERM_SIZE:-"128m"}
JVM_MAX_PERM_SIZE=${JVM_MAX_PERM_SIZE:-"128m"}

${DT}/dtcollector -instance ${NAME} \
                  -listen ${AGENT_PORT} \
                  -server ${SERVER} \
                  -Xms${JVM_XMS} \
                  -Xmx${JVM_XMX} \
                  -XX:PermSize=${JVM_PERM_SIZE} \
                  -XX:MaxPermSize=${JVM_MAX_PERM_SIZE}