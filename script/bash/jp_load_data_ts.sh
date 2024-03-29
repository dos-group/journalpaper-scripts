#!/bin/bash

# Starts a Hadoop MapReduce job to generate the data for word count tasks.
# Parameters:
# 1) scaling factor (sf = 1 ~ 1GB data)
# 2) node count
# 3) dataset ID
#
# Author: Fabian Hueske (fabian.hueske@tu-berlin.de)
# Author: Alexander Alexandrov (alexander.alexandrov@tu-berlin.de)

SCALING_FACTOR=$1
NODE_COUNT=$2
DATASET_ID=$3

if [[ $SCALING_FACTOR == '' ]]; then
   echo "You need to specify scaling factor per slave. Canceling..."
   exit 1
fi

if ! [[ "$NODE_COUNT" =~ ^[0-9]+$ ]]; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

if [[ $DATASET_ID == '' ]]; then
   echo "You need to specify dataset ID. Canceling..."
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
${HDP_MAPR_BIN}/hadoop jar ${EXP_TS_DGEN_HOME}/bin/tera-gen-driver-jobs.jar ${EXP_TS_DGEN_HOME} -s${SCALING_FACTOR} -N${NODE_COUNT} -m${DATASET_ID} -o${HDFS_INPUT_PATH} -xrecord
echo "TeraSort data generated."

# stop hadoop_mr
./jp_hdp_mapr_stop.sh
