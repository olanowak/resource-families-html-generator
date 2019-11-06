#!/bin/bash

git config --global user.email "CI-Bot@travis.com"
git config --global user.name "Travis Bot"

# prepare dir 
mkdir tables

# generate tables
generation_failed=false
./generate-tables.sh
echo "generation exited with $?"

# check if generated exited with 0
if [ $?!=0 ]; then
       generation_failed=true
fi      

# check if correct branch
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "dev" ]; then exit 0; fi
echo Tables generated

# deploy to gh-pages
cd tables
git init
git add .
git commit -m "Deploy tables"
git push --force https://${GITHUB_TOKEN}:x-oauth-basic@github.com/clarin-eric/resource-families-html-generator.git HEAD:gh-pages

# if one of corporas failed to generate exit with 1
if [ $generation_failed ]; then
	exit 1
fi
