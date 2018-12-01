#!/bin/sh
# run the tic remote client shell
docker container run --rm -it -v $RC_DIR:/home/wruser/rc -v $(pwd):/home/wruser/host tic-sdk:latest
