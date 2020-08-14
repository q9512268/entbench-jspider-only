#!/bin/sh

if [ $# -ne 1 ]; then
  echo "sd usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_RUNS=11

export PANDA_BATTERY_RUN=true
export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4
export ENT_BATTERY_LEVEL=0.70

#jspider.sh http://docs.idris-lang.org/en/latest/index.html
#mv mode.txt run_md_${1}_ent.txt

jspider.sh http://docs.idris-lang.org/en/latest/index.html > /dev/null
#mv mode.txt run_md_${1}_java.txt
mv mode.txt run_md_${1}_ent.txt

#jspider.sh http://synergyendwell.com
#mv mode.txt run_md_${1}_java.txt
