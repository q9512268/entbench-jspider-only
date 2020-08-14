#!/bin/bash

rm -rf ./src
cp -rf ./aware src

cd src
ant clean; ant jar
cd ..
