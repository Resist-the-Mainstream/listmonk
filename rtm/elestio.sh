#!/bin/bash

cd "$(dirname "$0")/.."

docker_compose="docker compose \
	--project-name rtm-elestio-listmonk \
	--file rtm/elestio.docker-compose.yml \
	--env-file .env \
	--project-directory rtm"

case "$1" in
	"--build")
		rtm/build.sh
		rtm/run-elestio.sh
		eval "$docker_compose build"
		;;
	"--up")
		eval "$docker_compose up -d"
		;;
	"--down")
		eval "$docker_compose down"
		;;
	*)
		echo "Unknown option $1" 
		exit 1
		;;
esac
