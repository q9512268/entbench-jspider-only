#!/bin/bash

if [ ! -f ./src/aware ]; then
  echo "current source is not aware"
  exit
fi 

./bak.sh
rm -rf ./aware
cp -rf ./src ./aware
