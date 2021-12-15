#!/bin/bash

pushd docker/htk
  docker build -t htk:latest .
popd
docker build --no-cache -t speech:latest .
