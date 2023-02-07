# companion-pi-install

Disclaimer: Because CompanionPi do not have any official "Manual instalation" manual, thats is "easy to read" i decided to craeate simple skript to install Companion on RPI(4). (matched my needs, but is very simple to modify..),

(if you dont have RPI up n running)
Create Pi image from Pi Imager.

In Pi imager settings enable ssh, set vnc resolution, setup wifi and so on..

After install and boot an login into your Pi, clone this repo into Pi


Recommended update and upgrade you RPI!
sudo apt-get update
sudo apt-get upgrade

And after all run install script with

sudo bash install-companion-pi.sh

If you get some issue please open the ticket.
