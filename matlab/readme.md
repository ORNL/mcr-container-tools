# MCR Docker image

## Overview
This image facilitates the running of applications compiled with the [MATLAB Compiler](https://www.mathworks.com/products/compiler.html) via the [MATLAB Compiler Runtime (MCR)](https://www.mathworks.com/products/compiler/matlab-runtime.html) in a [Community Enterprise Linux (CentOS) 7](https://www.centos.org/) [Docker container](https://www.docker.com/what-container).

## Building an Image
By default, the current dockerfile will deploy all available dependencies required to execute applications compiled with release 2016a of the MATLAB Compiler Toolbox in CentOS 7:
`docker build -t mcr-centos7 -f mcr-centos7.dockerfile .`

### Different MCR Versions
The dockerfile was created with MCR version flexibility in mind.  To our knowledge, MATHWORKS doesn't provide a comprehensive list of dependencies required by the MCR, and these dependencies can change between releases, [as discussed in the MATLAB Answers forum](https://www.mathworks.com/matlabcentral/answers/358052-is-there-a-list-of-matlab-runtime-dependencies).  Therefore, a script to determine which dependencies are required is provided (see 'util/readme.md' for details); one can use information provided by said script to override select dockerfile arguments (see 'Dockerfile build variable' section below) based on one's MCR version needs.

### Dockerfile build variables
By altering the following variables via the '--build-arg' flag to the 'docker build' command, one can change the version of the MCR deployed inside the docker image, as well as the packages installed in the environment.  See the 'mcr_dependencies.md' file for a list of known dependencies for various MCR versions.  
* 'MCR\_REL':  The 'release' of the MCR, e.g. 'R2017b' for MATLAB 2017b, as listed on the MCR download page.
* 'MCR\_VER':  The 'MATLAB Runtime Version' (without decimal points) of the MCR, e.g. '93' for MCR\_REL 2017b, located inside the parenthesis on the MCR download page.
* 'MCR\_DEPS':  The list of packages, managed by YUM, that are to be deployed
* 'HOST_UID': Container's runtime User (numeric) ID (defaults to root)
* 'HOST_GID'): Container's runtime Group (numeric) ID (defaults to root)

## Usage Examples
There exists a variety of combinations in which one can invoke this image:  
* User:  root or a specified user / group (e.g. to maintain file permissions on a mounted volume)
* X:  With or without x-forwarding to the host (e.g. to use a GUI)
* Interactive:  Interactive shell or script (e.g. automate a task)

### Interactive Shell with root
 One can use a root shell by running with the following parameters:
```shell
docker run --rm -it \
 --entrypoint /bin/bash \
 mcr-centos7
```

### Interactive Shell with the host's user / group
The container can enter a regular user's shell by inheriting the host's user id number (UID) and group id number (GID):
```shell
docker run --rm -it \
 -e HOST_UID=`id -u` -e HOST_GID=`id -g` \
 mcr-centos7
```

### X Support
X-fowarding to the host can be enabled with the following, [based on this guide](http://wiki.ros.org/docker/Tutorials/GUI):  
```shell
XAUTH=`mktemp`
XSOCK=/tmp/.X11-unix
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
docker run --rm -it \
 -e HOST_UID=`id -u` -e HOST_GID=`id -g` \
 -v ${XSOCK}:${XSOCK}:rw -v ${XAUTH}:${XAUTH}:rw \
 -e "XAUTHORITY=${XAUTH}" -e "DISPLAY" \
 mcr-centos7
 ```

### Non-Interactive (execute a script)
This example shows how to execute a script via the container:   
```shell
docker run --rm \
 mcr-centos7 \
 '/usr/local/bin/discoverDeps.sh -l -p /usr/local/MATLAB/MATLAB_Runtime'
 ```
 