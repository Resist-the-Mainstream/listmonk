#!/bin/bash

cd "$(dirname "$0")/.."

if [ "$1" = "--clean" ]; then
    rm -f listmonk
    rm -rf frontend/node_modules
    rm -rf frontend/dist
    rtm/run-dev.sh --clean
else
    rtm/run-dev.sh make .rtm-build
fi