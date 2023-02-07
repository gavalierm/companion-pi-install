#!/bin/bash
set -e

if [ "$(whoami)" != "root" ]; then
     echo "Run with sudo"
     exit 1
     # elevate script privileges
fi

#bullseye anydesk?
apt-get install -y -f libgles-dev libegl-dev

ls /usr/lib/arm-linux-gnueabihf/libGLE*

ln -s /usr/lib/arm-linux-gnueabihf/libGLESv2.so /usr/lib/libbrcmGLESv2.so

ls /usr/lib/arm-linux-gnueabihf/libEGL*

ln -s /usr/lib/arm-linux-gnueabihf/libEGL.so /usr/lib/libbrcmEGL.so