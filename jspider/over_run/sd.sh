#!/bin/sh

if [ $# -ne 1 ]; then
  echo "sd usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_BATTERY_RUN=true
export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4
jspider.sh http://learnyouahaskell.com
mv mode.txt run_sd_${1}.txt
