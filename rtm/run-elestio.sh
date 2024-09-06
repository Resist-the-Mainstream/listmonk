#!/bin/bash

cd "$(dirname "$0")/.."

run_docker="bash rtm/run-docker.sh Dockerfile \
    --volumes ./uploads:/listmonk/uploads"

if [ "$1" = "--clean" ]; then
    eval "$run_docker --clean"
else
    eval "$run_docker -- $@"
fi
