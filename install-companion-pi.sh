#!/usr/bin/env bash
set -e

if [ "$(whoami)" != "root" ]; then
     echo "Run with sudo"
     exit 1
     # elevate script privileges
fi

UPDATE_BRANCH="master"
GIT_BRANCHE="main"
HOSTNAME="atemrpi"
COMPANION_USER="companion"

# enable ssh
touch /boot/ssh

# change the hostname
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
echo $HOSTNAME > /etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$HOSTNAME/g" /etc/hosts

# add a system user
adduser --disabled-password $COMPANION_USER --gecos ""

# install some dependencies
apt-get update
apt-get full-upgrade
apt-get install -y git unzip curl libusb-1.0-0-dev libudev-dev cmake
apt-get clean

# run as root
#/bin/bash -e

# install fnm to manage node version
# we do this to /opt/fnm, so that the companion user can use the same installation
export FNM_DIR=/opt/fnm
echo "export FNM_DIR=/opt/fnm" >> /root/.bashrc
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir /opt/fnm
export PATH=/opt/fnm:$PATH
eval "`fnm env --shell bash`"

# clone the companionpi repository
git clone https://github.com/bitfocus/companion-pi.git -b $GIT_BRANCHE /usr/local/src/companionpi
cd /usr/local/src/companionpi

# configure git for future updates
git config --global pull.rebase false

# revert back to the 2.4.2
git reset --hard dd11d9c466d1fab8ff0a50f12af72fa1e4b8cfdf

# run the update script
./update.sh $UPDATE_BRANCH

# install update script dependencies, as they were ignored
yarn --cwd "/usr/local/src/companionpi/update-prompt" install

# enable start on boot
systemctl enable companion

# run as companion user
# add the fnm node to this users path
su $COMPANION_USER -c 'echo "export PATH=/opt/fnm/aliases/default/bin:\\$PATH" >> ~/.bashrc'
