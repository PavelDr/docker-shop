#!/usr/bin/env bash

PROJECT=$1
COMMAND=$2
ARGUMENTS="${@:3}"
COMPOSE_FILES="-f docker-compose.yml"

# Command that not required specify container name
EXCLUDED_COMMANDS=( stop down )

# Adding docker-compose file of requested project
if [ ! -z ${PROJECT} ]
    then

    if [[ " ${EXCLUDED_COMMANDS[*]} " != *" ${PROJECT} "* ]]; then
        COMPOSE_FILES="$COMPOSE_FILES -f projects/$PROJECT/docker-compose.yml"
        COMPOSE_FILES="$COMPOSE_FILES -f projects/$PROJECT/docker-compose.local.yml"
    fi
fi

# Adding related services projects to lara-shop project, it requires
if [ ${PROJECT} = 'lara-shop' ]
    then
    PROJECT="$PROJECT nginx-1.10 postgres-9.5 mysql-5.7 weave-scope"
fi

if [ ${PROJECT} = 'aimeos-shop' ]
    then
    PROJECT="$PROJECT nginx-1.10 postgres-9.5 mysql-5.7 weave-scope"
fi

# Check if command is not require specify container name
if [[ " ${EXCLUDED_COMMANDS[*]} " == *" ${COMMAND} "* ]]
    then
    PROJECT=''
fi

echo "Command: docker-compose -p docker ${COMPOSE_FILES} ${COMMAND} ${ARGUMENTS} ${PROJECT}"

docker-compose -p docker ${COMPOSE_FILES} ${COMMAND} ${ARGUMENTS} ${PROJECT}
