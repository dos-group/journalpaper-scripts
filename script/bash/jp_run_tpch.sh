#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

TPCH_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
TPCH_SCALING_FACTOR=$((1 * ${TPCH_NODE_COUNT}))
TPCH_DGEN_ID=`printf "terasort-%04d" ${TPCH_SCALING_FACTOR}`
TPCH_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${TPCH_DGEN_ID}/terasort.txt
TPCH_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# generate wordcount input data
./jp_load_data_terasort.sh ${TPCH_SCALING_FACTOR} ${TPCH_NODE_COUNT} ${TPCH_DGEN_ID}
if [[ $? != 0 ]]; then
   exit $?
fi

# repeat Hadoop runs
execIdPrefix=`printf "ts-hdp_mapr-dop%04d" ${TPCH_NODE_COUNT}`
./jp_run_repeated.sh HDP_HIVE $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-tpch-hadoop.jar ${TPCH_IN} ${TPCH_OUT}"

# repeat Stratosphere runs
execIdPrefix=`printf "ts-str_pact-dop%04d" ${TPCH_NODE_COUNT}`
./jp_run_repeated.sh STR_METR $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-tpch-pact.jar -a ${TPCH_NODE_COUNT} ${TPCH_IN} ${TPCH_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
