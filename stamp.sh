#!/bin/bash

benchmarks=(
  sunflow
  jspider
  crypto
  findbugs
  pagerank
  batik
)

dirs=(
  adapt_run
  baware_run
)

if [ $# -ne 1 ]; then
  echo "stamp usage: [STAMP DIR]"
  exit
fi

for b in ${benchmarks[@]}; do
  for d in ${dirs[@]}; do
    mkdir ${b}/${d}/${1}
    cp ${b}/${d}/*.txt ${b}/${d}/${1}
  done
done
