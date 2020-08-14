#!/bin/sh

if [ $# -ne 1 ]; then
  echo "sd usage: [ESTIMATED_LEVEL]"
  exit
fi

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4
#jspider.sh https://angularjs.org/
jspider.sh http://api.rubyonrails.org/
mv mode.txt run_ld_${1}.txt
