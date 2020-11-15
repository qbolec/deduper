# deduper
A simple tool for finding duplicated files, removing them, and replacing with symbolic links

# Usage

First step is to scan a set of directories to list the duplicates.
This script doesn't delete any files, and thus is safe to run (unless you have newline characters in filenames, in which case it can probably do strange things. Spaces are ok though). 
```
./deduper.sh "/path to/first dir/" second/path ./third/path
```

The order in which you specify the directories matters - if a file is found in more than one of the directories, the first directory on the list which contains the file will be considered the original for this file, and the later as duplicate(s).

The script will generate three files you might want to inspect before proceeding:

 - duplicates.sizes contains files determined to be duplicates, sorted desceding by size in bytes which is the first column
 - duplicates.filanemes is the list of duplicates without sizes in the order found (basically second column of duplicates.sizes, but seems to encode filenames differently in some cases)
 - duplicates.pairs is a list of pairs of `Original:` filename and `Duplicate:`, with their (equal) MD5 hashes

Next, if you verified that files listed in `duplicates.filenames` are indeed safe to delete, you might delete them with
```
./remove_dups.sh < ./duplicates.filenames
```

Finally, if you are on system which supports symlinks (so, Git Bash on Windows will not work as expected as it will copy files instead of linking) you can put symlinks in place of deleted duplicates linking back to original file.
```
./link_dups.sh < ./duplicates.pairs
```
