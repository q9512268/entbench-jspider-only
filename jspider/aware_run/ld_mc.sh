#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4
jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv mode.txt run_ld_mc${1}.txt
