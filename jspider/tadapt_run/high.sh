#!/bin/sh

dir=`dirname "$0"`

export PANDA_JSPIDER_MODE=high
jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv $dir/mode.txt $dir/high_level_mode.txt
