#!/bin/bash

dir=`dirname "$0"`

runs=(
  ld.sh
  md.sh
  sd.sh
)

contexts=(
  hc
#  mc
#  lc
)

blevels=(
  0.90
#  0.70
#  0.40
) 

export PANDA_RUNS=11

for i in `seq 0 2`; do
  export ENT_BATTERY_LEVEL=${blevels[$i]}

  for rn in ${runs[@]}; do
    echo "Starting ${contexts[$i]} ${rn}"
    $(./$rn ${contexts[$i]} >/dev/null)  
    echo "Completed ${contexts[$i]} ${rn}"
  done
done

#jspider.sh http://synergyendwell.com
#jspider.sh http://www.organicyogajcny.com/ 
#jspider.sh http://learnyouahaskell.com
