#!/bin/bash

git config --global user.email "CI-Bot@travis.com"
git config --global user.name "Travis Bot"

# generate tables
mkdir tables
corpora_failed=false

for D in ./resource_families/*/; do
        [ -d "$D" ] && ! ./run.py -i "$D" -o "$D" -r ./rules.json && corpora_failed=true
done
for D in ./tables/*; do echo $D; done

if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then exit 0; fi
echo Tables generated
# deploy
cd tables
git init
git add .
git commit -m "Deploy tables"
git push --force https://${GITHUB_TOKEN}:x-oauth-basic@github.com/clarin-eric/resource-families-html-generator.git HEAD:gh-pages


if $corpora_failed; then
        exit 1
fi

