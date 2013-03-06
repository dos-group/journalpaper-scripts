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
DGEN_ID=`printf "terasort-%04d" ${SCALING_FACTOR}`
TS_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${DGEN_ID}/terasort.txt
TS_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# deploy systems
#./jp_hadoop_deploy.sh
#./jp_stratosphere_deploy.sh

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
./jp_load_data_terasort.sh ${SCALING_FACTOR} ${NODE_COUNT} ${DGEN_ID}
if [[ $? != 0 ]]
then  
  exit $?
fi

# stop hadoop_mr
./jp_hadoop_mr_stop.sh

# repeat Hadoop runs
execIdPrefix=`printf "ts-hdp_mapr-dop%04d" ${NODE_COUNT}`
./jp_run_repeated.sh HDP $execIdPrefix "${JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-hadoop.jar ${TS_IN} ${TS_OUT}"

# repeat Stratosphere runs
execIdPrefix=`printf "ts-str_pact-dop%04d" ${NODE_COUNT}`
./jp_run_repeated.sh STR $execIdPrefix "${JOBS_HOME}/journalpaper-jobs-1.0.0-terasort-pact.jar -a ${NODE_COUNT} ${TS_IN} ${TS_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
