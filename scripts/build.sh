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
$DOCKER_CMD curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$DOCKER_CMD add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$DOCKER_CMD apt-get update
$DOCKER_CMD apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
$DOCKER_CMD buildx build -t ${REPO}:${COMMIT} --platfrom linux,arm64,linux.amd64 --push .
echo $REPO
echo $COMMIT
