#!/bin/bash

if [ ! -f ./src/adapt ]; then
  echo "current source is not adapt"
  exit
fi 

./bak.sh
rm -rf ./adapt
cp -rf ./src ./adapt
