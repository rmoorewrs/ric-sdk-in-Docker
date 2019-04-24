#!/bin/sh
pip install --upgrade pip
pip install pysocks
pip install requests[socks]
cd /opt
tar zxvf ${FILES}/${SDK_VERSION}.tgz
rm ${FILES}/${SDK_VERSION}.tgz
cd ${SDK_VERSION}
tar zxvf ${REMOTE_CLIENT_VERSION}.tgz
cd ${REMOTE_CLIENT_VERSION}
/bin/sh install_clients.sh -s
cd ..
rm -Rf ${REMOTE_CLIENT_VERSION}
openstack complete | sudo tee /etc/bash_completion.d/openstack.bash_completion > /dev/null