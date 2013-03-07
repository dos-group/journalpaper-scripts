#!/bin/bash

# Removes all files from the HDFS and stops it.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load config
. ./jp_env_configure.sh

# clean hdfs
${HDFS_BIN}/hadoop fs -rmr '/*'
echo "HDFS cleaned"

# shut down HDFS
${HDFS_BIN}/stop-dfs.sh
