#!/bin/bash

cd "$(dirname "$0")/.."

docker_compose="docker compose \
	--project-name rtm-dev-listmonk \
	--file rtm/dev.docker-compose.yml \
	--env-file rtm/dev.env \
	--project-directory rtm"

if [ "$1" = "--clean" ]; then
    rtm/run-dev.sh
    eval "$docker_compose down -v --remove-orphans"
    rm -rf frontend/node_modules
    rm -rf frontend/dist
    rtm/run-dev.sh --clean
else
    rtm/run-dev.sh make .rtm-dev
    eval "$docker_compose up"
fi