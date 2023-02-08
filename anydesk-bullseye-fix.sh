#!/bin/bash

#https://www.youtube.com/watch?v=v7gHA-Laf4k
#https://download.anydesk.com/rpi/anydesk_6.2.1-1_armhf.deb

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