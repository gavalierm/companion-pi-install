# companion-pi-install

Create Pi image from Pi Imager.

You can use lates Bullseye but can have some strange issues

Or you can select Buster.

In Pi imager settings enable ssh, set vnc resolution, setup wifi and so on..

After install and boot an login into your Pi, clone this repo into Pi

Instal update of your Pi

sudo apt-get update
sudo apt-get upgrade

On RPI 3 run

sudo rpi-update && sudo reboot



And after all run install script with sudo bash install-companion-pi.sh
