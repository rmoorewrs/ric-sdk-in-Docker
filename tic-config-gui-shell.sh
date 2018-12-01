#!/bin/sh
# run the tic config-gui shell, also includes remote clients
docker container run --rm -it -e DISPLAY=$DISPLAY -v $RC_DIR:/home/wruser/rc -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/home/wruser/host tic-config-gui:latest
