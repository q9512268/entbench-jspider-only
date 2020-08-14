#!/bin/sh

if [ $# -ne 1 ]; then
  echo "md usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4

jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv mode.txt run_md_${1}.txt
