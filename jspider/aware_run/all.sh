#!/bin/bash

runs=(
  sd_hc.sh
  sd_mc.sh
  sd_lc.sh
  md_hc.sh
  md_mc.sh
  md_lc.sh
  ld_hc.sh
  ld_mc.sh
  ld_lc.sh
)

export PANDA_RUNS=10

for rn in ${runs[@]}; do
  echo "Starting ${rn}"
  $(./$rn > /dev/null)  
  echo "Completed ${rn}"
  sleep 10
done

export PANDA_RECOVER=false
for rn in ${runs[@]}; do
  echo "Starting ${rn}"
  $(./$rn "u" > /dev/null)  
  echo "Completed ${rn}"
  sleep 10
done
