#!/bin/bash

set -e

# Print script info if missing arguments
if [ $# -lt 1 ]; then
    echo
    echo "Usage: ./run-docker.sh DOCKERFILE [OPTION*] [-- COMMAND*]"
    echo
    echo "Builds and runs COMMAND inside a DOCKERFILE"
    echo
    echo "Options:"
    echo "  --clean             Removes the image after running"
    echo "  --args [ARG*]       List of '--build-arg' args to pass to 'docker build'"
    echo "  --volumes [MOUNT*]  List of '--volume' args to pass to 'docker run'"
    echo "  -- [COMMAND*]       Command to be executed inside DOCKERFILE image"
    echo
    echo "Automatically handles cleaning/rebuilding on changes to DOCKERFILE"
    exit 1
fi

file="$1"
shift

# Exit if Dockerfile doesn't exist
if [ ! -f "$file" ]; then
    echo "run-docker.sh: $1: No such file or directory"
    exit 1
fi

# Get all arguments
args=()
volumes=()
ctx="" # "" | args | voumes

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            clean=true
            shift
            ;;
        --args)
            ctx=args
            shift
            ;;
        --volumes)
            ctx=volumes
            shift
            ;;
        --)
            shift
            break
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            if [ -z $ctx ]; then
                echo "Unknown argument $1"
                exit 1
            fi

            eval "${ctx}+=(\"$1\")"
            shift
            ;;
    esac
done

# Create image info

mtime=$(stat -c %Y "$file")

args=$(printf "%s\n" "${args[@]}" | sort)

name=$(
    echo -n "listmonk--$(
        echo "$file" | \
            sed -E 's/\.?Dockerfile$//' | \
            sed -E 's,[/.],_,g'
    )" | \
    sed -E 's/--$//'
)

version="$mtime$(
    for arg in $args; do
        echo -n "--"
        echo -n $arg | sed -E 's/[^a-z0-9._-]/_/gi'
    done
)"

image="$name:$version"

clean() {
    images=$(docker images -q "$name" | uniq)

    if [ ! -z "$images" ]; then
        docker rmi -f "$images"
    fi;
}

# Skip build if just cleaning image
if [ ! -z $clean ] && [ $# -eq 0 ]; then
    clean
    exit
fi

# Build/rebuild image if needed
if [ -z "$(docker images -q "$image" 2> /dev/null)" ]; then
    clean

    eval "docker build . -f '$file' -t '$image'$(
        for arg in $args; do
            echo -n " --build-arg '$arg'"
        done
    )"

    docker tag "$image" "$name:latest"
fi

# Run the command if present
if [ $# -gt 0 ]; then
    if [ -t 1 ]; then
        tty="-it --rm"
    else
        tty="--rm"
    fi

    eval "docker run $tty $(
        for volume in "${volumes[@]}"; do
            echo -n " -v $volume"
        done
    ) $image $@"

    if [ ! -z $clean ]; then
        clean
    fi
fi