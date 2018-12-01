#!/bin/sh
set -x
apt-get update
apt-get install -y python-wxtools 
cd /usr/lib/python2.7/dist-packages
tar xf ${CONFIG_TARBALL}
cd configutilities
python setup.py install
rm -rf /var/lib/apt/lists/*
set +x