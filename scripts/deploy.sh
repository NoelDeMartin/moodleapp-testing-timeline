#!/usr/bin/env bash

# abort on errors
set -e

# build
rm -rf dist
npm run build

# navigate into the build output directory
cd dist

# prepare github pages
touch .nojekyll

# publish
git init
git checkout -b main
git add -A
git commit -m 'deploy'
git push -f "git@github.com:noeldemartin/moodleapp-testing-timeline.git" main:gh-pages

cd -
