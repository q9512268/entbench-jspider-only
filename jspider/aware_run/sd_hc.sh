#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=3
jspider.sh http://learnyouahaskell.com
mv mode.txt run_sd_hc${1}.txt
