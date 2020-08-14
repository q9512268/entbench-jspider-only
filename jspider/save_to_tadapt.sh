#!/bin/bash

if [ ! -f ./src/tadapt ]; then
  echo "current source is not tadapt"
  exit
fi 

./bak.sh
rm -rf ./tadapt
cp -rf ./src ./tadapt
