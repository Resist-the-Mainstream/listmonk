#!/bin/bash

cd "$(dirname "$0")/.."

docker_compose="docker compose"

case "$1" in
	"--build")
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
