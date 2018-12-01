# Titanium Remote Clients in a Docker Container
This project builds a docker image containing the Titanium SDK, with the remote clients installed by default. 

All other SDK components, such as the configuration GUI can be installed or used from within the container. The Titanium SDK files are located in 
```
/opt
```

Requirements:
- A host computer with docker or docker-toolbox installed. This can be Linux, Windows or Mac.
    - Follow directions in https://docs.docker.com/install/ to install Docker CE on your host
    - when you can successfully run `docker hello-world` you should be good to go
- The openrc.sh file from Horizon for your Titanium project(s) 
- If your Titanium install uses https, you need the ca-cert.pem file for the server
>Note:These files need to be within the working directory tree where you start the docker container, since the container's access to the host disk is limited.


## Build and tag the Docker Image
- Clone this repo
- Open a bash shell (or docker shell on Windows) and change directory to the location of the git repo
    - you should be in the same directory as the Dockerfile, etc
- Build the image with the `build.sh` script or manually with the following command:
```
$ docker build -t tic-sdk:latest .
```
> Note: you can also create a version number in addition to `latest`, since images can have multiple tags. To do this use:
```
$ docker image tag <image-id> newtag
```


## Start the Docker container using the tic-sdk image
- Open a bash or docker shell (Windows)
- Change to the directory containing your openrc.sh, ca-cert.pem (for https installations) and any files/images you wish to transfer to your Titanium project. 
- Start the docker container from your CLI. The command syntax will vary slightly based on which shell you're using.

For bash shell on Linux, Mac or Windows (mingetty, cygwin-bash, etc)
```
docker container run --rm -it -v $(pwd):/home/wruser/host tic-sdk
```

For Windows 10 CMD shell:
```
docker container run --rm -it -v %cd%:/home/wruser/host tic-sdk
```

For Windows 10 PowerShell:
```
docker container run --rm -it -v ${pwd}:/home/wruser/host rmoorewrs/tic-sdk
```

If you have multiple openrc credentials files in a common directory, export it to the RC_DIR environment variable (change the path to match your own). For a bash shell:
```
export RC_DIR=/home/myuser/rc
docker container run --rm -it -v $(RC_DIR):/home/wruser/rc -v $(pwd):/home/wruser/host tic-sdk
```
>Note: the working directory (and its subdirectories) where you started the container will be available in the container shell as `/home/wruser/host`. Any changes made within the `host` directory will persist after the container shell exits. Any changes made elsewhere in the container shell filesystem will be lost when the container shell exits.

## Use the remote clients in the container
When the container starts, you'll have access to your current working directory which is mapped as `/home/wruser` in the container environment. 
>Note: in the container environment you will not have access to files outside of your working directory unless you map the directories in with the docker `-v` parameter.

You must source the remote client credentials each time the container starts:
```
wruser@02aff874286f:~$ source ~/rc/<myproj_>openrc.sh
```
If a ca-cert.pem certificate is required for https, you must give the entire path to the ca-cert.pem file, including the filename. Assuming you had the ca-cert.pem file in your mapped rc directory, enter:
```
/home/wruser/rc/ca-cert.pem
```
At this point, issuing a Titanium/OpenStack remote-client command should communicate with the OpenStack REST APIs just. For a test, try a few commands like:
```
wruser@02aff874286f:~/host$ glance image-list
wruser@02aff874286f:~/host$ openstack server list
```
When you're done working in the container environment, type `exit`.

>Note: On exit, the container will be deleted, this way you won't have old containers to delete later on. The image will remain in local cache and the container can be be run again with the same command line as above, but any changes made will be reset.

>Note: If you want to use a persistent container, omit the `--rm` from the command line and instead of using `docker container run` use `docker container start <container_name_or_id>` on subsequent uses.

## Notes on customizing the Image and/or Container
### Temporary or One-off Changes
If you want to add packages or customize the container temporarily, just do whatever you like to the running container. In order to use install packages, you'll need to use 'sudo' and the `wruser` user password is `wruser`. 

Example: If you want to add `vi` to the container temporarily, do this:
```
wruser@02aff874286f:~$ sudo apt install vim
```
Again, note that on exiting container, all changes will be reset and `vi` won't be installed next time the container is run.

### Permanent changes to the Image
If you want to make permanent changes to the image, you must edit the Dockerfile and then rebuild and re-tag the image. See the docker documentation for more information on how to work with Dockerfile commands:
```
https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
```

Example: If you wanted to add `vi` to the image, change this line in the Dockerfile:
```
RUN apt-get update && apt-get install -y ssh vim python python-dev python-setuptools gcc git python-pip libxml2-dev libxslt-dev libssl-dev libffi-dev libssl-dev sudo
```

to this, by adding `vim` at the end.
```
RUN apt-get update && apt-get install -y ssh vim python python-dev python-setuptools gcc git python-pip libxml2-dev libxslt-dev libssl-dev libffi-dev libssl-dev sudo vim
```
Once you re-build/re-tag the image, `vi` will be available every time the container runs.

## Exporting / Importing the images without a Docker registry
It's common practice to push an image to docker hub. If you don't want to share your image with the world, you can use a local docker registry or even save and load images into local cache directly to/from the local filesystem. 

### Setting up a local Docker registry
See the Docker site for instructions on setting up a registry. 
```
https://docs.docker.com/registry/deploying/
```
>Note: It's very easy to use a Docker registry within the confines of a single machine (e.g. localhost), but to serve up files to clients on a LAN is a little more difficult because Docker forces the use of certificates by default, so a little more work is required and is covered in the page above.

### Saving/restoring images without a Docker registry
On the machine that has the image:
```
$ image_name=myimagename
$ docker save ${image_name} > ${image_name}.tar
```

Copy the image to a new machine and load it
```
$ docker load -i ${image_name}.tar
```

## Notes for running on Windows Host
- To run docker on Windows 7 host, "Docker Toolbox" is required, which depends on VirtualBox
See:
```
https://docs.docker.com/toolbox/toolbox_install_windows/
```

- Windows 10 can run Docker natively, but requires Linux Container support to be enabled (vs Windows container support -- only one can be active at a time)
>Note: for Linux containers on Windows 10, Docker is running a Linux VM on Hyper-v behind the scenes, which may interfere with other virtualization programs like VMware or VirtualBox.

### Caveats on using Windows 7 and Docker Toolbox:
1. Directories are Limited to C:\Users
Docker Toolbox can only access directories located in C:\Users. If you start in any other directory, the files in your working directory won't be visible to the docker container.

2. No Spaces allowed in Path Name
Docker Toolbox will fail if there is a space in the path of your working directory, so make sure to pick a working directory located in `C:\Users` with no spaces.

## Links

1. https://www.ibm.com/developerworks/community/blogs/jfp/entry/Using_Docker_Machine_On_Windows?lang=en


## Log in directly to the docker VM.
If you need to log into the docker VM on Windows, you can do the following:
```
$ docker-machine ssh default
```

Alternatively you can ssh to it using:
```
$ ssh -i C:\\Users\\eraineri\\.docker\\machine\\machines\\default\\id_rsa docker@192.168.99.100
```

Use the following to get the id_rsa path:
```
$ docker-machine.exe inspect default
```
*Alternatively the password might be tcuser*

## Known issues

1. The MinGW terminal used in Docker Toolbox on Windows 7 is clunky. Cygwin bash shell can be used (64-bit), but Mobaterm with Windows 7 does not (32 bit application)
2. Running the container as root and using the /root directory is not allowed
