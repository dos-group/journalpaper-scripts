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
DGEN_ID=`printf "tpch-%04d" ${SCALING_FACTOR}`
TS_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${DGEN_ID}/terasort.txt
TS_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# deploy systems
./jp_deploy_sut.sh ${HADOOPMR_TAR} ${HADOOPMR_HOME}
./jp_deploy_sut.sh ${STRATOSPHERE_TAR_METEOR} ${STRATOSPHERE_HOME}

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
./jp_load_data_tpch.sh ${SCALING_FACTOR} ${NODE_COUNT} ${DGEN_ID}
if [[ $? != 0 ]]
then  
  exit $?
fi

# stop hadoop_mr
./jp_hadoop_mr_stop.sh

# TODO: repeat Hadoop Hive runs
execIdPrefix=`printf "tpch-hdp_hive-dop%04d" ${NODE_COUNT}`
./jp_run_repeated.sh HDP $execIdPrefix "${JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-hadoop.jar ${TS_IN} ${TS_OUT}"

# TODO: repeat Stratosphere Meteor runs
execIdPrefix=`printf "tpch-str_mtor-dop%04d" ${NODE_COUNT}`
./jp_run_repeated.sh MET $execIdPrefix "${JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-pact.jar -a ${NODE_COUNT} ${TS_IN} ${TS_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
