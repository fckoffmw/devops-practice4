#!/bin/sh
set -eu
mkdir -p dist
cp src/index.html dist/index.html
printf 'project=devops-practice4\nbuild=%s\n' "${BUILD_NUMBER:-local}" > dist/build-info.txt
echo 'BUILD OK: подготовлены dist/index.html и dist/build-info.txt'
