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
    prefix=${baseName:0:12}
    dop=${baseName:17:2}
    if [[ $dop == "08" ]]; then
        dop=8
    fi
    dop=$(( $dop / 1 ))
    sf=$(( $dop / 4 ))
    suffix=${baseName:19:10}
    echo git mv ${dirName}/${prefix}$(printf "dop%04d" ${dop})${suffix} ${dirName}/${prefix}$(printf "sf%04d-dop%04d" ${sf} ${dop})${suffix}
    if [[ ! ${sf} -eq 32 ]]; then
        echo unlink ${prefix}$(printf "dop%04d" ${dop})${suffix}
        echo ln -s ${dirName}/${prefix}$(printf "sf%04d-dop%04d" ${sf} ${dop})${suffix}
    fi
done
