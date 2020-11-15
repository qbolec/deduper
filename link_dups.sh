#!/bin/bash
# feed in the duplicates.pairs file with < please

cut -d ' ' -f 3- |
tr '\n' '\0' |
xargs -0 -n2 ln -sr
