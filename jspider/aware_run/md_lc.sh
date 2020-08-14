#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=5
jspider.sh http://synergyendwell.com
mv mode.txt run_md_lc${1}.txt
