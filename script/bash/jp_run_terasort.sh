#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

TS_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
TS_SCALING_FACTOR=$(( ${TS_NODE_COUNT} / 4 ))
TS_DGEN_ID=`printf "terasort-sf%04d" ${TS_SCALING_FACTOR}`
TS_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${TS_DGEN_ID}/terasort.txt
TS_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# generate terasort input data
./jp_load_data_terasort.sh ${TS_SCALING_FACTOR} ${TS_NODE_COUNT} ${TS_DGEN_ID}
if [[ $? != 0 ]]; then
   exit $?
fi

# repeat Hadoop runs
execIdPrefix=`printf "ts-hdp_mapr-dop%04d" ${TS_NODE_COUNT}`
./jp_run_repeated.sh HDP_MAPR $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-hadoop.jar ${TS_IN} ${TS_OUT}"

# repeat Stratosphere runs
execIdPrefix=`printf "ts-str_pact-dop%04d" ${TS_NODE_COUNT}`
./jp_run_repeated.sh STR_PACT $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-pact.jar -a ${TS_NODE_COUNT} ${TS_IN} ${TS_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
