#!/bin/sh
set -eu
test -s dist/index.html
grep -q '<title>DevOps Practice 4</title>' dist/index.html
grep -q 'CI/CD' dist/index.html
test -s dist/build-info.txt
echo 'TEST OK: артефакт существует, заголовок и содержимое корректны'
