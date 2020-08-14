#!/bin/sh

export PANDA_JSPIDER_INTERVAL=250
export PANDA_JSPIDER_DEPTH=4
jspider.sh http://learnyouahaskell.com
mv mode.txt run_sd_mc${1}.txt
