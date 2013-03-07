#!/bin/bash

NUM_SLAVES=$1

# check that $NUM_SLAVES is set
if ! [[ "$NUM_SLAVES" =~ ^[0-9]+$ ]] ; then
   echo "You need to specify DOP. Canceling..."
   exit 1
fi

# load config
. ./jp_env_configure.sh

NODE_COUNT=$((${HDP_MAPR_MAP_SLOTS_PER_SLAVE} * ${NUM_SLAVES}))
SCALING_FACTOR=$((1 * ${NODE_COUNT}))
DGEN_ID=`printf "wordcount-%04d" ${SCALING_FACTOR}`
WC_IN=${HDFS_ADDRESS}${HDFS_INPUT_PATH}/${DGEN_ID}/gutenberg.txt
WC_OUT=${HDFS_ADDRESS}${HDFS_OUTPUT_PATH}

# deploy systems
./jp_sut_deploy.sh ${HDP_MAPR_TAR} ${HDP_MAPR_HOME}
./jp_sut_deploy.sh ${STR_PACT_TAR} ${STR_PACT_HOME}

# adapt number of slaves
./jp_env_adapt_slave_cnt.sh $NUM_SLAVES

# format and start HDFS
./jp_hdfs_format_start_wait.sh
if [[ $? != 0 ]]
then
   exit $?
fi

# start hadoop_mr
./jp_hdp_mapr_start_wait.sh
if [[ $? != 0 ]]
then
   exit $?
fi

# generate wordcount input data
./jp_load_data_wordcount.sh ${SCALING_FACTOR} ${NODE_COUNT} ${DGEN_ID}
if [[ $? != 0 ]]
then
   exit $?
fi

# stop hadoop_mr
./jp_hdp_mapr_stop.sh

# repeat Hadoop runs
execIdPrefix=`printf "wc-hdp_mapr-dop%04d" ${NODE_COUNT}`
./jp_run_repeated.sh HDP $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-hadoop.jar ${WC_IN} ${WC_OUT}"

# repeat Stratosphere runs
execIdPrefix=`printf "wc-str_pact-dop%04d" ${NODE_COUNT}`
./jp_run_repeated.sh STR $execIdPrefix "${EXP_JOBS_HOME}/journalpaper-jobs-1.0.0-wordcount-pact.jar -a ${NODE_COUNT} ${WC_IN} ${WC_OUT}"

# stop HDFS
./jp_hdfs_clean_stop.sh
