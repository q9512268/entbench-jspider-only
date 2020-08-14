#!/bin/sh

if [ $# -ne 1 ]; then
  echo "md usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4

export PANDA_RUNS=1
export ENT_BATTERY_LEVEL=0.90

# 2089
# 991

jspider.sh http://docs.idris-lang.org/en/latest/index.html > /dev/null
mv mode.txt run_md_${1}.txt
