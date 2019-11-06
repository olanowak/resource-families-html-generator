#!/bin/bash

corpora_failed=false

for D in ./resource_families/*/; do
        [ -d "$D" ] && ! ./run.py -i "$D" -o "$D" -r ./rules.json && corpora_failed=true
done
for D in ./tables/*; do echo $D > 1>&2; done

if $corpora_failed; then
        exit 1
fi

