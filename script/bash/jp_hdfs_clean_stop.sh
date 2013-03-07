#!/bin/bash

# Removes all files from the HDFS and stops it.
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)

# load config
. ./jp_env_configure.sh

# clean HDFS
${HDFS_BIN}/hadoop fs -rmr '/*'
echo "HDFS is now empty."

# shut down HDFS
echo "Stopping HDFS..."
${HDFS_BIN}/stop-dfs.sh > /dev/null
sleep $(( 2 * $HDFS_STARTUP_CHECK_INTERVAL ))
echo "HDFS is now stopped."
