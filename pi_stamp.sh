#!/bin/bash

benchmarks=(
  camera
  video
  crypto
  sunflow
)

dirs=(
  badapt_run
  baware_run
)

if [ $# -ne 1 ]; then
  echo "pi_stamp usage: [STAMP DIR]"
  exit
fi

for b in ${benchmarks[@]}; do
  for d in ${dirs[@]}; do
    mkdir pi_bench/${b}/${d}/${1}
    cp pi_bench/${b}/${d}/*.txt pi_bench/${b}/${d}/${1}
  done
done
