#!/bin/sh
pip install pysocks
pip install requests[socks]
cd /opt
tar zxvf ${FILES}/${SDK_VERSION}.tgz
rm ${FILES}/${SDK_VERSION}.tgz
cd Titanium-Cloud-SDK-18.03-b11
tar zxvf ${REMOTE_CLIENT_VERSION}.tgz
cd ${REMOTE_CLIENT_VERSION}
/bin/sh install_clients.sh -s
cd ..
rm -Rf ${REMOTE_CLIENT_VERSION}
