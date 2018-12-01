# Titanium GUI tools in a Docker Container
This project builds a docker image containing the Titanium SDK, with the GUI tools installed by default. 

Requirements:
- A host computer with docker installed. This can be Linux, Windows or Mac.
    - Follow directions in https://docs.docker.com/install/ to install Docker CE on your host
    - when you can successfully run `docker hello-world` you should be good to go
- If your Titanium install uses https, you need the ca-cert.pem file for the server
- The tci-sdk image must be built.  See README.md for details.
>Note:These files need to be within the working directory tree where you start the docker container, since the container's access to the host disk is limited.


## Build and tag the Docker Image
- Clone this repo
- Open a bash shell (or docker shell on Windows) and change directory to the location of the git repo
    - you should be in the same directory as the Dockerfile, etc
- See the readme.md file for building the initial tic-sdk image.
- Once the tic-sdk image is built you can add the gui tools by building this image.  Use the following command:
```
$ docker build -f Dockerfile.config-gui -t tic-config-gui:latest .
```
> Note: you can also create a version number in addition to `latest`, since images can have multiple tags. To do this use:
```
$ docker image tag <image-id> newtab
```

## Start the Docker container
- Open a bash or docker shell (Windows)
- Change to the directory containing your openrc.sh, ca-cert.pem (for https installations) and any files/images you wish to transfer to your Titanium project. 
- Start the container with this command:
For Windows:
>The IP ADDRESS of the DISPLAY command is hosts IP address.  For Windows this is the Virtual Box or Azure IP address.
```
$ docker container run --rm -it -e DISPLAY=192.168.99.1:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/home/wruser/host tic-config-gui
```

For Linux:
```
$ docker container run --rm -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/home/wruser/host tic-config-gui
```