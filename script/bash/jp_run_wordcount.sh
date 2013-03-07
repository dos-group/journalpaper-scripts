#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

WC_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
WC_SCALING_FACTOR=$(( ${WC_NODE_COUNT} / 4 ))
WC_DGEN_ID=`printf "wordcount-sf%04d" ${WC_SCALING_FACTOR}`
WC_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${WC_DGEN_ID}/gutenberg.txt
WC_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# generate wordcount input data
./jp_load_data_wordcount.sh ${WC_SCALING_FACTOR} ${WC_NODE_COUNT} ${WC_DGEN_ID}
if [[ $? != 0 ]]; then
   exit $?
fi

# repeat Hadoop runs
execIdPrefix=`printf "wc-hdp_mapr-dop%04d" ${WC_NODE_COUNT}`
./jp_run_repeated.sh HDP_MAPR $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-hadoop.jar ${WC_IN} ${WC_OUT}"

# repeat Stratosphere runs
execIdPrefix=`printf "wc-str_pact-dop%04d" ${WC_NODE_COUNT}`
./jp_run_repeated.sh STR_PACT $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-pact.jar -a ${WC_NODE_COUNT} ${WC_IN} ${WC_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
