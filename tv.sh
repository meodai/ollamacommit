#!/bin/bash

echo "Fetching new playlist"
TVCURL=$(curl --fail https://api.init7.net/tvchannels.xspf -o ~/Movies/Fiber7.TV.tmp.xspf)
if [[ $TVCURL ]]; then
  echo "Refreshing playlist"
  if [[ -e ~/Movies/Fiber7.TV.xspf ]]; then
    rm ~/Movies/Fiber7.TV.xspf
  fi
  if [[ -e ~/Movies/Fiber7.TV.tmp.xspf ]]; then
    mv ~/Movies/Fiber7.TV.tmp.xspf ~/Movies/Fiber7.TV.xspf
  fi
else
  echo "Fetching new playlist failed, using cached one"
fi
open -a vlc ~/Movies/Fiber7.TV.xspf
#/Applications/VLC.app/Contents/MacOS/VLC -I rc ~/Movies/Fiber7.TV.xspf
