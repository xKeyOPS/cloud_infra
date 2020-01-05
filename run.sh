#!/bin/bash

set -e
NAME="ansible-lint"
IMAGE_NAME=yokogawa/${NAME}
docker ps --quiet --all --filter name=${NAME} | xargs -r docker rm >/dev/null

set -x
if [ "${1}" = "bash" ]; then
    docker run -v ${PWD}:/work -i -t --name=${NAME} ${IMAGE_NAME} sh
else
    docker run -v ${PWD}:/work -w /work --name=${NAME} ${IMAGE_NAME} ansible-lint $@
fi