#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=5
jspider.sh http://learnyouahaskell.com
mv mode.txt run_sd_lc${1}.txt
