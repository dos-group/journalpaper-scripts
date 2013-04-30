#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

CC_DATASET_LOCAL=${EXP_TWITTER_DATA_LOCAL}
CC_NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
CC_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/$(basename ${CC_DATASET_LOCAL})
CC_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]; then
   exit $?
fi

# copy twitter dataset to HDFS
./jp_load_data_local.sh ${CC_DATASET_LOCAL} ${CC_IN}
if [[ $? != 0 ]]; then
   exit $?
fi

# repeat Hadoop runs
execIdPrefix=`printf "cc-hdp_grph-sf0037-dop%04d" ${CC_NODE_COUNT}`
./jp_run_repeated.sh HDP_GRPH $execIdPrefix "org.apache.giraph.examples.ConnectedComponentsVertex -vif org.apache.giraph.io.formats.IntIntNullTextInputFormat -vip ${CC_IN}/adjacency -of org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op ${CC_OUT} -w $[CC_NODE_COUNT-1] -c org.apache.giraph.combiner.MinimumIntCombiner"

# repeat Stratosphere runs
execIdPrefix=`printf "cc-str_iter-sf0037-dop%04d" ${CC_NODE_COUNT}`
./jp_run_repeated.sh STR_ITER $execIdPrefix "eu.stratosphere.pact.runtime.iterative.compensatable.connectedcomponents.CompensatableConnectedComponents ${CC_NODE_COUNT} ${HDP_MAPR_MAP_SLOTS_PER_SLAVE} ${CC_IN}/vertices/ ${CC_IN}/initialWorkset/ ${CC_IN}/adjacency/ ${CC_OUT} ${STR_PACT_CONF} 1280 960 640 1 300 0.5"

# stop HDFS
./jp_hdfs_clean_stop.sh
