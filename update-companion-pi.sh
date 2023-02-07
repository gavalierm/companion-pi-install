#!/bin/bash
set -e

if [ "$(whoami)" != "root" ]; then
     echo "Run with sudo"
     exit 1
     # elevate script privileges
fi

apt-get update

#run update
companion-update

echo "++++++++++++++++++++++++++";
echo "It fails right? This is expected";
echo "++++++++++++++++++++++++++";
sleep 2

DST_PATH="/usr/local/src/companionpi"

cd $DST_PATH

git stash

# revert back to the 2.4.2
#git reset --hard dd11d9c466d1fab8ff0a50f12af72fa1e4b8cfdf

# run as companion user
# add the fnm node to this users path
LINE_A="    export NODE_OPTIONS=--max-old-space-size=8192 # some pi's run out of memory"
LINE_B="    #export NODE_OPTIONS=--max-old-space-size=8192 # some pi's run out of memory #GAVO"

if grep -Fxq "$LINE_A" "$DST_PATH/update.sh"; then
     echo "LINE found"
     cp $DST_PATH/update.sh ~/update_bak.sh
     # code if found
     sed -i "s/$LINE_A/$LINE_B/g" $DST_PATH/update.sh
fi

companion-update