#!/usr/bin/env bash
set -o errexit -o nounset

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

git checkout -b gh-pages
git add .
git commit -m "Travis build: $TRAVIS_BUILD_NUMBER"

git remote add origin-pages https://$GH_TOKEN@github.com/socallinuxexpo/scale-av-web.git > /dev/null 2>&1
git push -f origin-pages gh-pages
