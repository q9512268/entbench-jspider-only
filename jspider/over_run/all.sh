#!/bin/bash

dir=`dirname "$0"`

if [ $# -ne 1 ]; then
  echo "sd usage: [ESTIMATED_LEVEL]"
  exit
fi

level=$1 

runs=(
  sd.sh
  md.sh
  ld.sh
)

export PANDA_RUNS=10

for rn in ${runs[@]}; do
  echo "Starting ${rn}"
  $(./$rn $1 > /dev/null)  
  echo "Completed ${rn}"
  sleep 10
done

export PANDA_RECOVER=false
for rn in ${runs[@]}; do
  echo "Starting ${rn}"
  $(./$rn ${1}u > /dev/null)  
  echo "Completed ${rn}u"
  sleep 10
done
