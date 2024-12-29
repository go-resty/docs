#!/usr/bin/env bash

# Versions
# 1.0.0 Initial script

echo 'Starting resty docs publish process ...'

echo 'Cleanup ...'
yes | rm -rf public/
yes | rm -rf resources/_gen/

echo 'Run hugo publish ...'
hugo --gc --minify

echo 'Copy required files into public/'
cp -rp resty/public/ public/

echo 'Delete .DS_Store files ...'
find public/ -type f -name '.DS_Store' -delete

echo 'Publish process completed.'