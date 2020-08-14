#!/bin/sh

if [ $# -ne 1 ]; then
  echo "sd usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4

export PANDA_RUNS=1
export ENT_BATTERY_LEVEL=0.90
export PANDA_RECOVER=false

jspider.sh http://api.rubyonrails.org/  > /dev/null
mv mode.txt run_ld_${1}.txt
