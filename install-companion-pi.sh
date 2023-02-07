#!/bin/bash
set -e

if [ "$(whoami)" != "root" ]; then
     echo "Run with sudo"
     exit 1
     # elevate script privileges
fi

GIT_MASTER="master"
GIT_MAIN="main" #strange movement from master to main following official instalation process
HOSTNAME="" # empty for skip or what ever you like used for access via domain hostname.local instead of ip
COMPANION_USER="companion" #maybe yoo use 'pi' but i recommend to use separate user for future auto updates by companion update feature

# enable ssh just in case
touch /boot/ssh

# change the hostname
if [ -z "$HOSTNAME" ]; then
      echo "Skip hostname"
else
      CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
      echo $HOSTNAME > /etc/hostname
      sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$HOSTNAME/g" /etc/hosts
fi
# add a system user
if ! id -u "$COMPANION_USER" >/dev/null 2>&1; then
    echo "$COMPANION_USER user missing"
    adduser --disabled-password $COMPANION_USER --gecos ""
fi

# install some dependencies
apt-get update
#apt-get upgrade --without-new-pkgs
#apt-get full-upgrade
apt-get install -y yarn git unzip curl libusb-1.0-0-dev libudev-dev cmake
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

#source /root/.bashrc

# clone the companionpi repository
rm -rf /usr/local/src/companionpi
git clone https://github.com/bitfocus/companion-pi.git -b $GIT_MAIN /usr/local/src/companionpi
cd /usr/local/src/companionpi

# configure git for future updates
git config --global pull.rebase false

# revert back to the 2.4.2
git reset --hard dd11d9c466d1fab8ff0a50f12af72fa1e4b8cfdf

# run the update script
./update.sh $GIT_MASTER

# install update script dependencies, as they were ignored
yarn --cwd "/usr/local/src/companionpi/update-prompt" install

# enable start on boot
systemctl enable companion

# run as companion user
# add the fnm node to this users path
PATH_FNM="export PATH=/opt/fnm/aliases/default/bin:\$PATH"

if grep -Fxq "$PATH_FNM" "/home/$COMPANION_USER/.bashrc"; then
    # code if found
    #su $COMPANION_USER -c "sed -i \"s/$PATH_FNM/$PATH_FNM/g\" ~/.bashrc"
    echo "Path found"
else
    # code if not found
    echo "export PATH=/opt/fnm/aliases/default/bin:\$PATH" >> /home/$COMPANION_USER/.bashrc
fi

#su $COMPANION_USER -c 'echo "export PATH=/opt/fnm/aliases/default/bin:$PATH" >> ~/.bashrc'

echo "Done. Please reboot"