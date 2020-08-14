#!/bin/bash

rm -rf ./src
cp -rf ./adapt src

cd src
ant clean; ant jar
cd ..
