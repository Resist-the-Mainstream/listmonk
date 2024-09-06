#!/bin/bash

cd "$(dirname "$0")/.."

run_docker="bash rtm/run-docker.sh rtm/dev.Dockerfile \
    --args UID=$(id -u) GID=$(id -g) \
    --volumes '.:/app'"

if [ "$1" = "--clean" ]; then
    eval "$run_docker --clean"
else
    eval "$run_docker -- $@"
fi
