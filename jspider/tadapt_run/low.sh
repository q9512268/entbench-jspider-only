#!/bin/sh

dir=`dirname "$0"`

#jspider.sh http://docs.idris-lang.org/en/latest/index.html
export PANDA_JSPIDER_MODE=low
jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv $dir/mode.txt $dir/low_level_mode.txt
