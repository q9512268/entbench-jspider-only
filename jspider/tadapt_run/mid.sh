#!/bin/sh

dir=`dirname "$0"`

export PANDA_JSPIDER_MODE=mid
jspider.sh http://docs.idris-lang.org/en/latest/index.html
mv $dir/mode.txt $dir/mid_level_mode.txt
