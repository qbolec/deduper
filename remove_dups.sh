#!/bin/bash
# feed in the duplicates.filenames file with < please
tr '\n' '\0' | xargs -0 -n1 rm
