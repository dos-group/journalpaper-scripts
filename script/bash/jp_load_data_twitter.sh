#!/bin/bash

# Starts a Hadoop MapReduce job to generate the data for word count tasks.
# Parameters:
# 1) scaling factor (sf = 1 ~ 1GB data)
# 2) node count
# 3) dataset ID
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

INPUT=$1
OUTPUT=$2

if [[ $INPUT == '' ]]; then
   echo "You need to specify a local input file. Canceling..."
   exit 1
fi

if ! [[ "$OUTPUT" == '' ]]; then
   echo "You need to specify HDFS target path. Canceling..."
   exit 1
fi

# load configuration
. ./jp_env_configure.sh

# start hadoop_mr
./jp_hdp_mapr_start_wait.sh
if [[ $? != 0 ]]; then
   # start hadoop_mr (second try)
   ./jp_hdp_mapr_stop.sh
   ./jp_hdp_mapr_start_wait.sh
   if [[ $? != 0 ]]; then
      exit $?
   fi
fi

# generate wc data
${HDFS_BIN}/hadoop fs -copyFromLocal $INPUT $OUTPUT
if [[ $? != 0 ]]; then
   echo "Error copying data to HDFS!"
   exit $?
fi
echo "Connected components dataset copied to HDFS."

# stop hadoop_mr
./jp_hdp_mapr_stop.sh
