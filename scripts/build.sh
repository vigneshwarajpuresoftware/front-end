#!/usr/bin/env bash

set -ev

SCRIPT_DIR=$(dirname "$0")

if [[ -z "$GROUP" ]] ; then
  echo "Cannot find GROUP env var"
  exit 1
fi

if [[ -z "$COMMIT" ]] ; then
  echo "Cannot find COMMIT env var"
  exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  DOCKER_CMD=docker
else
  DOCKER_CMD="sudo docker"
fi

CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR

REPO=${GROUP}/$(basename front-end);
$DOCKER_CMD run --rm --privileged multiarch/qemu-user-static --reset -p yes
$DOCKER_CMD --version
$DOCKER_CMD login --username=ajv21 -p=Jun21@2021
$DOCKER_CMD buildx create --name frontendbuildkit
$DOCKER_CMD buildx use frontendbuildkit
$DOCKER_CMD buildx inspect --bootstrap
$DOCKER_CMD buildx build -t ajv21/frontend:shellscript --platform linux/arm64,linux/amd64 --push .
$DOCKER_CMD buildx rm frontendbuildkit
$DOCKER_CMD logout
echo $REPO
echo $COMMIT
