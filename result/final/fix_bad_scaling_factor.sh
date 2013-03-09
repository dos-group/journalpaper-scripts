#!/bin/bash

# I had to add this script because in the first set of experiments the scaling factor
# was reduced by a factor of 4 compared to the original value, which was equal to the
# DOP in the system (e.g. 40 parallel tasks => SF is 40).
#
# This small script merely divides original SF value by four and renames the 
# experiment folder.
for path in $(find .. -mindepth 2 -maxdepth 2 -type d); do
    baseName=$(basename $path)
    dirName=$(dirname $path)
    prefix=${baseName:0:15}
    dopOld=${baseName:15:4}
    dopNew=$(expr $dopOld / 4 )
    suffix=${baseName:19:10}
    git mv ${dirName}/${prefix}${dopOld}${suffix} ${dirName}/${prefix}$(printf "%04d" ${dopNew})${suffix}
#   ln -s ${dirName}/${prefix}$(printf "%04d" ${dopNew})${suffix}
done
