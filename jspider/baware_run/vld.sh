#!/bin/sh

if [ $# -ne 1 ]; then
  echo "sd usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=5

export PANDA_RUNS=11
export ENT_BATTERY_LEVEL=0.90

jspider.sh https://angularjs.org/
mv mode.txt run_vld_${1}.txt
