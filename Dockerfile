FROM ubuntu:16.04
MAINTAINER  Rich Moore, rmoorewrs@gmail.com

# Build instructions:
# After cloning repo, cd into directory with this file and run:
# $ docker build -t tic-sdk:latest .

# Container Usage:
# Copy any openrc credentials files into your current working directory before running the container.
# Start the container with this command line:
# $ docker container run --rm -it -v $(pwd):/home/wruser tic-sdk

USER root
# set up the SDK, etc
ENV SDK_VERSION Titanium-Cloud-SDK-18.03-b11
ENV REMOTE_CLIENT_VERSION wrs-remote-clients-2.0.2
ENV INST_DIR /opt/install
ENV HOME_DIR /home/wruser
ENV SDK_DIR /opt/${SDK_VERSION}
ENV SCRIPTS ${INST_DIR}/scripts
ENV FILES ${INST_DIR}/files
ADD . ${INST_DIR}
RUN chmod +x ${SCRIPTS}/install-remote-clients.sh ${SCRIPTS}/install-config-gui.sh

# install dependencies, install remote_clients, cleanup
RUN apt-get update && \
apt-get install -y  ssh python \
python-dev python-setuptools gcc git python-pip \
libxml2-dev libxslt-dev libssl-dev libffi-dev libssl-dev sudo locales-all localehelper && \
pip install ruamel.yaml && \
${SCRIPTS}/install-remote-clients.sh && \
rm -rf /var/lib/apt/lists/*
RUN useradd -m -s $(which bash) -G sudo wruser
RUN echo 'wruser:wruser' |chpasswd
RUN chmod +x ${SCRIPTS}/install-remote-clients.sh ${SCRIPTS}/install-config-gui.sh
RUN mkdir -p ${HOME_DIR}/bin && mkdir -p ${HOME_DIR}/host
RUN cp ${SCRIPTS}/bashrc /home/wruser/.bashrc && cp ${SCRIPTS}/* /home/wruser/bin


USER wruser
ENV LANG=en_US.UTF-8
WORKDIR ${HOME_DIR}/host

