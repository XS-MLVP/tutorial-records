#!/bin/bash

# whereis this script located?
PATH_TO_SCRIPT=$(dirname "$(readlink -f "$0")")
${PATH_TO_SCRIPT}/build-base.sh

REGISTRY='ghcr.io'
IMAGE_NAME='xs-mlvp/envfull'
IMAGE_TAG='latest'

# Build the full image
sudo docker build \
    --network host \
    -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
    -f docker/Dockerfile.full \
    .