#!/bin/sh
# Build the docker images
docker build -t tic-sdk:latest .
docker build -f Dockerfile.config-gui -t tic-config-gui:latest .