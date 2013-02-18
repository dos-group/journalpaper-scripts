#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
  echo "You need to specify DOP. Canceling..."
  exit 1
fi

# load config
. ./jp_configure.sh

NODE_COUNT=$((${HADOOPMR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
SCALING_FACTOR=$((1 * ${NODE_COUNT}))
WC_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/gutenberg-1GB/gutenberg.txt
WC_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# adapt number of slaves
./jp_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]
then  
  exit $?
fi

# start hadoop_mr
./jp_hadoop_mr_start_wait.sh
if [[ $? != 0 ]]
then  
  exit $?
fi

# generate wordcount input data
./jp_load_data_wordcount.sh ${SCALING_FACTOR} ${NODE_COUNT} gutenberg-1GB
if [[ $? != 0 ]]
then  
  exit $?
fi

# stop hadoop_mr
./jp_hadoop_mr_stop.sh

# repeat Hadoop runs
./jp_run_repeated.sh HMR wc-hadoop_mr-${NODE_COUNT} "${JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-hadoop.jar ${WC_IN} ${WC_OUT}"

# repeat Stratosphere runs
./jp_run_repeated.sh STR wc-pact-${NODE_COUNT} "${JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-pact.jar -a ${NODE_COUNT} ${WC_IN} ${WC_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
