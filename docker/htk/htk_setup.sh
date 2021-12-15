#!/bin/bash

tar -xzf htk.tar.gz

DIRS=("HTKLib" "HLMLib" "HTKTools" "HLMTools")

for i in ${!DIRS[@]}
do
  DIR="htk/${DIRS[$i]}"
  pushd $DIR
    make -f MakefileCPU all
  popd
done

for i in ${!DIRS[@]}
do
  DIR="htk/${DIRS[$i]}"
  pushd $DIR
    make -f MakefileCPU install
  popd
done
