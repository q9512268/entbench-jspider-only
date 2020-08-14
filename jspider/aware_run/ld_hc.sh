#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=3
jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv mode.txt run_ld_hc${1}.txt
