#!/bin/bash

REGISTRY='ghcr.io'
IMAGE_NAME='xs-mlvp/envbase'
IMAGE_TAG='latest'

# Build the base image
sudo docker build \
    --network host \
    -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
    -f docker/Dockerfile \
    .