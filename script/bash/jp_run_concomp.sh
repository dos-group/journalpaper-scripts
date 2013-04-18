#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

CC_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
CC_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/twitter-icwsm2010/links-anon.txt
CC_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}/twitter-concomp_result

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# generate terasort input data
./jp_load_data_twitter.sh ${CC_IN} ${CC_OUT}
if [[ $? != 0 ]]; then
   exit $?
fi

# repeat Hadoop runs
execIdPrefix=`printf "cc-hdp_grph-sf0037-dop%04d" ${CC_NODE_COUNT}`
./jp_run_repeated.sh HDP_GRPH $execIdPrefix "org.apache.giraph.examples.ConnectedComponentsVertex -eif org.apache.giraph.io.formats.IntNullReverseTextEdgeInputFormat -eip ${CC_IN} -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op ${CC_OUT} -w ${CC_NODE_COUNT} -c org.apache.giraph.combiner.MinimumIntCombiner"

# repeat Stratosphere runs
#execIdPrefix=`printf "cc-str_pact-sf0037-dop%04d" ${CC_NODE_COUNT}`
#./jp_run_repeated.sh STR_PACT $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-pact.jar -a ${CC_NODE_COUNT} ${CC_IN} ${CC_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
