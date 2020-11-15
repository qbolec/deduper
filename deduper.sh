#!/bin/bash
echo searching for duplicates in "$@";

find "$@" -type f -size +1M -print0 | # find large files and print their name separated by \0 char
xargs -0 -n100 md5sum | # read filenames separated by \0, group them by at most 100 and compute their hashes
sed -r 's/([a-f0-9]{32})[* ]*/\1 /g' | # md5sum might've put * in between hash and filename
sort -s -k1,1 | # sort by hash, keeping the original relative order of files with same hash 
awk '''
{
  if ($1==last_hash) {
    print "Original: " last_file
    print "Duplicate: " $0
  } else {
    last_hash = $1 
    last_file = $0
  }
}
''' | # for each duplicated hash output two lines with Original and Duplicate lines
tee duplicates.pairs | # save result at this stage (two lines per duplicate)
grep '^Duplicate:' | # now focus on lines with Duplicates
cut -d ' ' -f 3- | # remove first two fields delimited by space (label and hash), keep just the filename (which might contain spaces)
tee duplicates.filenames | # save result at this stage (just the filenames to delete, one per line)
tr '\n' '\0' | # change the newline delimiter to \0 (hopefully there are no newlines in filenames)
xargs -0 -n100 ls -1 -s --block-size=1 | # read filenames separated by '\0', group them by 100, list size expressed in bytes of each file in separate line
sort -nr -k1,1 | # sort by first column numerically in reverse (descending) order
tee duplicates.sizes | # save result at this stage (size and filename sorted by size descending)
awk '{s+=$1} END {printf "Total gain %.3f GB\n", s/1024/1024/1024}' # sum the sizes of all duplicates and report them in GB with 3 places after comma (MB precission)

