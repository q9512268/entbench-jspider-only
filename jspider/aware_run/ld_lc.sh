#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=5
jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv mode.txt run_ld_lc${1}.txt
