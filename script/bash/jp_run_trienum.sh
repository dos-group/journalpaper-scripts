#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

TE_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
TE_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/twitter-icwsm2010/links-anon.txt
TE_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}/twitter-trienum_result

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# copy twitter dataset to HDFS
./jp_load_data_twitter.sh ${EXP_TWITTER_DATA_LOCAL} ${TE_IN}
if [[ $? != 0 ]]; then
   exit $?
fi

# repeat Hadoop runs
#execIdPrefix=`printf "te-hdp_mapr-sf0037-dop%04d" ${TE_NODE_COUNT}`
#./jp_run_repeated.sh HDP_PACT $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-trienum-hadoop.jar -a ${TE_NODE_COUNT} ${TE_IN} ${TE_OUT}"

# repeat Stratosphere runs
execIdPrefix=`printf "te-str_pact-sf0037-dop%04d" ${TE_NODE_COUNT}`
./jp_run_repeated.sh STR_PACT $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-trienum-pact.jar -a ${TE_NODE_COUNT} ${TE_IN} ${TE_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
